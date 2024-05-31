variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
}

variable "location" {
  description = "Location for the Azure Key Vault"
}


variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}


variable "tenant_id" {
  description = "Tenant ID"
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention period in days"
}

variable "sku_name" {
  description = "SKU name for the Azure Key Vault"
}

variable "enabled_for_disk_encryption" {
  description = "Notify before expiry"
}

variable "purge_protection_enabled" {
  description = "Notify before expiry"
}