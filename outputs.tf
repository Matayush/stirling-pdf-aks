output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_location" {
  value = module.resource_group.location
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "log_analytics_workspace_id" {
  value       = module.monitoring.log_analytics_workspace_id
  description = "Log Analytics Workspace ID — use for diagnostics settings on other resources"
}
