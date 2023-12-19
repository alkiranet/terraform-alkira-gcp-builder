# GCP Builder - Terraform Module
This module creates various resources in _Alkira_ and _GCP_ from **.yaml** files.

## Basic Usage
Define the path to your **.yaml** configuration file in the module.

```hcl
module "gcp_vpcs" {
  source = "alkiranet/gcp-builder/alkira"
  
  # path to config
  config_files = "./config/gcp_vpcs.yaml"
  
}
```

### Configuration Example
The module will automatically create resources if they are present in the **.yaml** configuration with the proper _resource keys_ defined.

**gcp_vpcs.yaml**
```yml
---
gcp_vpcs:
  - name: 'vpc-east'
    description: 'GCP East Workloads'
    region: 'us-east4'
    credential: 'gcp'
    cxp: 'US-EAST-2'
    group: 'cloud'
    segment: 'business'
...
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.1 |
| <a name="requirement_alkira"></a> [alkira](#requirement\_alkira) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.64, < 6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_vpc"></a> [gcp\_vpc](#module\_gcp\_vpc) | ./modules/gcp-vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_file"></a> [config\_file](#input\_config\_file) | Path to .yml files | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alkira_connector_gcp_id"></a> [alkira\_connector\_gcp\_id](#output\_alkira\_connector\_gcp\_id) | ID of GCP connector |
| <a name="output_alkira_connector_gcp_implicit_group_id"></a> [alkira\_connector\_gcp\_implicit\_group\_id](#output\_alkira\_connector\_gcp\_implicit\_group\_id) | Implicit group ID of GCP connector |
| <a name="output_gcp_network_id"></a> [gcp\_network\_id](#output\_gcp\_network\_id) | ID of GCP VPC |
| <a name="output_gcp_subnet_id"></a> [gcp\_subnet\_id](#output\_gcp\_subnet\_id) | ID of GCP subnet |
| <a name="output_gcp_vm_private_ip"></a> [gcp\_vm\_private\_ip](#output\_gcp\_vm\_private\_ip) | Private IP of GCP virtual machine |
<!-- END_TF_DOCS -->