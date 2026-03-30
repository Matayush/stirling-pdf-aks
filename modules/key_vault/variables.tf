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

variable "allowed_ips" {
  type        = list(string)
  description = "Static IPs allowed through Key Vault network ACL"
  default     = []
}