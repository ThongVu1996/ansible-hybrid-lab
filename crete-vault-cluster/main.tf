terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.80.0"
    }
  }
}

variable "hcp_hvn_id"     { type = string }
variable "hcp_hvn_cloud_provider" { type = string }
variable "hcp_hvn_region"  { type = string } 
variable "hcp_hvn_cidr_block"     { type = string }
variable "hcp_vault_cluster_cluster_id"       { type = string }
variable "hcp_vault_cluster_tier"     { type = string }

provider "hcp" {
  # Terraform sẽ tự đọc từ biến môi trường HCP_CLIENT_ID và HCP_CLIENT_SECRET
}

# 1. Tạo mạng nội bộ HVN (Dùng biến đã khai báo)
resource "hcp_hvn" "main_hvn" {
  hvn_id         = var.hcp_hvn_id
  cloud_provider = var.hcp_hvn_cloud_provider
  region         = var.hcp_hvn_region
  cidr_block     = var.hcp_hvn_cidr_block
}

# 2. Khởi tạo Vault Cluster (Dùng biến đã khai báo)
resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id      = var.hcp_vault_cluster_cluster_id
  hvn_id          = hcp_hvn.main_hvn.hvn_id
  tier            = var.hcp_vault_cluster_tier
  public_endpoint = true
}

# 3. Output URL để dán vào Jenkins
output "vault_public_url" {
  value = hcp_vault_cluster.vault_cluster.vault_public_endpoint_url
}
