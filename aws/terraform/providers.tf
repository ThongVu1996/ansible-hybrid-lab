provider "aws" {
  region = var.AWS_DEFAULT_REGION
}
provider "vault" {
  # TFC sẽ tự động truyền VAULT_ADDR, VAULT_NAMESPACE và TOKEN qua biến môi trường.
  # Bạn không cần khai báo address cứng ở đây để bảo mật hơn.
  address   = "https://ansible-vault-cluster-public-vault-93de3318.9a219761.z1.hashicorp.cloud:8200"
  namespace = "admin"
}