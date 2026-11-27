terraform {

  required_version = ">= 1.13.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.10.0"
    }
  }

}
