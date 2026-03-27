terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66.1"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = ">= 0.17"
    }
  }
}
