variable "resource_group_name" {
    type        = string
    description = "Resource group name passed from Resource_group module to Networking module"
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
    type        = string
    description = "CIDR block for the virtual network" 
}