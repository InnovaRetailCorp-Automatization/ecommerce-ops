variable "name" {
  description = "The name of the resource group in which to create the IaC"
}

variable "location" {
  description = "The location of the resource group"
  default =  "East US"
}