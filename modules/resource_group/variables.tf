variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

