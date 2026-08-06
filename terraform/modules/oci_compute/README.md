# OCI Compute Instance Module

This Terraform module creates a compute instance on Oracle Cloud Infrastructure (OCI) using free tier resources.

## Features

- **Compute Instance**: VM.Standard.E2.1.Micro (AMD) or VM.Standard.A1.Flex (ARM) shapes
- **Networking**: VCN, subnet, internet gateway, and security lists
- **Security**: UFW firewall, fail2ban, and SSH key authentication
- **Automatic Updates**: Cloud-init configuration for security updates
- **Monitoring**: Basic system monitoring tools

## Free Tier Limits

This module is designed to work within OCI's Always Free tier limits:

- **Compute**: 2 VM.Standard.E2.1.Micro instances OR 4 OCPU A1.Flex instances (24GB RAM total)
- **Block Storage**: Up to 200GB total
- **Networking**: 2 VCNs, 10 Mbps bandwidth

## Usage

```hcl
module "oci_instance" {
  source = "./modules/oci_compute"

  compartment_id      = var.oci_compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  instance_name       = "my-oci-instance"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")

  # Optional: Use ARM-based instance for better performance
  instance_shape = "VM.Standard.A1.Flex"
  instance_shape_config = {
    ocpus         = 1
    memory_in_gbs = 6
  }

  tags = {
    Environment = "development"
    Project     = "homelab"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| oci | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| oci | >= 5.0 |

## Resources

| Name | Type |
|------|------|
| [oci_core_instance.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.main](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compartment_id | The OCID of the compartment where resources will be created | `string` | n/a | yes |
| availability_domain | The availability domain where the instance will be created | `string` | n/a | yes |
| ssh_public_key | SSH public key for instance access | `string` | n/a | yes |
| instance_name | The name of the compute instance | `string` | `"oci-free-tier-instance"` | no |
| instance_shape | The shape of the compute instance | `string` | `"VM.Standard.E2.1.Micro"` | no |
| instance_shape_config | Shape configuration for flexible instances | `object` | `{ocpus = 1, memory_in_gbs = 6}` | no |
| vcn_cidr_block | CIDR block for the VCN | `string` | `"10.0.0.0/16"` | no |
| subnet_cidr_block | CIDR block for the public subnet | `string` | `"10.0.1.0/24"` | no |
| enable_public_ip | Whether to assign a public IP to the instance | `bool` | `true` | no |
| boot_volume_size_in_gbs | Size of the boot volume in GB | `number` | `50` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The OCID of the compute instance |
| instance_public_ip | The public IP address of the compute instance |
| instance_private_ip | The private IP address of the compute instance |
| ssh_connection_command | SSH command to connect to the instance |

## Security Features

- SSH key-based authentication only
- UFW firewall configured with minimal open ports
- Fail2ban for intrusion prevention
- Automatic security updates enabled
- Root login disabled

## Post-Deployment

After deployment, you can connect to your instance using:

```bash
ssh ubuntu@<public_ip>
```

The instance comes pre-configured with basic security hardening and monitoring tools.
