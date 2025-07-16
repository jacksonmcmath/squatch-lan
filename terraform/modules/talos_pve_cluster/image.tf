resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      extraKernelArgs = var.image.extra_kernel_args
      systemExtensions = {
        officialExtensions = var.image.extensions
      }
    }
  })
}

data "talos_image_factory_urls" "this" {
  talos_version = var.image.version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = var.image.platform
  architecture  = var.image.arch
}

resource "proxmox_virtual_environment_download_file" "this" {
  node_name    = var.nodes[keys(var.nodes)[0]].pve_node
  content_type = "iso"
  datastore_id = var.image.pve_storage_pool

  file_name = "talos-${talos_image_factory_schematic.this.id}-${var.image.version}-${var.image.platform}-${var.image.arch}${var.image.secure_boot ? "-secureboot" : ""}.iso"
  url       = var.image.secure_boot ? data.talos_image_factory_urls.this.urls.iso_secureboot : data.talos_image_factory_urls.this.urls.iso
  overwrite = false
}
