output "vm_ip" {
  description = "Địa chỉ IP của máy ảo đã khởi tạo"
  value       = module.proxmox_vm.vm_ip
}

output "tailscale_login" {
  description = "Hướng dẫn câu lệnh sử dụng Tailscale SSH để kết nối"
  value       = module.proxmox_vm.tailscale_login
  sensitive   = true
}

