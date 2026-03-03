variable "resource_group_name" {}  # e.g. "rg-dev"
variable "location" {}             # e.g. "polandcentral"  
variable "environment" {}          # e.g. "dev"
variable "vnet_cidr" { default = "10.0.0.0/16" }  # IP range