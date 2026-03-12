resource "azurerm_container_registry" "acr" {
  # checkov:skip=CKV_AZURE_163:Defender for Containers handles vuln scanning at subscription level
  # checkov:skip=CKV_AZURE_166:Quarantine policy requires Defender for Containers, not Terraform-configurable
  
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