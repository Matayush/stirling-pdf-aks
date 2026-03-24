output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.aks.id
  description = "Log Analytics Workspace ID for AKS monitoring"
}