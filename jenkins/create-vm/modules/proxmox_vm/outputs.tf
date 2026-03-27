output "vm_ip" {
  description = "Địa chỉ IPv4 của Jenkins VM"
  value       = proxmox_virtual_environment_vm.jenkins_node[0].initialization[0].ip_config[0].ipv4[0].address
}

output "tailscale_login" {
  description = "Lệnh SSH qua mạng Tailscale"
  value       = "Sử dụng: 'tailscale ssh ${var.user_name}@jenkins-server' để truy cập."
}

