terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-shared"
    storage_account_name = "stirlingtfstate"
    container_name       = "stiriling-tfstate"
    #   key                  = var.backend_key
  }
}

provider "azurerm" {
  #subscription_id = var.subscription_id # Read from environment variable or directly from Terraform Cloud
  features {}
}
#provider "azurerm" {
#  subscription_id = var.subscription_id