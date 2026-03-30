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
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
}

variable "disk_encryption_set_id" {
  type        = string
  description = "ID of the Disk Encryption Set for AKS node disk encryption"
}

variable "service_cidr" {
  type        = string
  description = "CIDR range for Kubernetes services - must not overlap with VNet subnets"
}

variable "dns_service_ip" {
  type        = string
  description = "IP address for the Kubernetes DNS service - must be within service_cidr"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for OMS agent monitoring"
}

variable "allowed_ips" {
  type        = list(string)
  description = "IP ranges allowed to reach the AKS API server"
  default     = []
}