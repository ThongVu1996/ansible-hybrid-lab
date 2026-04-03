# 1. Khởi tạo mạng
module "network" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

# 2. Lấy dữ liệu từ "Két sắt" bạn đã tạo
data "vault_generic_secret" "laravel_secrets" {
  # Lưu ý: Với KV-V2, đường dẫn phải có thêm chữ "data/" ở giữa
  path = "secret/data/laravel/production" 
}

# 3. Cung cấp cho Web Server
module "web_server" {
  source          = "./modules/ec2"
  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.public_subnet_id
  key_name        = var.key_name
  host_name       = var.host_name
  
  // Bóc tách đúng các KEY bạn đã lưu trong Vault JSON
  ts_auth_key     = data.vault_generic_secret.laravel_secrets.data["ts_key"]
  ts_client_id    = data.vault_generic_secret.laravel_secrets.data["ts_client_id"]
  ssh_private_key = data.vault_generic_secret.laravel_secrets.data["ssh_private_key"]
}
