terraform {
  required_version = ">= 1.14.0"

  cloud {
    organization = "hc-stoffee"

    workspaces {
      name = "azure-resource-discovery"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.58.0"
    }
  }
}
