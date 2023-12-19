output "gcp_network_id" {
  description = "ID of GCP VPC"
  value = {
    for k, v in google_compute_network.vpc : k => v.id
  }
}

output "gcp_subnet_id" {
  description = "ID of GCP subnet"
  value = {
    for k, v in google_compute_subnetwork.subnet : k => v.id
  }
}

output "alkira_connector_gcp_id" {
  description = "ID of GCP connector"
  value = {
    for k, v in alkira_connector_gcp_vpc.connector : k => v.id
  }
}

output "alkira_connector_gcp_implicit_group_id" {
  description = "Implicit group ID of GCP connector"
  value = {
    for k, v in alkira_connector_gcp_vpc.connector : k => v.implicit_group_id
  }
}

output "gcp_vm_private_ip" {
  description = "Private IP of GCP vm"
  value = {
    for k, v in google_compute_instance.vm : k => v.network_interface.0.network_ip
  }
}