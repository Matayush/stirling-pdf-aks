# Reads the identity of the current authenticated caller (Service Principal 
# in CI/CD, or your az login user locally). Exposes tenant_id and object_id
# used to configure Key Vault and RBAC role assignments without hardcoding values.
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                       = "key-vault-stirling${var.environment}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 90
  enable_rbac_authorization  = true


  tags = {
    environment = var.environment
  }
}

# Grants the Terraform Service Principal permission to create/manage keys
resource "azurerm_role_assignment" "terraform_key_vault_access" {
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Crypto Officer"
  scope                = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_key" "key_vault_key" {
  name         = "stirling-key-${var.environment}"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P365D"
    notify_before_expiry = "P45D"
  }

  tags = {
    environment = var.environment
  }
  depends_on = [azurerm_role_assignment.terraform_key_vault_access]
}

resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = "disk-encryption-set-stirling${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.key_vault_key.versionless_id
  # versionless — required for auto-rotation to work, as the key version changes with rotation
  auto_key_rotation_enabled = true


  identity {
    type = "SystemAssigned"

  }
  tags = {
    environment = var.environment
  }
}
# Grants DES managed identity permission to use the key at runtime
resource "azurerm_role_assignment" "des_key_vault_access" {
  principal_id         = azurerm_disk_encryption_set.disk_encryption_set.identity[0].principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = azurerm_key_vault.key_vault.id
}
