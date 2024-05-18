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


variable "local_file" {
  description = "Name of the kuberneter file"
  default = "kubeconfig"
}