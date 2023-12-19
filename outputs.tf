output "gcp_network_id" {
  description  = "ID of GCP VPC"
  value        = try(module.gcp_vpc.*.gcp_network_id, "")
}

output "gcp_subnet_id" {
  description  = "ID of GCP subnet"
  value        = try(module.gcp_vpc.*.gcp_subnet_id, "")
}

output "alkira_connector_gcp_id" {
  description  = "ID of GCP connector"
  value        = try(module.gcp_vpc.*.alkira_connector_gcp_id, "")
}

output "alkira_connector_gcp_implicit_group_id" {
  description  = "Implicit group ID of GCP connector"
  value        = try(module.gcp_vpc.*.alkira_connector_gcp_implicit_group_id, "")
}

output "gcp_vm_private_ip" {
  description = "Private IP of GCP virtual machine"
  value = try(module.gcp_vpc.*.gcp_vm_private_ip, "")
}