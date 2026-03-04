variable "resource_group_name" {
  type        = string
  description = "Resource group where AKS will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "dev / test / prod"
}

variable "aks_subnet_id" {
  type        = string
  description = "Subnet ID from networking module where AKS nodes will live"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_D2s_v3"
}