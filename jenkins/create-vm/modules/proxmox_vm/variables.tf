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

variable "user_password" {
  description = "Mật khẩu đăng nhập của user iadmin"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_private_key" {
  description = "Nội dung Private Key SSH kết nối vào Proxmox"
  type        = string
  sensitive   = true
}

variable "user_name" {
  description = "Tên user dùng để ssh vào máy vm"
  type        = string
  default     = "iadmin"
}

variable "vm_ip_cidr" {
  description = "IP/CIDR của máy ảo"
  type        = string
}

variable "vm_gateway" {
  description = "Gateway của mạng"
  type        = string
}

