variable "gcp_vpc_data" {
  type = list(object({

    connect_network  = optional(bool, true)
    create_network   = optional(bool, false)
    credential       = string
    cxp              = string
    group            = optional(string)
    ingress_cidrs    = optional(list(string), ["0.0.0.0/0"])
    name             = string
    network_cidr     = optional(string)
    region           = optional(string)
    segment          = string
    size             = optional(string, "SMALL")
    subnets          = optional(list(object({
      cidr       = string
      create_vm  = optional(bool, false)
      name       = string
      vm_type    = optional(string, "e2-micro")
    })))

  }))
    default = []
}

variable "public_key" {
  description  = "Path to public key used to connect to virtual machines"
  type         = string
  sensitive    = true
  default      = "files/key.pub"
}