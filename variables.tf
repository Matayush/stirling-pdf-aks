variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

#variable "environment" {
#  type = string
#  # default     = "prod"
#  description = "Environment name (e.g., dev, test, prod)"
#}

#variable "backend_key" {
#  type = string
#}
