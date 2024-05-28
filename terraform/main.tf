### -----------------------MAIN--------------------- ###
# Creación del grupo de recursos

module "resource_group" {
  source = "./modules/resource_group"
  name = "${var.prefix_name}-rg"
  location = var.region
}

### -----------------------NETWORK--------------------- ###
# Creación de la red virtual
module "virtual_network" {
  source = "./modules/virtual_network"
  name = "${var.prefix_name}-vnet"
  address_space = ["10.0.0.0/16"]
  location = var.region
  resource_group_name = module.resource_group.name
}

# Creación de la subred para el application-gateway
module "appgw_subnet" {
  source = "./modules/subnet"
  name = "${var.prefix_name}-sn-appgw"
  resource_group_name = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes = ["10.0.0.0/24"]
}

# Creación de una subnet para el cluster aks
module "aks_subnet" {
  source = "./modules/subnet"
  name = "${var.prefix_name}-sn-aks"
  resource_group_name = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes = ["10.0.2.0/24"]
}

#Llamado al modulo de la Ip Pública del api-gateway
module "ip_appgw" {
  source = "./modules/public_ip"
  name = "${var.prefix_name}-ip-appgw"
  location = var.region
  resource_group_name = module.resource_group.name
  allocation_method = "Static"
  sku = "Basic"
}
#Llamado al modulo de la Ip Pública del bastion
module "ip_bastion" {
  source = "./modules/public_ip"
  name = "${var.prefix_name}-ip-bastion"
  location = var.region
  resource_group_name = module.resource_group.name
  allocation_method = "Static"
  sku = "Basic"
}

# Emparejamiento/Conexión desde Application Gateway hacia Cluster AKS 
module "peeringAppgwToCluster" {
  source ="./modules/network_peering"
  name = "${var.prefix_name}-peer-appgw-cluster"
  resource_group_name=module.resource_group.name
  virtual_network_name=module.appgw_subnet.name
  remote_virtual_network_id=module.aks_subnet.id
  allow_virtual_network_access=true
  
}

# Emparejamiento/Conexión desde Cluster AKS hacia Application Gateway
module "peeringClusterToAppgw" {
  source ="./modules/network_peering"
  name = "${var.prefix_name}-peer-cluster-appgw"
  resource_group_name=module.resource_group.name
  virtual_network_name=module.appgw_subnet.name
  remote_virtual_network_id=module.aks_subnet.id
  allow_virtual_network_access=true
}

### -----------------------SECURITY--------------------- ###



### -----------------------CONTAINER REGISTRY--------------------- ###
# Llamado al modulo para la creación del container registry

module "container_registry" {
  source                  = "./modules/container_registry"
  container_name          = "${var.prefix_name}cr"
  resource_group_name     = module.resource_group.name
  location = module.resource_group.location
  sku           = "Standard"
  admin_enabled = true
}

### -----------------------COMPUTE--------------------- ###

# Llamado al modulo para la creación del clúster de AKS
module "aks_cluster" {
  source = "./modules/aks_cluster"
  name ="${var.prefix_name}-aks"
  location = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix = "${var.prefix_name}-aks"
  local_file = "KubeConfig"
}