resource "azurerm_container_registry" "cr" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
}