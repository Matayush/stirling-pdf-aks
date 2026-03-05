resource "azurerm_container_registry" "acr" {
  name                = "acr${var.environment}"
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