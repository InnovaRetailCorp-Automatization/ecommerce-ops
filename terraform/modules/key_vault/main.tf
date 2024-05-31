
resource "azurerm_key_vault" "key_vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  soft_delete_retention_days = var.soft_delete_retention_days
  sku_name                   = var.sku_name
  enabled_for_disk_encryption= var.enabled_for_disk_encryption
  purge_protection_enabled   = var.purge_protection_enabled
}
