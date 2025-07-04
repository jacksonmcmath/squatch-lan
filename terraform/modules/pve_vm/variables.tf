variable "node" {
  description = "The PVE node to deploy the virtual machine on."
  type        = string
  default     = "pve-01-yosemite"
  validation {
    condition     = contains(["pve-01-yosemite", "pve-02-sequoia", "pve-03-redwood"], var.node)
    error_message = "The node must be one of: `pve-01-yosemite`, `pve-02-sequoia`, `pve-03-redwood`."
  }
}

variable "storage_pool" {
  description = "The storage pool to use for the virtual machine."
  type        = string
  default     = "local-zfs"
  validation {
    condition     = contains(["local-zfs", "local-lvm", "local"], var.storage_pool)
    error_message = "The storage pool must be one of: `local-zfs`, `local-lvm`, `local`."
  }
}

variable "size" {
  description = "The size of the virtual machine instance."
  type        = optional(string)
  validation {
    condition     = contains(["xs", "sm", "md", "lg", "xl"], var.size)
    error_message = "The size must be one of: `xs`, `sm`, `md`, `lg`, `xl`."
  }
}

variable "name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "description" {
  description = "A description for the virtual machine."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A list of tags to assign to the virtual machine."
  type        = list(string)
  default     = []
}

variable "id" {
  description = "The ID of the virtual machine."
  type        = number
}

variable "memory" {
  description = "The memory configuration for the virtual machine."
  type = object({
    dedicated = optional(number)
    balooning = optional(bool)
  })
  default = {
    balooning = true
  }
}

variable "cpu" {
  description = "The CPU configuration for the virtual machine."
  type = optional(object({
    type    = optional(string, "host")
    sockets = optional(number, 1)
    cores   = number
  }))
  default = null
}

variable "bios" {
  description = "The BIOS implementation for the virtual machine."
  type        = string
  default     = "seabios"
}

variable "efi" {
  description = "The EFI disk configuration for the virtual machine (required if bios is set to ovmf)."
  type = optional(object({
    storage_pool      = optional(string)
    type              = optional(string, "4m")
    pre_enrolled_keys = optional(bool, false)
  }))
  default = null
}

variable "tpm" {
  description = "The TPM state configuration for the virtual machine."
  type = optional(object({
    storage_pool = optional(string)
    version      = optional(string, "v2.0")
  }))
  default = null
}

variable "display" {
  description = "The display configuration for the virtual machine."
  type = object({
    type   = string
    memory = optional(number)
  })
  default = {
    type = "serial0"
  }
}

variable "machine" {
  description = "The machine type for the virtual machine."
  type        = string
  default     = "q35"
}

variable "scsi_controller" {
  description = "The SCSI controller for the virtual machine."
  type        = string
  default     = "virtio-scsi-single"
}

variable "boot_disk" {
  description = "The disk configuration for the virtual machine."
  type = object({
    storage_pool = optional(string)
    interface    = optional(string, "scsi0")
    size         = optional(number, 16)
    file_format  = optional(string, "raw")
    cache        = optional(string, "none")
    discard      = optional(string, "on")
    iothread     = optional(bool, true)
    ssd          = optional(bool, true)
    file_id      = optional(string)
  })
}

variable "disks" {
  description = "A list of additional disk configurations for the virtual machine."
  type = list(object({
    storage_pool = optional(string)
    interface    = optional(string, "scsi")
    size         = optional(number, 16)
    file_format  = optional(string, "raw")
    cache        = optional(string, "none")
    discard      = optional(string, "on")
    iothread     = optional(bool, true)
    ssd          = optional(bool, true)
    file_id      = optional(string)
  }))
  default = []
}

variable "network_device" {
  description = "The network device configuration for the virtual machine."
  type = object({
    bridge      = optional(string)
    mac_address = optional(string)
    vlan        = optional(number)
  })
  default = {
    bridge = "vmbr0"
  }
}

variable "on_boot" {
  description = "Whether the virtual machine should start on boot."
  type        = bool
  default     = true
}

variable "operating_system" {
  description = "The operating system type for the virtual machine."
  type        = optional(string)
  default     = "l26"
}

variable "boot_order" {
  description = "The boot order for the virtual machine."
  type        = list(string)
  default     = ["scsi0"]
}

variable "guest_agent" {
  description = "Whether the guest agent is enabled for the virtual machine."
  type        = bool
  default     = true
}

variable "cloud_init" {
  description = "The cloud-init configuration for the virtual machine."
  type = object({
    storage_pool = optional(string)
    network = optional(object({
      dns = optional(object({
        domain  = optional(string)
        servers = optional(list(string))
      }))
      ipv4 = optional(object({
        address = optional(string)
        gateway = optional(string)
      }))
      ipv6 = optional(object({
        address = optional(string)
        gateway = optional(string)
      }))
    }))
    user = optiona(object({
      username = optional(string)
      password = optional(list(string))
      keys     = optional(string)
    }))
    network_data_file_id = optional(string)
    user_data_file_id    = optional(string)
    vendor_data_file_id  = optional(string)
    meta_data_file_id    = optional(string)
  })
  default = null
}

variable "igpu" {
  description = "Whether the virtual machine should use the integrated GPU."
  type        = bool
  default     = false
}
