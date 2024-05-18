resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

 key_vault_secrets_provider {
    # update the secrets on a regular basis
    secret_rotation_enabled = true
  }

  private_cluster_enabled = true
}

# Generacion del archivo kubeconfig para poder linkear kubectl de forma local con el cluster en la nube
resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
  filename   = var.local_file
  content    = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}