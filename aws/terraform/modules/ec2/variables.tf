variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "key_name" {
  description = "Existing SSH key pair name for EC2 access"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH Private Key for Git clone"
  type        = string
  sensitive   = true
}

variable "ts_auth_key" {
  description = "Tailscale Auth Key"
  type        = string
  sensitive   = true
}

variable "host_name" {
  description = "Tên của máy ảo (MagicDNS) trong Tailscale"
  type        = string
}