variable "image" {
  description = "Talos image configuration"
  type = object({
    secure_boot       = optional(bool, false)
    extra_kernel_args = optional(list(string), [])
    extensions        = optional(list(string), [])
    version           = string
    arch              = optional(string, "amd64")
    platform          = optional(string, "metal")
    pve_storage_pool  = optional(string, "local")
  })
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name          = string
    endpoint      = string
    talos_version = string
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    pve_node        = string
    machine_type    = string
    storage_pool    = optional(string, "local-zfs")
    vm_id           = number
    ip              = string
    mac             = string
    cores           = number
    memory          = number
    igpu            = optional(bool, false)
    nodeLabels      = optional(map(string), {})
    nodeAnnotations = optional(map(string), {})
    nodeTaints      = optional(map(string), {})
  }))
}

variable "cilium" {
  description = "Cilium configuration"
  type = object({
    version = string
    values  = string
  })
}

variable "argocd" {
  description = "Argo CD configuration"
  type = object({
    version = string
    values  = string
  })
}
