resource "azurerm_container_registry" "acr" {
  name                = "acr{var.environment}"   # must be globally unique, no dashes
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"                           # cheapest tier ~$5/month

  admin_enabled = false   # use managed identity instead of username/password

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