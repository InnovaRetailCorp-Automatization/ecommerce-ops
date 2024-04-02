provider "azurerm" {
  features {}
}

### -----------------------MAIN--------------------- ###
# Creación del grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix_name}-rg"
  location = var.region
}

### -----------------------NETWORK--------------------- ###
# Creación de la red virtual
resource "azurerm_virtual_network" "vn" {
  name                = "${var.prefix_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
}

# Creación de la subred para el application-gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "${var.prefix_name}-appgw-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Creación de una subnet para nodos y pods
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.prefix_name}-aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.1.0/24"] # Cambiado para evitar conflicto con el CIDR de la subred existente
}

### -----------------------SECURITY--------------------- ###

### -----------------------CONTAINER REGISTRY--------------------- ###
resource "azurerm_container_registry" "cr" {
  name                = "${var.prefix_name}containerReg" # Cambiado para coincidir con el prefijo
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  sku                 = "Basic"
  admin_enabled       = true
}

### -----------------------COMPUTE--------------------- ###

# Creación del clúster de AKS
resource "azurerm_kubernetes_cluster" "kc" {
  name                             = "${var.prefix_name}-aks"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  dns_prefix                       = "${var.prefix_name}-aks"
  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
  }
  identity {
    type = "SystemAssigned"
  }
}




