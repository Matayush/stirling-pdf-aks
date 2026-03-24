resource "azurerm_kubernetes_cluster" "aks" {
  # checkov:skip=CKV_AZURE_115:Private cluster deferred - requires self-hosted runner inside VNet or VPN for CI/CD pipeline access to private API server, would inquire additional costs
  # checkov:skip=CKV_AZURE_232: Dedicated system/user node pools not used — doubles VM cost for test env. Enable in prod with only_critical_addons_enabled=true.
  name                   = "aks-${var.environment}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  dns_prefix             = "stirling-${var.environment}"
  disk_encryption_set_id = var.disk_encryption_set_id
  azure_policy_enabled   = true # ← Enforce Azure Policy for Kubernetes on this cluster,  no policies active until explicitly assigned, CKV 116

  sku_tier = "Free"
  # ← Free control plane (no SLA guarantee)

  default_node_pool {
    name                        = "default"
    node_count                  = var.node_count
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.aks_subnet_id
    host_encryption_enabled     = true # free - encrypts temp disks, caches and data flowstores with platform-managed keys, satisfies encryption requirements for this workload CKV_AZURE_227
    temporary_name_for_rotation = "tmpdefault"
    max_pods                    = 110 # default Azure CNI overlay value, satisfies CKV_AZURE_168
    #enable_auto_scaling = true
    #min_count           = 0   # ← scales to 0 when idle
    #max_count           = 1
  }

  identity {
    type = "SystemAssigned"
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

  tags = {
    environment = var.environment
  }
}