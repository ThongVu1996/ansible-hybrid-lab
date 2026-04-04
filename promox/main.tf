data "vault_kv_secret_v2" "laravel_secrets" {
  mount = "secret"
  name  = "laravel/production"
}

module "proxmox_vm" {
  source = "./modules/proxmox_vm"
  
  vm_instance_count       = var.vm_instance_count
  vm_name                 = var.vm_name
  proxmox_template_name   = var.proxmox_template_name
  proxmox_node            = var.proxmox_node
  user_password           = data.vault_kv_secret_v2.laravel_secrets.data["user_password"]
  user_name               = data.vault_kv_secret_v2.laravel_secrets.data["user_name"]
  tailscale_auth_key      = data.vault_kv_secret_v2.laravel_secrets.data["tailscale_auth_key_vm_in_promox"]
  vm_ip_cidr              = var.vm_ip_cidr
  vm_gateway              = var.vm_gateway
}

