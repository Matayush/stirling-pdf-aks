resource "azurerm_kubernetes_cluster" "aks" {
  # checkov:skip=CKV_AZURE_115:Private cluster deferred - requires self-hosted runner inside VNet or VPN for CI/CD pipeline access to private API server, would inquire additional costs
  # checkov:skip=CKV_AZURE_232: Dedicated system/user node pools not used — doubles VM cost for test env. Enable in prod with only_critical_addons_enabled=true.
  # checkov:skip=CKV_AZURE_170: Free SKU intentionally used for dev/test environments to minimise cost.
  # checkov:skip=CKV_AZURE_141: Local admin account retained for CI/CD pipeline access via GitHub Actions. Azure AD RBAC integration planned as a dedicated future milestone.
  name                   = "aks-${var.environment}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  dns_prefix             = "stirling-${var.environment}"
  disk_encryption_set_id = var.disk_encryption_set_id
  azure_policy_enabled   = true # ← Enforce Azure Policy for Kubernetes on this cluster,  no policies active until explicitly assigned, CKV 116

  sku_tier = "Free"
  # ← Free control plane (no SLA guarantee)
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type = "SystemAssigned"
  }

  # Restricts API server access to known IPs — runner IP injected at pipeline runtime via CLI
  api_server_access_profile {
    authorized_ip_ranges = length(var.allowed_ips) > 0 ? var.allowed_ips : null
  }

  default_node_pool {
    name                        = "default"
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.aks_subnet_id
    host_encryption_enabled     = true # free - encrypts temp disks, caches and data flowstores with platform-managed keys, satisfies encryption requirements for this workload CKV_AZURE_227
    temporary_name_for_rotation = "tmpdefault"
    max_pods                    = 110         # default Azure CNI overlay value, satisfies CKV_AZURE_168
    os_disk_type                = "Ephemeral" # CKV_AZURE_226 - Ephemeral OS disks provide better performance and are suitable for stateless workloads, satisfies encryption requirements for this workload with host_encryption_enabled=true
    os_disk_size_gb             = 30

    # Cluster Autoscaler
    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 3
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    pod_cidr            = "192.168.0.0/16"
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
  }

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "10m"

  }

  automatic_upgrade_channel = "patch"     # ← Automatic patch updates for control plane, balances stability and security, CKV_AZURE_117
  node_os_upgrade_channel   = "NodeImage" # ← Automatic OS image updates for nodes, ensures security updates without changing Kubernetes version

  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Sunday"
    start_time  = "02:00"
    utc_offset  = "+01:00" # adjust to your local time zone
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Sunday"
    start_time  = "03:00"
    utc_offset  = "+01:00" # adjust to your local time zone
  }

  tags = {
    environment = var.environment
  }
}