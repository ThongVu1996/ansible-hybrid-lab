terraform {
  cloud {
    organization = "tonytechlab-group"
    workspaces {
      name = "hybrid-lab-dev"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}
