terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.81.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.8.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.2"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 7.14.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox.endpoint
  insecure = var.proxmox.insecure

  api_token = var.proxmox.api_token
  ssh {
    agent       = true
    username    = var.proxmox.username
    private_key = file("~/.ssh/root_ed25519")
  }
}

# provider "oci" {
#   tenancy_ocid     = var.oci.tenancy_ocid
#   user_ocid        = var.oci.user_ocid
#   fingerprint      = var.oci.fingerprint
#   private_key_path = var.oci.private_key_path
#   region           = var.oci.region
# }

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

# variable "oci" {
#   type = object({
#     tenancy_ocid     = string
#     user_ocid        = string
#     fingerprint      = string
#     private_key_path = string
#     region           = string
#   })
#   sensitive   = true
#   description = "OCI provider configuration"
# }
