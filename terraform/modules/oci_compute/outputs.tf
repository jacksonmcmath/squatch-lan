output "instance_id" {
  description = "The OCID of the compute instance"
  value       = oci_core_instance.main.id
}

output "instance_public_ip" {
  description = "The public IP address of the compute instance"
  value       = var.enable_public_ip ? oci_core_instance.main.public_ip : null
}

output "instance_private_ip" {
  description = "The private IP address of the compute instance"
  value       = oci_core_instance.main.private_ip
}

output "vcn_id" {
  description = "The OCID of the VCN"
  value       = oci_core_vcn.main.id
}

output "subnet_id" {
  description = "The OCID of the public subnet"
  value       = oci_core_subnet.public.id
}

output "security_list_id" {
  description = "The OCID of the security list"
  value       = oci_core_security_list.main.id
}

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = var.enable_public_ip ? "ssh ubuntu@${oci_core_instance.main.public_ip}" : "SSH via private IP: ssh ubuntu@${oci_core_instance.main.private_ip}"
}

output "instance_state" {
  description = "The current state of the instance"
  value       = oci_core_instance.main.state
}
