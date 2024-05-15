# Creación del clúster de AKS
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name            = var.node_pool_name
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_size_gb = var.os_disk_size_gb
    vnet_subnet_id  = var.vnet_subnet_id
  }

  network_profile {
    network_plugin = var.network_plugin
  }

  identity {
    type = var.identity_type
  }

  key_vault_secrets_provider {
    # update the secrets on a regular basis
    secret_rotation_enabled = var.secret_rotation_enabled
  }
}


#Archivo kubeconfig para configurar la información de conexión del cluster
resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
  filename   = var.filename
  content    = azurerm_kubernetes_cluster.kc.kube_config_raw
}