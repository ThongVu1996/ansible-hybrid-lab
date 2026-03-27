output "vm_ip" {
  description = "Địa chỉ IP cố định của Jenkins Server"
  value       = module.jenkins_vm.vm_ip
}

output "tailscale_login" {
  description = "Hướng dẫn kết nối với máy chủ qua Tailscale"
  value       = module.jenkins_vm.tailscale_login
}

