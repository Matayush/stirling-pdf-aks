resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-stirling-${var.environment}"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-stirling-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "load_balancer_subnet" {
  name                 = "subnet-stirling-loadbalancer-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}