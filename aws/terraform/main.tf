# 1. Khởi tạo Hạ tầng mạng (VPC, Subnet, v.v.)
module "network" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

# 2. Khởi tạo Máy chủ Web (EC2)
module "web_server" {
  source          = "./modules/ec2"
  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.public_subnet_id
  key_name        = var.key_name
  ts_auth_key     = var.ts_auth_key
  ssh_private_key = var.ssh_private_key
  tailnet_name = var.tailnet_name 
  ts_client_id = var.ts_client_id
}
