output "name" {
  description = "The name of the resource"
  value =azurerm_kubernetes_cluster.aks_cluster.name
}

variable "location" {
  description = "The location of the resource, is the same as the resource group"
  default =  "East US"
}

variable "resource_group_name" {
  description = "Resource group of the IaC"
}

variable "dns_prefix" {
  description = "Azure method to assign an ip"
}

variable "private_cluster_enabled" {
  description = "The location of the resource, is the same as the resource group"
}

# Variables del node pool
variable "node_pool_name" {
  description = "The name of the resource"
}

variable "node_count" {
  description = "The name of the resource"
}

variable "vm_size" {
  description = "The name of the resource"
}

variable "os_disk_size_gb" {
  description = "The name of the resource"
}

variable "vnet_subnet_id" {
  description = "The name of the resource"
}

# variables del network_profile
variable "network_plugin" {
  description = "The name of the resource"
  default = "SystemAssigned"
}

# variables identity
variable "identity_type" {
  description = "The name of the resource"
  default = "SystemAssigned"
}

# Variables key_vault_secrets_provider
variable "secret_rotation_enabled" {
  description = "The location of the resource, is the same as the resource group"
}

# Variables de local_vile
variable "filename" {
  description = "The location of the resource, is the same as the resource group"
  default =  "East US"
}
