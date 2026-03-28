output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "aks_principal_id" {
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  description = "AKS managed identity principal ID for ACR pull access"
}

output "key_vault_secrets_provider_identity" {
  value       = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity
  description = "Managed identity used by the Secrets Store CSI Driver"
}