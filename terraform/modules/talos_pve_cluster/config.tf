resource "talos_machine_secrets" "this" {
  talos_version = var.cluster.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for k, v in var.nodes : v.ip]
  endpoints            = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"]
}

data "talos_machine_configuration" "this" {
  for_each = var.nodes

  cluster_name     = var.cluster.name
  cluster_endpoint = "https://${var.cluster.endpoint}:6443"
  talos_version    = var.cluster.talos_version
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = each.value.machine_type == "controlplane" ? [
    templatefile("${path.module}/machine-config/control-plane.yaml.tftpl", {
      hostname          = each.key
      installer_image   = var.image.secure_boot ? data.talos_image_factory_urls.this.urls.installer_secureboot : data.talos_image_factory_urls.this.urls.installer
      extra_kernel_args = var.image.extra_kernel_args
      node_ip           = each.value.ip
      vip               = var.cluster.endpoint
    })
    ] : [
    templatefile("${path.module}/machine-config/worker.yaml.tftpl", {
      hostname          = each.key
      installer_image   = var.image.secure_boot ? data.talos_image_factory_urls.this.urls.installer_secureboot : data.talos_image_factory_urls.this.urls.installer
      extra_kernel_args = var.image.extra_kernel_args
      node_ip           = each.value.ip
    })
  ]
}

resource "talos_machine_configuration_apply" "this" {
  for_each = var.nodes

  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration

  depends_on = [proxmox_virtual_environment_vm.this]

  lifecycle {
    # re-run config apply if vm changes
    replace_triggered_by = [proxmox_virtual_environment_vm.this[each.key]]
  }
}

resource "talos_machine_bootstrap" "this" {
  node                 = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
  endpoint             = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
  client_configuration = talos_machine_secrets.this.client_configuration

  depends_on = [talos_machine_configuration_apply.this]
}

resource "talos_cluster_kubeconfig" "this" {
  node                 = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
  endpoint             = var.cluster.endpoint
  client_configuration = talos_machine_secrets.this.client_configuration
  timeouts = {
    read = "1m"
  }

  depends_on = [talos_machine_bootstrap.this]
}

resource "null_resource" "wait_for_kubeapi" {
  provisioner "local-exec" {
    command = <<EOT
    for i in $(seq 1 60); do
      kubectl --kubeconfig=${path.module}/../../output/kube-config.yaml get nodes >/dev/null && exit 0
      echo "Waiting for Kubernetes API to be ready..."
      sleep 10
    done
    echo "Kubernetes API not ready after 10 minutes" >&2
    exit 1
    EOT
  }

  depends_on = [talos_cluster_kubeconfig.this]
}

resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = var.cilium.version

  namespace  = "kube-system"
  create_namespace = true
  values     = [var.cilium.values]
  wait       = false

  depends_on = [
    talos_cluster_kubeconfig.this,
    null_resource.wait_for_kubeapi
  ]
}

data "talos_cluster_health" "this" {
  client_configuration = data.talos_client_configuration.this.client_configuration
  control_plane_nodes  = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"]
  worker_nodes         = [for k, v in var.nodes : v.ip if v.machine_type == "worker"]
  endpoints            = data.talos_client_configuration.this.endpoints
  timeouts = {
    read = "10m"
  }

  depends_on = [
    talos_machine_configuration_apply.this,
    talos_machine_bootstrap.this,
    helm_release.cilium
  ]
}

resource "random_password" "argocd_admin_password" {
  length  = 16
  special = true
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd.version

  namespace        = "argocd"
  create_namespace = true
  values           = [var.argocd.values]

  wait = false

  set_sensitive = [{
    name  = "configs.secret.argocdServerAdminPassword"
    value = random_password.argocd_admin_password.bcrypt_hash
  }]

  depends_on = [
    data.talos_cluster_health.this,
    random_password.argocd_admin_password
  ]
}
