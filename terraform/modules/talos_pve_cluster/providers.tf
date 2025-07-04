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

provider "helm" {
  kubernetes = {
    host                   = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  }
}
