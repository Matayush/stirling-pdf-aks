module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  vnet_cidr           = var.vnet_cidr
}

module "key_vault" {
  source              = "./modules/key_vault"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  allowed_ips         = var.allowed_ips
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
}

module "aks" {
  source                     = "./modules/aks"
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  environment                = var.environment
  aks_subnet_id              = module.networking.aks_subnet_id
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  disk_encryption_set_id     = module.key_vault.disk_encryption_set_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  service_cidr               = var.service_cidr
  dns_service_ip             = var.dns_service_ip
  allowed_ips                = var.allowed_ips
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  aks_principal_id    = module.aks.aks_principal_id
}

# Depends on both key_vault and aks modules being created first
# Grants AKS managed identity permission to use the disk encryption key at runtime
resource "azurerm_role_assignment" "aks_key_vault_access" {
  principal_id         = module.aks.aks_principal_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  scope                = module.key_vault.key_vault_id
}