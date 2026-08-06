# OCI Free Tier Setup Guide

This guide will help you set up Oracle Cloud Infrastructure (OCI) and deploy a free tier compute instance using the provided Terraform module.

## Prerequisites

1. **OCI Account**: Sign up for a free Oracle Cloud account at https://cloud.oracle.com/
2. **Terraform**: Install Terraform (>= 1.0)
3. **SSH Key Pair**: Generate an SSH key pair for instance access

## OCI Setup Steps

### 1. Create OCI API Key

1. Log into the OCI Console
2. Click on your profile icon → User Settings
3. Under Resources, click "API Keys"
4. Click "Add API Key"
5. Choose "Generate API Key Pair" and download both keys
6. Save the private key to `~/.oci/oci_api_key.pem`
7. Copy the fingerprint and other details from the configuration preview

### 2. Get Required OCIDs

You'll need these OCIDs for configuration:

- **Tenancy OCID**: Found in your user profile → Tenancy Information
- **User OCID**: Found in your user profile → User Information  
- **Compartment OCID**: Usually the same as Tenancy OCID for root compartment

### 3. Configure Terraform

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your OCI details:
   ```hcl
   oci = {
     tenancy_ocid     = "ocid1.tenancy.oc1..your-tenancy-ocid"
     user_ocid        = "ocid1.user.oc1..your-user-ocid" 
     fingerprint      = "your-api-key-fingerprint"
     private_key_path = "~/.oci/oci_api_key.pem"
     region           = "us-ashburn-1"
   }
   
   oci_compartment_id = "ocid1.compartment.oc1..your-compartment-ocid"
   ```

### 4. Deploy Infrastructure

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Free Tier Limits

The module is configured to stay within OCI's Always Free limits:

- **Compute**: 2x VM.Standard.E2.1.Micro OR 4 OCPU A1.Flex instances
- **Memory**: Up to 24GB total (for A1.Flex)
- **Storage**: Up to 200GB Block Volume storage
- **Network**: 2 VCNs, 10 Mbps bandwidth

## Instance Types

### VM.Standard.E2.1.Micro (AMD)
- 1 OCPU (1/8 of physical core)
- 1 GB RAM
- Always Free (2 instances)

### VM.Standard.A1.Flex (ARM - Recommended)
- Configurable: 1-4 OCPU
- Configurable: 1-24 GB RAM
- Better performance per resource
- Always Free (4 OCPU total across instances)

## Security Features

The module includes several security hardening features:

- SSH key authentication only (no passwords)
- UFW firewall configured
- Fail2ban for intrusion prevention
- Automatic security updates
- Root login disabled

## Connecting to Your Instance

After deployment, connect using:

```bash
ssh ubuntu@<public_ip>
```

The SSH command will be shown in the Terraform output.

## Customization

You can customize the deployment by modifying variables in the module call:

```hcl
module "oci_instance" {
  source = "./modules/oci_compute"
  
  # Required
  compartment_id      = var.oci_compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  
  # Optional customizations
  instance_shape = "VM.Standard.A1.Flex"
  instance_shape_config = {
    ocpus         = 2
    memory_in_gbs = 12
  }
  boot_volume_size_in_gbs = 100
  
  # Custom security rules
  ingress_rules = [
    {
      protocol    = "6"
      port_range  = "22"
      source      = "YOUR.IP.ADDRESS/32"  # Restrict SSH to your IP
      description = "SSH access"
    }
  ]
}
```

## Troubleshooting

### Common Issues

1. **"Service limit exceeded"**: You may have reached free tier limits
2. **"Availability domain has no capacity"**: Try different ADs or regions
3. **"Invalid authentication"**: Check your API key and fingerprint

### Useful Commands

```bash
# Check Terraform state
terraform state list

# Destroy resources
terraform destroy

# Get instance details
terraform output
```

## Cost Monitoring

Even though this uses free tier resources, monitor your usage:

1. OCI Console → Billing & Cost Management
2. Set up budget alerts
3. Monitor resource usage regularly

## Next Steps

After deployment, consider:

1. Setting up monitoring and logging
2. Configuring backups
3. Installing additional software
4. Setting up a domain name
5. Implementing infrastructure as code best practices
