terraform {
  # 1. Kết nối lên HCP Terraform
  cloud {
    organization = "tonytechlab-group"
    workspaces {
      name = "hybrid-aws"
    }
  }

  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
