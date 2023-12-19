terraform {
  required_version = ">= 1.6.1"

  required_providers {

    alkira = {
      source  = "alkiranet/alkira"
      version = ">= 1.1.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 4.64, < 6"
    }

  }
}