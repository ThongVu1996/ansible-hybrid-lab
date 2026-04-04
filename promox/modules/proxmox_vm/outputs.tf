output "vm_ip" {
  description = "Địa chỉ IP của máy ảo đã khởi tạo"
  value       = var.vm_ip_cidr
}

output "tailscale_login" {
  description = "Hướng dẫn câu lệnh sử dụng Tailscale SSH để kết nối"
  value       = "Sử dụng: 'tailscale ssh ${var.user_name}@${var.vm_name}-0' để truy cập."
}
