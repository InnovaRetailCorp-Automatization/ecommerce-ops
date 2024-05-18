# Creación de la red virtual
resource "azurerm_virtual_network" "vn" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}