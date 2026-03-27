variable "vm_instance_count" {
  description = "Số lượng máy ảo Jenkins (Bằng 0 sẽ xóa máy ảo)"
  type        = number
  default     = 1
}

variable "proxmox_template_name" {
  description = "Tên của Template Ubuntu trên Proxmox đã dựng sẵn"
  type        = string
  default     = "ubuntu-template"
}

variable "proxmox_node" {
  description = "Tên node của Proxmox (thường là 'pve')"
  type        = string
  default     = "pve"
}

variable "user_name" {
  description = "Tên user dùng để ssh vào máy vm (mặc định là iadmin)"
  type        = string
  default     = "iadmin"
}

variable "user_password" {
  description = "Mật khẩu đăng nhập qua Console/SSH của user"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_private_key" {
  description = "Nội dung Private Key SSH kết nối vào Proxmox"
  type        = string
  sensitive   = true
}

variable "vm_ip_cidr" {
  type        = string
  description = "IP address của máy ảo (ví dụ: 192.168.1.100/24)"
}

variable "vm_gateway" {
  type        = string
  description = "Gateway của máy ảo (ví dụ: 192.168.1.1)"
}

variable "tailscale_auth_key" {
  description = "Tailscale Auth Key (Optional if not using resource)"
  type        = string
  sensitive   = true
  default     = ""
}
