output "application_gateway_id" {
  description = "The ID of the created Azure Application Gateway."
  value       = azurerm_application_gateway.appgw.id
}

output "application_gateway_name" {
  description = "The name of the created Azure Application Gateway."
  value       = azurerm_application_gateway.appgw.name
}