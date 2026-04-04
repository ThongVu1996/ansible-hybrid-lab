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
  default     = "pve2"
}

variable "vm_ip_cidr" {
  type        = string
  description = "IP address của máy ảo (ví dụ: [IP_ADDRESS])"
}

variable "proxmox_ve_endpoint" {
  description = "Link API Proxmox"
  type        = string
}

variable "vm_gateway" {
  type        = string
  description = "Gateway của máy ảo (ví dụ: [IP_ADDRESS])"
}

variable "vault_addr" {
  description = "Link API Vault (Bắt buộc)"
  type        = string
}