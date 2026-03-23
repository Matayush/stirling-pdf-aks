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

resource "azurerm_subnet" "load_balancer_subnet" {
  name                 = "subnet-Loadbalancer-${var.resource_group_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# NSG for AKS subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "nsg-aks-${var.resource_group_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowCiliumVXLAN"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "8472"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowCiliumHealth"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4240"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    environment = "${var.environment}"
  }
}
# Associate NSG with AKS subnet
resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}