resource "azurerm_resource_group" "rg" {
  name     = "rg-stirling-${var.environment}"
  location = var.location

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "testRG"
  location = var.location

  tags = {
    environment = var.environment
  }
}