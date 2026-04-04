# 1. Dò tìm máy ảo mẫu (Template)
data "proxmox_virtual_environment_vms" "ubuntu_template" {
  node_name = var.proxmox_node
  filter {
    name   = "name"
    values = [var.proxmox_template_name]
  }
}

# 2. Tạo file Cloud-init Snippet tự động
resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node
  count        = var.vm_instance_count

  source_raw {
    file_name = "vm-init-${var.vm_name}-${count.index}.yml"
    data      = <<-EOF
      #cloud-config
      ssh_pwauth: true
      output: { all: ">> /dev/ttyS0" }

      users:
        - name: ${var.user_name}
          groups: sudo
          shell: /bin/bash
          sudo: ["ALL=(ALL) NOPASSWD:ALL"]
          lock_passwd: false
          password: ${var.user_password}

      # Đảm bảo có CURL để cài Tailscale
      packages:
        - curl

      runcmd:
        - [ sh, -c, "echo '--- [0/4] Doi giai phong apt lock... ---' > /dev/ttyS0" ]
        - [ sh, -c, "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done;" ]

        - [ sh, -c, "echo '--- [1/4] Kiem tra mang... ---' > /dev/ttyS0" ]
        - [ sh, -c, "ping -c 3 8.8.8.8 > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '--- [2/4] Cap nhat Repo & Cai Tailscale... ---' > /dev/ttyS0" ]
        - sed -i "s/[a-z]*.archive.ubuntu.com/vn.archive.ubuntu.com/g" /etc/apt/sources.list
        - apt-get update -y
        - [ sh, -c, "rm -rf /var/lib/tailscale/tailscaled.state" ]
        - [ sh, -c, "curl -fsSL https://tailscale.com/install.sh | sh > /dev/ttyS0 2>&1" ]
        
        - [ sh, -c, "echo '--- [3/4] Kick hoat Tailscale... ---' > /dev/ttyS0" ]
        # SỬ DỤNG AUTH KEY TỪ VAULT:
        - [ sh, -c, "tailscale up --authkey=${var.tailscale_auth_key} --hostname=${var.vm_name}-${count.index} --ssh --accept-dns=true --advertise-tags=tag:db-server > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '=== SETUP COMPLETED SUCCESSFULLY ===' > /dev/ttyS0" ]
    EOF
  }
}

# 3. Khởi tạo Máy ảo
resource "proxmox_virtual_environment_vm" "lab_node" {
  name      = "${var.vm_name}-${count.index}"
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
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config[count.index].id
  }

  cpu { cores = 2 }
  memory { dedicated = 4096 }
  network_device { bridge = "vmbr0" }
}
