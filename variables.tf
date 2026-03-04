variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "environment" {
  type = string
  # default     = "prod"
  description = "Environment name (e.g., dev, test, prod)"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.10.0.0/16"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_D2as_v5"
}
