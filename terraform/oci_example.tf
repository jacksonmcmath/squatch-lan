# Example OCI compute instance deployment
# This file demonstrates how to use the oci_compute module

# Data source to get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.oci_compartment_id
}

# Deploy OCI compute instance using the module
module "oci_dev_instance" {
  source = "./modules/oci_compute"

  # Required variables
  compartment_id      = var.oci_compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  ssh_public_key      = file("~/.ssh/id_rsa.pub")

  # Instance configuration
  instance_name = "dev-server"
  
  # Use ARM-based instance for better performance (free tier)
  instance_shape = "VM.Standard.A1.Flex"
  instance_shape_config = {
    ocpus         = 1  # Free tier allows up to 4 OCPU total
    memory_in_gbs = 6  # Free tier allows up to 24GB total
  }

  # Storage (free tier allows up to 200GB total)
  boot_volume_size_in_gbs = 100

  # Network configuration
  vcn_cidr_block    = "10.1.0.0/16"
  subnet_cidr_block = "10.1.1.0/24"
  enable_public_ip  = true

  # Security configuration - customize as needed
  ingress_rules = [
    {
      protocol    = "6"  # TCP
      port_range  = "22"
      source      = "0.0.0.0/0"  # Consider restricting to your IP
      description = "SSH access"
    },
    {
      protocol    = "6"  # TCP
      port_range  = "80"
      source      = "0.0.0.0/0"
      description = "HTTP access"
    },
    {
      protocol    = "6"  # TCP
      port_range  = "443"
      source      = "0.0.0.0/0"
      description = "HTTPS access"
    },
    {
      protocol    = "6"  # TCP
      port_range  = "3000"
      source      = "0.0.0.0/0"
      description = "Development server"
    }
  ]

  # Tags
  tags = {
    Environment = "development"
    Project     = "squatch-lan"
    ManagedBy   = "terraform"
  }
}

# Variables for OCI configuration
variable "oci_compartment_id" {
  description = "OCID of the OCI compartment"
  type        = string
  sensitive   = true
}

# Outputs
output "oci_instance_details" {
  description = "Details of the created OCI instance"
  value = {
    instance_id        = module.oci_dev_instance.instance_id
    public_ip          = module.oci_dev_instance.instance_public_ip
    private_ip         = module.oci_dev_instance.instance_private_ip
    ssh_command        = module.oci_dev_instance.ssh_connection_command
    state             = module.oci_dev_instance.instance_state
  }
}
