output "client_config" {
  value     = data.talos_client_configuration.this
  sensitive = true
}

output "machine_config" {
  value = data.talos_machine_configuration.this
}

output "kube_config" {
  value     = talos_cluster_kubeconfig.this
  sensitive = true
}

output "argocd_admin_password" {
  value     = random_password.argocd_admin_password.result
  sensitive = true
}
