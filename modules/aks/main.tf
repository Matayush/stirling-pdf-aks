resource "azurerm_kubernetes_cluster" "aks" {
  # checkov:skip=CKV_AZURE_115:Private cluster deferred - requires self-hosted runner inside VNet or VPN for CI/CD pipeline access to private API server, would inquire additional costs
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

  tags = {
    environment = var.environment
  }
}