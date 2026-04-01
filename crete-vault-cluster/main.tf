terraform {
  required_providers {
    hcp   = { source = "hashicorp/hcp", version = "~> 0.80.0" }
    vault = { source = "hashicorp/vault", version = "~> 3.24.0" }
  }
}

# --- BIẾN HẠ TẦNG (Giai đoạn 1) ---
variable "hcp_hvn_id" { type = string }
variable "hcp_hvn_cloud_provider" { type = string }
variable "hcp_hvn_region" { type = string }
variable "hcp_hvn_cidr_block" { type = string }
variable "hcp_vault_cluster_cluster_id" { type = string }
variable "hcp_vault_cluster_tier" { type = string }

# --- BIẾN LOGIC (Giai đoạn 2) ---
variable "tfc_organization" {
  type = string
}
variable "tfc_workspace" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "tailscale_key" {
  type      = string
  sensitive = true
}
variable "VAULT_TOKEN" {
  type      = string
  sensitive = true
}
# --- PROVIDERS ---
provider "hcp" {}

provider "vault" {
  address   = hcp_vault_cluster.vault_cluster.vault_public_endpoint_url
  namespace = "admin"
  token     = var.VAULT_TOKEN # Lần này ta dùng token thủ công để "mở cửa" OIDC
}

# --- RESOURCES HẠ TẦNG (Đã có sẵn) ---
resource "hcp_hvn" "main_hvn" {
  hvn_id         = var.hcp_hvn_id
  cloud_provider = var.hcp_hvn_cloud_provider
  region         = var.hcp_hvn_region
  cidr_block     = var.hcp_hvn_cidr_block
}

resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id      = var.hcp_vault_cluster_cluster_id
  hvn_id          = hcp_hvn.main_hvn.hvn_id
  tier            = var.hcp_vault_cluster_tier
  public_endpoint = true
}

# --- GIAI ĐOẠN 2: THIẾT LẬP CÁI BẮT TAY OIDC ---

resource "vault_jwt_auth_backend" "tfc_auth" {
  path               = "jwt"
  type               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc_role" {
  backend        = vault_jwt_auth_backend.tfc_auth.path
  role_name      = "tfc-role"
  token_policies = ["default", "hcp-root"]
  bound_audiences = ["vault.workload.identity"] 
  bound_claims_type = "glob"
   bound_claims = {
    sub = "organization:${var.tfc_organization}:project:*:workspace:${var.tfc_workspace}:run_phase:*"
  }
  user_claim = "sub"
  role_type  = "jwt"
}

# --- GIAI ĐOẠN 3: APP ROLE CHO JENKINS & SECRETS ---
# Bật Két sắt (Phòng chứa mật khẩu) - QUAN TRỌNG!
resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv-v2"
  description = "KV2 secrets engine cho Laravel"
}
resource "vault_auth_backend" "approle" { type = "approle" }
resource "vault_policy" "jenkins_policy" {
  name   = "jenkins-policy"
  policy = <<EOT
path "secret/data/laravel/production" { capabilities = ["read"] }
EOT
}
resource "vault_approle_auth_backend_role" "jenkins_role" {
  backend        = vault_auth_backend.approle.path
  role_name      = "jenkins-role"
  token_policies = ["default", vault_policy.jenkins_policy.name]
}
resource "vault_generic_secret" "laravel_prod" {
  # Đợi cái Két sắt bật xong mới đẩy mật khẩu vào
  depends_on = [vault_mount.kvv2]
  path       = "secret/data/laravel/production"
  data_json = jsonencode({
    db_pass = var.db_password
    ts_key  = var.tailscale_key
  })
}
# --- OUTPUTS ---
output "vault_public_url" { value = hcp_vault_cluster.vault_cluster.vault_public_endpoint_url }
output "jenkins_role_id" { value = vault_approle_auth_backend_role.jenkins_role.role_id }
