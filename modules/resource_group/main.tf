resource "azurerm_resource_group" "rg" {
  name     = "rg-stirling-${var.environment}"
  location = var.location

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_resource_group" "rg1" {
  name     = "rg2"
  Location = var.location

  tags = {
    environment = "${var.environment}"
  }
}