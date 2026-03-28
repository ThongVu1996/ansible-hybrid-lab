output "vm_ips" {
  description = "Danh sách địa chỉ IP cố định của các máy ảo Jenkins"
  value       = module.jenkins_vm.vm_ips
}

output "tailscale_ssh_commands" {
  description = "Các lệnh SSH để truy cập qua mạng Tailscale"
  value       = module.jenkins_vm.tailscale_ssh_commands
}
