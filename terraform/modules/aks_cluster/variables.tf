variable "name" {
  description = "Name of the AKS cluster"
}

variable "location" {
  description = "Name of the AKS cluster"
}

variable "resource_group_name" {
  description = "resource group for the AKS cluster"
}

variable "dns_prefix" {
  description = "dns of the AKS cluster"
}

variable "node_pool_name" {
  description = "name of the AKS cluster's node pool"
}

variable "node_count" {
  description = "number of pods replicas for the AKS cluster's node pool"
}

variable "vm_size" {
  description = "vm size for the AKS cluster's node pool"
}

variable "os_disk_size_gb" {
  description = "size of the operative system disk" 
}

variable "subnet_id" {
  description = "id of the subnet for the AKS cluster's node pool"
}

variable "network_plugin"{
  description = "enables you to configure communication within your k8s network"
}

variable "identity_type"{
  description = "identity type of the aks_cluster"
}

variable "secret_rotation_enabled" {
  description = "Must be specified to enable key_vault_secrets_provider"
}

variable "local_file" {
  description = "Name of the kuberneter file"
  default = "kubeconfig"
}