# Cấu hình Provider cho Proxmox BPG (Nhận biến ENV tự động)
provider "proxmox" {
  insecure = true

  ssh {
    agent       = false
    username    = "terraform-user"
    private_key = var.proxmox_ssh_private_key
  }
}

# Cấu hình Provider cho Tailscale (Thông tin xác thực lấy từ Environment Variables trên HCP)
provider "tailscale" {
}

