terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.80.0"
    }
  }
}

provider "hcp" {
  # Terraform sẽ tự đọc từ biến môi trường HCP_CLIENT_ID và HCP_CLIENT_SECRET
}

# 1. Tạo mạng nội bộ HVN (Cực kỳ quan trọng để Vault chạy)
resource "hcp_hvn" "main_hvn" {
  hvn_id         = "ansible-lab-hvn"
  cloud_provider = "aws"
  region         = "ap-southeast-1"
  cidr_block     = "10.0.0.0/16"
}

# 2. Khởi tạo Vault Cluster (Gói Dev - Public Endpoint)
resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id      = "ansible-vault-cluster"
  hvn_id          = hcp_hvn.main_hvn.hvn_id
  tier            = "dev"
  public_endpoint = true
}

# 3. Output URL để dán vào Jenkins
output "vault_public_url" {
  value = hcp_vault_cluster.vault_cluster.vault_public_endpoint_url
}
