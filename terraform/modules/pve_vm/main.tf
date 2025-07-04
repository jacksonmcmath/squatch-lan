locals {
  memory_sizes = {
    xs = 1
    sm = 2
    md = 4
    lg = 8
    xl = 16
  }

  cpu_sizes = {
    xs = 2
    sm = 2
    md = 2
    lg = 2
    xl = 4
  }

  dedicated_memory = var.memory.dedicated ? var.memory.dedicated : local.memory_sizes[var.size] * 1024

  cloud_init_exists = var.cloud_init.storage_pool || var.cloud_init.network || var.cloud_init.user || var.cloud_init.network_data_file_id || var.cloud_init.user_data_file_id || var.cloud_init.vendor_data_file_id || var.cloud_init.meta_data_file_id
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.node

  name        = var.name
  description = var.description
  tags        = var.tags
  vm_id       = var.id

  memory {
    dedicated = local.dedicated_memory
    floating  = var.memory.balooning ? local.dedicated_memory : 0
  }

  cpu {
    type    = var.cpu.type ? var.cpu.type : "host"
    sockets = var.cpu.sockets ? var.cpu.sockets : 1
    cores   = var.cpu.cores ? var.cpu.cores : local.cpu_sizes[var.size]
    flags   = []
  }

  bios = var.bios

  dynamic "efi_disk" {
    for_each = var.efi ? [1] : []
    content {
      datastore_id      = var.efi.storage_pool ? var.efi.storage_pool : var.storage_pool
      type              = var.efi.type ? var.efi.type : "4m"
      pre_enrolled_keys = var.efi.pre_enrolled_keys ? var.efi.pre_enrolled_keys : false
    }
  }

  dynamic "tpm_state" {
    for_each = var.tpm ? [1] : []
    content {
      datastore_id = var.tpm.storage_pool ? var.tpm.storage_pool : var.storage_pool
      version      = var.tpm.version ? var.tpm.version : "v2.0"
    }
  }

  vga {
    type   = var.display.type
    memory = var.display.memory ? var.display.memory : 16
  }

  machine       = var.machine
  scsi_hardware = var.scsi_controller

  disk {
    datastore_id = var.boot_disk.storage_pool ? var.boot_disk.storage_pool : var.storage_pool
    interface    = var.boot_disk.interface
    size         = var.boot_disk.size
    file_format  = var.boot_disk.file_format
    cache        = var.boot_disk.cache
    discard      = var.boot_disk.discard
    iothread     = var.boot_disk.iothread
    ssd          = var.boot_disk.ssd
    file_id      = var.boot_disk.file_id
  }

  dynamic "disk" {
    for_each = var.disks ? var.disks : []
    content {
      datastore_id = disk.value.storage_pool ? disk.value.storage_pool : var.storage_pool
      interface    = disk.value.interface
      size         = disk.value.size
      file_format  = disk.value.file_format
      cache        = disk.value.cache
      discard      = disk.value.discard
      iothread     = disk.value.iothread
      ssd          = disk.value.ssd
      file_id      = disk.value.file_id
    }
  }

  network_device {
    bridge      = var.network_device.bridge
    mac_address = var.network_device.mac_address
    vlan_id     = var.network_device.vlan
  }

  serial_device {
    device = "socket"
  }

  on_boot = var.on_boot

  operating_system {
    type = var.operating_system
  }

  boot_order = var.boot_order

  agent {
    enabled = var.guest_agent
  }

  dynamic "initialization" {
    for_each = local.cloud_init_exists ? [1] : []
    content {
      datastore_id = var.cloud_init.storage_pool
      dns {
        domain  = var.cloud_init.network.dns.domain
        servers = var.cloud_init.network.dns.servers
      }
      ip_config {
        ipv4 {
          address = var.cloud_init.network.ipv4.address
          gateway = var.cloud_init.network.ipv4.gateway
        }
        ipv6 {
          address = var.cloud_init.network.ipv6.address
          gateway = var.cloud_init.network.ipv6.gateway
        }
      }
      user_account {
        username = var.cloud_init.user.username
        password = var.cloud_init.user.password
        keys     = var.cloud_init.user.ssh_keys
      }
      network_data_file_id = var.cloud_init.network_data_file_id
      user_data_file_id    = var.cloud_init.user_data_file_id
      vendor_data_file_id  = var.cloud_init.vendor_data_file_id
      meta_data_file_id    = var.cloud_init.meta_data_file_id
    }
  }

  dynamic "hostpci" {
    for_each = var.igpu ? [1] : []
    content {
      device  = "hostpci0"
      mapping = "iGPU"
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }
}

data "proxmox_virtual_environment_vm" "this" {
  node_name = var.node
  vm_id     = var.id

  depends_on = [resource.proxmox_virtual_environment_vm.this]
}
