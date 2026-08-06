variable "compartment_id" {
  description = "The OCID of the compartment where resources will be created"
  type        = string
}

variable "availability_domain" {
  description = "The availability domain where the instance will be created"
  type        = string
}

variable "instance_name" {
  description = "The name of the compute instance"
  type        = string
  default     = "oci-free-tier-instance"
}

variable "instance_shape" {
  description = "The shape of the compute instance (free tier: VM.Standard.E2.1.Micro or VM.Standard.A1.Flex)"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_shape_config" {
  description = "Shape configuration for flexible instances (A1.Flex)"
  type = object({
    ocpus         = number
    memory_in_gbs = number
  })
  default = {
    ocpus         = 1
    memory_in_gbs = 6
  }
}

variable "instance_image_id" {
  description = "The OCID of the image to use for the instance (if not provided, will use latest Ubuntu)"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
}

variable "boot_volume_size_in_gbs" {
  description = "Size of the boot volume in GB (free tier: up to 200GB)"
  type        = number
  default     = 50
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    protocol    = string
    port_range  = string
    source      = string
    description = string
  }))
  default = [
    {
      protocol    = "6"  # TCP
      port_range  = "22"
      source      = "0.0.0.0/0"
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
    }
  ]
}
