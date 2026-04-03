variable "tfc_organization" {
  description = "Tên Organization trên Terraform Cloud của bạn"
  type        = string
}

variable "tfc_project" {
  description = "Tên Project trên Terraform Cloud (Mặc định là Default Project)"
  type        = string
  default     = "Default Project"
}

variable "aws_oidc_role_name" {
  description = "Tên của IAM Role bạn muốn tạo cho Terraform"
  type        = string
  default     = "HCPTerraformExecutionRole"
}

