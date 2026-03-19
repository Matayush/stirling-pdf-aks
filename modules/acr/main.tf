resource "azurerm_container_registry" "acr" {
  # checkov:skip=CKV_AZURE_163:Requires Standard or Premium SKU
  # checkov:skip=CKV_AZURE_237:Requires Premium SKU
  # checkov:skip=CKV_AZURE_165:Requires Premium SKU
  # checkov:skip=CKV_AZURE_139:Requires Premium SKU for enabling private endpoints
  # checkov:skip=CKV_AZURE_166:Requires Premium SKU
  # checkov:skip=CKV_AZURE_164:Requires Premium SKU
  # checkov:skip=CKV_AZURE_167:Requires Premium SKU
  # checkov:skip=CKV_AZURE_233:Requires Zone redundancy is now enabled by default for all registries in supported regions

  
  name                = "acrstirling${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"

  # use managed identity instead of username/password
  admin_enabled = false

  tags = {
    environment = var.environment
  }
}

# Gives AKS permission to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = var.aks_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}