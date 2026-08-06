locals {
  control_plane_node_ips = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"]
  worker_node_ips        = [for k, v in var.nodes : v.ip if v.machine_type == "worker"]
  node_ips               = [for k, v in var.nodes : v.ip]
  
  base_vm_tags = ["k8s", "talos"]
}
