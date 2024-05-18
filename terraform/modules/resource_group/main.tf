# Creación del grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}