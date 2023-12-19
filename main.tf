locals {

  # parse .yaml configuration
  config_file_content = fileexists(var.config_file) ? file(var.config_file) : "NoConfigurationFound: true"
  config              = yamldecode(local.config_file_content)

  # does 'gcp_vpc' key exist in the configuration?
  gcp_vpc_exists   = contains(keys(local.config), "gcp_vpc")
}

module "gcp_vpc" {
  source = "./modules/gcp-vpc"

  # if 'gcp_vpc' exists, create resources
  count = local.gcp_vpc_exists ? 1 : 0

  # pass configuration
  gcp_vpc_data = local.config["gcp_vpc"]

}