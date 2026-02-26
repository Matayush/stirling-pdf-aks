variable "resource_group_name" {
  type        = string
  default     = "stirling-pdf-prod-rg"
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  default     = "polandcentral"
  description = "Azure region for all resources"
}

variable "prefix" {
  description = "Project prefix"
  type        = string
  default     = "stirling"
}

variable "environment" {
  type = string
  # default     = "prod"
  description = "Environment name (e.g., dev, test, prod)"
}
