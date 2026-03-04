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

module "aks" {
  source              = "./modules/aks"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  aks_subnet_id       = module.networking.aks_subnet_id
  node_count          = var.node_count
  vm_size             = var.vm_size
}
#  source              = "./modules/monitoring"
#  resource_group_name = module.resource_group.name
#  location            = module.resource_group.location
#  prefix              = var.prefix
#  environment         = var.environment
#}
#module "acr" {
#  source              = "../modules/acr"
#  resource_group_name = module.rg.name
#  location            = module.rg.location
#}