output "disk_encryption_set_id" {
  value       = azurerm_disk_encryption_set.aks.id
  description = "ID of the Disk Encryption Set to pass to AKS"
}

output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "ID of the Key Vault to pass to AKS"
}