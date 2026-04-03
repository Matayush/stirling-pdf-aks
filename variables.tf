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
  description = "Environment name (e.g., dev, test, prod)"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_D2s_v3"
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for Kubernetes services - must not overlap with VNet subnets"
  default     = "10.0.2.0/24"
}

variable "dns_service_ip" {
  type        = string
  description = "IP address for the Kubernetes DNS service - must be within service_cidr"
  default     = "10.0.2.10"
}

variable "allowed_ips" {
  type        = list(string)
  description = "Static IPs always allowed through Key Vault ACL (e.g. dev machine IP)"
  default     = []
}