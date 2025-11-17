terraform {
  required_version = ">= 1.14.0"

  cloud {
    organization = "hc-stoffee"

    workspaces {
      name = "resource-discovery"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.15.0"
    }
  }
}
