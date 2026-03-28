resource "tailscale_tailnet_key" "jenkins_key" {
  reusable      = false
  ephemeral     = false # Chuyển sang false để máy ảo không bị xóa khỏi Tailscale khi offline
  preauthorized = true
  expiry        = 3600
  tags          = ["tag:jenkins"]
}

# 1. Dò tìm máy ảo mẫu (Template)
data "proxmox_virtual_environment_vms" "ubuntu_template" {
  node_name = var.proxmox_node
  filter {
    name   = "name"
    values = [var.proxmox_template_name]
  }
}

# 2. Tạo file Cloud-init Snippet tự động cho Jenkins
resource "proxmox_virtual_environment_file" "jenkins_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node
  count        = var.vm_instance_count

  source_raw {
    file_name = "jenkins-init-${count.index}.yml"
    data      = <<-EOF
      #cloud-config
      ssh_fp_console: false
      hostname: jenkins-lab-${count.index}
      output: { all: ">> /dev/ttyS0" }

      users:
        - name: ${var.user_name}
          groups: sudo
          shell: /bin/bash
          sudo: ALL=(ALL) NOPASSWD:ALL
          lock_passwd: false
          password: "${var.user_password}"

      # Cài đặt các gói cơ bản để Ansible có thể chạy được (Python)
      packages:
        - curl
        - python3
        - python3-pip

      runcmd:
        - [ sh, -c, "echo '--- [0/3] Dang doi apt lock... ---' > /dev/ttyS0" ]
        - [ sh, -c, "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done;" ]

        - [ sh, -c, "echo '--- [1/3] Cap nhat Repo & Cai Tailscale... ---' > /dev/ttyS0" ]
        - sed -i "s/[a-z]*.archive.ubuntu.com/vn.archive.ubuntu.com/g" /etc/apt/sources.list
        - apt-get update -y
        - [ sh, -c, "curl -fsSL https://tailscale.com/install.sh | sh > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '--- [2/3] Tu dong join vao Tailscale voi unique hostname... ---' > /dev/ttyS0" ]
        - [ sh, -c, "tailscale up --authkey=${tailscale_tailnet_key.jenkins_key.key} --hostname=jenkins-lab-${count.index} --ssh --accept-dns=true --accept-routes=true > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '=== VM READY FOR ANSIBLE ===' > /dev/ttyS0" ]
    EOF
  }
}

# 3. Khởi tạo Máy ảo Jenkins
resource "proxmox_virtual_environment_vm" "jenkins_node" {
  name      = "vm-jenkins-lab-${count.index}"
  node_name = var.proxmox_node
  count     = var.vm_instance_count

  clone {
    vm_id = data.proxmox_virtual_environment_vms.ubuntu_template.vms[0].vm_id
  }

  serial_device {}
  vga { type = "serial0" }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_ip_cidr}"
        gateway = "${var.vm_gateway}"
      }
    }
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
    user_data_file_id = proxmox_virtual_environment_file.jenkins_config[count.index].id
  }

  cpu { cores = 2 }
  memory { dedicated = 4096 }
  network_device { bridge = "vmbr0" }
}
