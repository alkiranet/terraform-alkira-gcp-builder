/*
compute_network
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
*/
resource "google_compute_network" "vpc" {
  for_each = {
    for o in var.gcp_vpc_data : o.name => o
    if o.create_network == true
  }

  name          = each.value.name
  routing_mode  = "REGIONAL"

}

/*
compute_subnetwork
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
*/
resource "google_compute_subnetwork" "subnet" {
  for_each = { 
    for idx, subnet in flatten([
      for vpc in var.gcp_vpc_data : [

        # If vpc.subnets is == null, use coalesce with empty list
        for subnet in coalesce(vpc.subnets, []) : {
          vpc_name        = vpc.name
          subnet_name     = subnet.name
          ip_cidr_range   = subnet.cidr
          create_network  = vpc.create_network
        }
      ]
    ]) : "${subnet.vpc_name}-${subnet.subnet_name}" => {
      ip_cidr_range = subnet.ip_cidr_range
      network       = google_compute_network.vpc[subnet.vpc_name].id
      name          = subnet.subnet_name
    } if subnet.create_network
  }

  ip_cidr_range = each.value.ip_cidr_range
  name          = each.value.name
  network       = each.value.network

}

/*
google_compute_zones
https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
*/
data "google_compute_zones" "available" {
  for_each = {
    for vpc in var.gcp_vpc_data : vpc.region => vpc.region...
  }

  region = each.key

}

/*
google_compute_instance
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
*/
resource "google_compute_instance" "vm" {
  for_each = {
    for idx, subnet in flatten([
      for vpc in var.gcp_vpc_data : [
        for subnet in coalesce(vpc.subnets, []) : {
          create_vm       = subnet.create_vm
          subnet_name     = subnet.name
          vpc_name        = vpc.name
          vm_type         = subnet.vm_type
          region          = vpc.region
        }
    ]
  ]) : "${subnet.vpc_name}-${subnet.subnet_name}" => subnet if subnet.create_vm}

  name         = "vm-${each.value.vpc_name}-${each.value.subnet_name}"
  machine_type = each.value.vm_type
  zone         = data.google_compute_zones.available[each.value.region].names[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc[each.value.vpc_name].self_link
    subnetwork = google_compute_subnetwork.subnet[each.key].self_link
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  tags = ["vm-${each.value.vpc_name}-${each.value.subnet_name}"]

}

/*
google_compute_firewall
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
*/
resource "google_compute_firewall" "firewall" {
  for_each = {
    for vpc in var.gcp_vpc_data : vpc.name => vpc
    if anytrue([for subnet in coalesce(vpc.subnets, []) : subnet.create_vm])
  }

  name    = "fw-${each.key}"
  network = google_compute_network.vpc[each.key].self_link

  allow {
    protocol = "all"
  }

  source_ranges = each.value.ingress_cidrs

}

locals {

  # filter 'segment' data
  filter_segments     = var.gcp_vpc_data[*].segment

  # filter 'credential' data
  filter_credentials  = var.gcp_vpc_data[*].credential

}

data "alkira_segment" "segment" {

  for_each = toset(local.filter_segments)

  name = each.value

}

data "alkira_credential" "credential" {

  for_each = toset(local.filter_credentials)

  name = each.value

}

/*
alkira_connector_gcp_vpc
https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_gcp_vpc
*/
locals {

  filter_gcp_vpcs = flatten([
    for c in var.gcp_vpc_data : {

        connect_network   = c.connect_network
        credential        = lookup(data.alkira_credential.credential, c.credential, null).id
        cxp               = c.cxp
        gcp_region        = c.region
        gcp_vpc_name      = c.name
        group             = c.group
        name              = c.name
        segment           = lookup(data.alkira_segment.segment, c.segment, null).id
        size              = c.size

      }
  ])
}

resource "alkira_connector_gcp_vpc" "connector" {

  for_each = {
    for o in local.filter_gcp_vpcs : o.name => o
    if o.connect_network == true
  }

  credential_id           = each.value.credential
  cxp                     = each.value.cxp
  gcp_region              = each.value.gcp_region
  gcp_vpc_name            = each.value.name
  group                   = each.value.group
  name                    = each.value.name
  segment_id              = each.value.segment
  size                    = each.value.size

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.subnet
  ]

}