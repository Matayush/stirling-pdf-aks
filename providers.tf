terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60.0"
    }
  }

  cloud {
    organization = "ceniuk-mateusz-org"

    workspaces {
      name = "stirling-pdf-dev"
    }
  }
}

provider "azurerm" {
  #subscription_id = var.subscription_id # Read from environment variable or directly from Terraform Cloud
  features {}
}