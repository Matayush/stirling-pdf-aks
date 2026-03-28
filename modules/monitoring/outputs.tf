output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "Log Analytics Workspace ID for AKS monitoring"
}