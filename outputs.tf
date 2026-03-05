output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_location" {
  value = module.resource_group.location
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
