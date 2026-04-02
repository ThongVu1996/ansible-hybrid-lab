variable "AWS_DEFAULT_REGION" {
  description = "Region bạn muốn triển khai (Vd: ap-southeast-1)"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "Dải IP của VPC (Vd: 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "key_name" {
  description = "Tên SSH Key Pair đã có trên AWS để truy cập EC2"
  type        = string
}

variable "ts_auth_key" {
  description = "Tailscale Auth Key để join node vào tailnet (dùng cho Ansible)"
  type        = string
  sensitive   = true
}

variable "db_host_tailscale" {
  description = "Hostname MagicDNS của máy DB ở Proxmox"
  type        = string
}

variable "db_password" {
  description = "Mật khẩu Database trên máy Proxmox"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Tên Database"
  type        = string
}

variable "db_user" {
  description = "User Database"
  type        = string
  sensitive   = true # Thêm để ẩn user ra khỏi logs
}

variable "ssh_private_key" {
  description = "Private Key để clone git"
  type        = string
  sensitive   = true
}

variable "tailnet_name" {
  description = "Tên Tailnet của bạn (Vd: thongvu.github)"
  type        = string
  sensitive   = true # Thêm để ẩn tên mạng ra khỏi logs
}

variable "ts_client_id" {
  description = "OAuth Client ID (Cái dãy chữ dài dài nhăm nhăm trong hình bạn chụp)"
  type        = string
}