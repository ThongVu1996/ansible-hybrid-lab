variable "vm_instance_count" {
  description = "Số lượng máy ảo (Bằng 0 sẽ xóa máy ảo)"
  type        = number
  default     = 1
}

variable "vm_name" {
  description = "Tên cơ bản cho máy ảo"
  type        = string
  default     = "vm-proxmox-lab"
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

variable "user_password" {
  description = "Mật khẩu đăng nhập qua Console/SSH của user"
  type        = string
  sensitive   = true
}

variable "user_name" {
  description = "Tên user dùng để ssh vào máy vm"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale Auth Key lấy từ Vault"
  type        = string
  sensitive   = true
}



variable "vm_ip_cidr" {
  type = string
}

variable "vm_gateway" {
  type = string
}
