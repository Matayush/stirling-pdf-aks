resource "azurerm_resource_group" "rg" {
  name     = "rg-stirling1-${var.environment}"
  location = var.location

  tags = {
    environment = "${var.environment}"
  }
}