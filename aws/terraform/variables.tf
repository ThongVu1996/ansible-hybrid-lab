variable "AWS_DEFAULT_REGION" {
  type    = string
  default = "ap-southeast-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "key_name" {
  description = "Tên SSH Key Pair trên AWS"
  type        = string
}

variable "host_name" {
  description = "Tên MagicDNS trong Tailscale"
  type        = string
  default     = "aws-web-server"
}
