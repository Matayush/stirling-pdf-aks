variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, test, prod)"
}