variable "resource_group_name" {
  type        = string
  description = "Resource group where ACR will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "dev / test / prod"
}