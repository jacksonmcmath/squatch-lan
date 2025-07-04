module "talos_pve_cluster" {
  source = "./modules/talos_pve_cluster"

  cluster = {
    name          = "pve-cluster-01-cerberus"
    endpoint      = "10.129.8.1"
    talos_version = "v1.10.3"
    pve_nodes     = ["pve-01-yosemite"] # , "pve-02-denali", "pve-03-acadia"]
  }

  image = {
    version     = "v1.10.3"
    secure_boot = false
    extra_kernel_args = [
      "-console",
      "console=tty0",
      "console=ttyS0,115200",
      "net.ifnames=0"
    ]
    extensions = [
      "siderolabs/i915",
      "siderolabs/intel-ucode",
      "siderolabs/iscsi-tools",
      "siderolabs/nfsd",
      "siderolabs/nut-client",
      "siderolabs/nvme-cli",
      "siderolabs/qemu-guest-agent",
      "siderolabs/util-linux-tools"
    ]
  }

  cilium = {
    version = "1.17.5"
    values  = file("${path.module}/../argocd/applications/core/cilium/values.yaml")
  }

  argocd = {
    version = "8.1.2"
    values  = file("${path.module}/../argocd/applications/core/argocd/values.yaml")
  }

  nodes = {
    "cerberus-control-plane-01" = {
      pve_node     = "pve-01-yosemite"
      machine_type = "controlplane"
      vm_id        = 8801
      ip           = "10.129.8.101"
      mac          = "BC:24:11:88:C8:01"
      cores        = 4
      memory       = 4096
    }
    # "cerberus-control-plane-02" = {
    #   pve_node     = "pve-02-denali"
    #   machine_type = "controlplane"
    #   vm_id        = 8802
    #   ip           = "10.129.8.102"
    #   mac          = "BC:24:11:88:C8:02"
    #   cores        = 4
    #   memory       = 4096
    # }
    # "cerberus-control-plane-03" = {
    #   pve_node     = "pve-03-acadia"
    #   machine_type = "controlplane"
    #   vm_id        = 8803
    #   ip           = "10.129.8.103"
    #   mac          = "BC:24:11:88:C8:03"
    #   cores        = 4
    #   memory       = 4096
    # }
    "cerberus-worker-01" = {
      pve_node     = "pve-01-yosemite"
      machine_type = "worker"
      vm_id        = 8811
      ip           = "10.129.8.111"
      mac          = "BC:24:11:88:F8:01"
      cores        = 2
      memory       = 8192
      igpu         = false
    }
    # "cerberus-worker-02" = {
    #   pve_node     = "pve-02-denali"
    #   machine_type = "worker"
    #   vm_id        = 8812
    #   ip           = "10.129.8.112"
    #   mac          = "BC:24:11:88:F8:02"
    #   cores        = 4
    #   memory       = 16384
    #   igpu         = true
    # }
    # "cerberus-worker-03" = {
    #   pve_node     = "pve-03-acadia"
    #   machine_type = "worker"
    #   vm_id        = 8813
    #   ip           = "10.129.8.113"
    #   mac          = "BC:24:11:88:F8:03"
    #   cores        = 2
    #   memory       = 8192
    #   igpu         = false
    # }
    "cerberus-worker-04" = {
      pve_node     = "pve-01-yosemite"
      machine_type = "worker"
      vm_id        = 8814
      ip           = "10.129.8.114"
      mac          = "BC:24:11:88:F8:04"
      cores        = 4
      memory       = 16384
      igpu         = true
    }
    # "cerberus-worker-05" = {
    #   pve_node     = "pve-02-denali"
    #   machine_type = "worker"
    #   vm_id        = 8815
    #   ip           = "10.129.8.115"
    #   mac          = "BC:24:11:88:F8:05"
    #   cores        = 2
    #   memory       = 8192
    #   igpu         = false
    # }
    # "cerberus-worker-06" = {
    #   pve_node     = "pve-03-acadia"
    #   machine_type = "worker"
    #   vm_id        = 8816
    #   ip           = "10.129.8.116"
    #   mac          = "BC:24:11:88:F8:06"
    #   cores        = 4
    #   memory       = 16384
    #   igpu         = true
    # }
  }
}

# outputs

resource "local_file" "machine_configs" {
  for_each        = module.talos_pve_cluster.machine_config
  content         = each.value.machine_configuration
  filename        = "output/${each.key}-machine-config.yaml"
  file_permission = "0600"
}

resource "local_file" "talos_config" {
  content         = module.talos_pve_cluster.client_config.talos_config
  filename        = "output/talos-config.yaml"
  file_permission = "0600"
}

resource "local_file" "kube_config" {
  content         = module.talos_pve_cluster.kube_config.kubeconfig_raw
  filename        = "output/kube-config.yaml"
  file_permission = "0600"
}

output "talos_config" {
  value     = module.talos_pve_cluster.client_config.talos_config
  sensitive = true
}

output "kube_config" {
  value     = module.talos_pve_cluster.kube_config.kubeconfig_raw
  sensitive = true
}

output "argocd_admin_password" {
  value     = module.talos_pve_cluster.argocd_admin_password
  sensitive = true
}
