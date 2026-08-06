# Data sources for OCI resources
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# VCN (Virtual Cloud Network)
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr_block
  display_name   = "${var.instance_name}-vcn"
  dns_label      = "mainvcn"

  freeform_tags = var.tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.instance_name}-igw"
  enabled        = true

  freeform_tags = var.tags
}

# Route Table
resource "oci_core_route_table" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.instance_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
  }

  freeform_tags = var.tags
}

# Security List
resource "oci_core_security_list" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.instance_name}-sl"

  # Egress rules (outbound)
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound traffic"
  }

  # Ingress rules (inbound)
  dynamic "ingress_security_rules" {
    for_each = var.ingress_rules
    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      description = ingress_security_rules.value.description

      tcp_options {
        min = split("-", ingress_security_rules.value.port_range)[0]
        max = length(split("-", ingress_security_rules.value.port_range)) > 1 ? split("-", ingress_security_rules.value.port_range)[1] : split("-", ingress_security_rules.value.port_range)[0]
      }
    }
  }

  freeform_tags = var.tags
}

# Public Subnet
resource "oci_core_subnet" "public" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main.id
  cidr_block        = var.subnet_cidr_block
  display_name      = "${var.instance_name}-public-subnet"
  dns_label         = "publicsubnet"
  route_table_id    = oci_core_route_table.main.id
  security_list_ids = [oci_core_security_list.main.id]

  freeform_tags = var.tags
}

# Compute Instance
resource "oci_core_instance" "main" {
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = var.instance_name
  shape               = var.instance_shape

  # Shape configuration for flexible instances (A1.Flex)
  dynamic "shape_config" {
    for_each = var.instance_shape == "VM.Standard.A1.Flex" ? [1] : []
    content {
      ocpus         = var.instance_shape_config.ocpus
      memory_in_gbs = var.instance_shape_config.memory_in_gbs
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    display_name     = "${var.instance_name}-vnic"
    assign_public_ip = var.enable_public_ip
    hostname_label   = replace(lower(var.instance_name), "_", "-")
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_id != null ? var.instance_image_id : data.oci_core_images.ubuntu_images.images[0].id

    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      hostname = var.instance_name
    }))
  }

  preserve_boot_volume = false

  freeform_tags = var.tags

  lifecycle {
    create_before_destroy = false
  }
}
