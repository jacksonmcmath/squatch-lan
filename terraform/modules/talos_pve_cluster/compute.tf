resource "proxmox_virtual_environment_vm" "this" {
  for_each = var.nodes

  node_name = each.value.pve_node

  name        = each.key
  description = "${each.value.machine_type == "controlplane" ? "Talos Control Plane" : "Talos Worker"} (${var.image.version})"
  tags = concat(
    each.value.machine_type == "controlplane" ? ["k8s", "control-plane"] : ["k8s", "worker"],
    each.value.igpu ? ["igpu"] : []
  )
  vm_id = each.value.vm_id

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  cpu {
    type    = "host"
    sockets = 1
    cores   = each.value.cores
  }

  bios = var.image.secure_boot ? "ovmf" : "seabios"

  dynamic "efi_disk" {
    for_each = var.image.secure_boot ? [1] : []
    content {
      datastore_id = each.value.storage_pool
      type         = "4m"
    }
  }

  vga {
    type = "serial0"
  }

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = each.value.storage_pool
    interface    = "scsi0"
    size         = 32 # GiB
    file_format  = "raw"
    cache        = "none"
    discard      = "on"
    iothread     = true
    ssd          = true
    file_id      = proxmox_virtual_environment_download_file.this.id
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = each.value.mac
  }

  dynamic "network_device" {
    for_each = each.value.machine_type == "worker" ? [1] : []
    content {
      bridge = "vmbr1"
    }
  }

  serial_device {
    device = "socket"
  }

  on_boot = true

  operating_system {
    type = "l26"
  }

  boot_order = ["scsi0"]

  agent {
    enabled = true
  }

  dynamic "hostpci" {
    for_each = each.value.igpu ? [1] : []
    content {
      # Passthrough iGPU
      device  = "hostpci0"
      mapping = "iGPU"
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }
}
