terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.78.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">=0.8.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=3.0.2"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  api_token = var.proxmox.api_token
  ssh {
    agent    = true
    username = var.proxmox.username
    private_key = file("~/.ssh/root_ed25519")
  }
}

variable "proxmox" {
  type = object({
    name      = string
    endpoint  = string
    insecure  = bool
    username  = string
    api_token = string
  })
  sensitive = true
}
