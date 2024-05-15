terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.103.1" #Especificar la versión de terraform
    }
  }
}

provider "azurerm" {
  features{}
}