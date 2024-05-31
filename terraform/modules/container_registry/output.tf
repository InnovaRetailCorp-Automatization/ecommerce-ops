output "scope" {
  description = "The ID of the created container registry"
  value       = azurerm_container_registry.cr.id
}