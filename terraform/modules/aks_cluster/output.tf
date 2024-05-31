output "name" {
  description = "The name of the resource"
  value =azurerm_kubernetes_cluster.aks_cluster.name
}

output "secret_provider" {
  description = "The ID of the created AKS cluster."
  value       =  azurerm_kubernetes_cluster.aks_cluster.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "principal_id" {
  description = "The ID of the created AKS cluster."
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}