variable "resource_group_name" {}  # e.g. "rg-dev"
variable "location" {}             # e.g. "polandcentral"  
variable "environment" {}          # e.g. "dev"
variable "vnet_cidr" {
    description = "CIDR block for the virtual network"
    type        = string
    default = "10.0.0.0/16" 
}