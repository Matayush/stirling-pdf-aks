output "aks_subnet_id" {
  value       = azurerm_subnet.aks_subnet.id
  description = "The ID of the AKS subnet."
}

output "aks_nsg_id" {
  value = azurerm_network_security_group.aks_nsg.id
}