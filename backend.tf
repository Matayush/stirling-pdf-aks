terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60.0"
    }
  }

  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    resource_group_name  = "rg-tfstate-shared"
    storage_account_name = "stirlingtfstate"
    container_name       = "stirling-tfstate"
  }
}

provider "azurerm" {
  #subscription_id = var.subscription_id # Read from environment variable or directly from Terraform Cloud
  features {}
  resource_provider_registrations = "none"
  use_oidc                        = true
}
#provider "azurerm" {
#  subscription_id = var.subscription_id