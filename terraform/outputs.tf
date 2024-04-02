output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.kc.id
}

output "aks_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.kc.fqdn
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.kc.kube_config_raw
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.cr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.cr.name
}

output "acr_username" {
  value = azurerm_container_registry.cr.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.cr.admin_password
  sensitive = true
}