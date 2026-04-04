# Cấu hình Provider cho Proxmox
provider "proxmox" {
  endpoint  = var.proxmox_ve_endpoint 
  api_token = data.vault_kv_secret_v2.laravel_secrets.data["proxmox_ve_api_token"]
  insecure  = true

  ssh {
    agent       = false
    username    = "terraform-user"
    private_key = data.vault_kv_secret_v2.laravel_secrets.data["proxmox_ssh_private_key"]
  }
}

# Cấu hình Provider cho Vault
provider "vault" {
  address          = var.vault_addr
  namespace        = "admin"
  skip_child_token = true
}
