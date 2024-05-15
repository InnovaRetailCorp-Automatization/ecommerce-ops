variable "name" {
  description = "The name of the resource"
}

variable "address_space" {
  description = "Range of ip for the virtual network"
}

variable "location" {
  description = "The location of the resource, is the same as the resource group"
  default =  "East US"
}

variable "resource_group_name" {
  description = "Resource group of the IaC"
}