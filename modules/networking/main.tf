resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks_vnet-${var.resource_group_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_cidr]

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-${var.resource_group_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}
#resource "azurerm_subnet" "load_balancer_subnet" {
#  name                 = "subnet-stirling-loadbalancer-${var.environment}"
#  resource_group_name  = azurerm_resource_group.rg.name
#  virtual_network_name = azurerm_virtual_network.aks_vnet.name
#  address_prefixes     = ["10.10.1.0/24"]
#}