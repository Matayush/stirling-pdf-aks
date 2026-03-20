resource "azurerm_kubernetes_cluster" "aks" {
  name                   = "aks-${var.environment}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  dns_prefix             = "stirling-${var.environment}"
  disk_encryption_set_id = var.disk_encryption_set_id

  sku_tier = "Free"
  # ← Free control plane (no SLA guarantee)

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.aks_subnet_id
    #enable_auto_scaling = true
    #min_count           = 0   # ← scales to 0 when idle
    #max_count           = 1
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.20.0.0/16"
    dns_service_ip = "10.20.0.10"
  }

  tags = {
    environment = var.environment
  }
}