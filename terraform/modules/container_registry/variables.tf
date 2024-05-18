variable "container_name" {
  description = "The name of the Azure Container Registry."
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Azure Container Registry."
}

variable "location" {
  description = "The location of the resource group in which to create the Azure Container Registry."
}

variable "sku" {
  description = "The SKU name of the Azure Container Registry."
  default = "Basic"
}

variable "admin_enabled" {
  description = "The SKU name of the Azure Container Registry."
  default = true
}