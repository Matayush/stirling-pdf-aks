variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "prefix" {
  description = "Project prefix"
  type        = string
  default     = "stirling"
}

#variable "environment" {
#  type        = string
#  description = "Deployment environment (dev, test, prod)"
#}