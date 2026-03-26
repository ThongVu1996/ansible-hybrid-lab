# 1. Tạo một mã bí mật cho Tunnel (Random)
resource "random_password" "tunnel_secret" {
  length  = 64
  special = false
}

# 2. Tạo Cloudflare Tunnel
resource "cloudflare_tunnel" "jenkins_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "jenkins-lab-tunnel"
  secret     = random_password.tunnel_secret.result
}

# 3. Cấu hình Tunnel (Trỏ từ Internet vào IP nội bộ 172.199.10.150)
resource "cloudflare_tunnel_config" "jenkins_config" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.jenkins_tunnel.id

  config {
    ingress {
      hostname = "${var.jenkins_subdomain}.thongdev.site"
      service  = "http://172.199.10.150:8080"
    }
    # Catch-all rule (trả về 404 cho các request khác)
    ingress {
      service = "http_status:404"
    }
  }
}

# 4. Tự động tạo bản ghi DNS (CNAME) trỏ về Tunnel
resource "cloudflare_record" "jenkins_dns" {
  zone_id = var.cloudflare_zone_id
  name    = var.jenkins_subdomain
  value   = "${cloudflare_tunnel.jenkins_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

# 5. Output để bạn lấy Token chạy lệnh "cloudflared tunnel run"
output "cloudflare_tunnel_token" {
  value     = cloudflare_tunnel.jenkins_tunnel.tunnel_token
  sensitive = true
}

