### -----------------------MAIN--------------------- ###
# Creación del grupo de recursos
module "resource_group" {
  source   = "./modules/resource_group"
  name     = "${var.prefix_name}-rg"
  location = var.region
}

data "azurerm_client_config" "current" {}

### -----------------------NETWORK--------------------- ###
# Creación de la red virtual del application gateway
module "virtual_network_appigw" {
  source              = "./modules/virtual_network"
  name                = "${var.prefix_name}-vn-appigw"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = module.resource_group.name
}

# Creación de la red virtual del aks
module "virtual_network_aks" {
  source              = "./modules/virtual_network"
  name                = "${var.prefix_name}-vn-aks"
  address_space       = ["10.1.0.0/16"]
  location            = var.region
  resource_group_name = module.resource_group.name
}

# Creación de la subred para el application-gateway
module "appgw_subnet" {
  source               = "./modules/subnet"
  name                 = "${var.prefix_name}-sn-appgw"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network_appigw.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Creación de la subred para el bastion
module "AzureBastionSubnet" {
  source               = "./modules/subnet"
  name                 = "AzureBastionSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network_aks.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Creación de una subnet para el cluster aks
module "aks_subnet" {
  source               = "./modules/subnet"
  name                 = "${var.prefix_name}-sn-aks"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network_aks.name
  address_prefixes     = ["10.1.2.0/24"]
}

#Llamado al modulo de la Ip Pública del api-gateway
module "ip_appgw" {
  source              = "./modules/public_ip"
  name                = "${var.prefix_name}-ip-appgw"
  location            = var.region
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Llamado al modulo de la Ip Pública del bastion
module "ip_bastion" {
  source              = "./modules/public_ip"
  name                = "${var.prefix_name}-ip-bastion"
  location            = var.region
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Emparejamiento/Conexión desde Application Gateway hacia Cluster AKS 
module "peeringAppgwToCluster" {
  source                       = "./modules/network_peering"
  name                         = "${var.prefix_name}-peer-appgw-cluster"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = module.virtual_network_appigw.name
  remote_virtual_network_id    = module.virtual_network_aks.id
  allow_virtual_network_access = true

}

# Emparejamiento/Conexión desde Cluster AKS hacia Application Gateway
module "peeringClusterToAppgw" {
  source                       = "./modules/network_peering"
  name                         = "${var.prefix_name}-peer-cluster-appgw"
  resource_group_name          = module.resource_group.name
  virtual_network_name         = module.virtual_network_aks.name
  remote_virtual_network_id    = module.virtual_network_appigw.id
  allow_virtual_network_access = true
}

### -----------------------SECURITY--------------------- ###
#Llamado al módulo de appigateway
module "application_gateway" {
  source                                          = "./modules/application_gateway"
  name                                            = "${var.prefix_name}AppiGW"
  resource_group_name                             = module.resource_group.name
  location                                        = module.resource_group.location
  sku_name                                        = "Standard_v2"
  sku_tier                                        = "Standard_v2"
  sku_capacity                                    = 2
  gateway_ip_configuration_name                   = "appgwIpConfig"
  subnet_id                                       = module.appgw_subnet.id
  frontend_ip_configuration_name                  = "${module.appgw_subnet.name}-front-ipconfig"
  public_ip_address_id                            = module.ip_appgw.id
  frontend_port_name                              = "${module.appgw_subnet.name}-front-http-port"
  frontend_port_port                              = 80
  backend_address_pool_name                       = "${module.appgw_subnet.name}-backend-pool"
  backend_http_settings_name                      = "${module.appgw_subnet.name}-backend-http-setting"
  cookie_based_affinity                           = "Disabled"
  backend_http_settings_port                      = 80
  backend_http_settings_protocol                  = "Http"
  backend_http_settings_request_timeout           = 60
  http_listener_name                              = "${module.appgw_subnet.name}-http-listener"
  http_listener_frontend_ip_configuration_name    = "${module.appgw_subnet.name}-front-ipconfig"
  http_listener_frontend_port_name                = "${module.appgw_subnet.name}-front-http-port"
  http_listener_protocol                          = "Http"
  request_routing_rule_name                       = "${module.appgw_subnet.name}-request-routing-rule"
  request_routing_rule_rule_type                  = "Basic"
  request_routing_rule_priority                   = 9
  request_routing_rule_http_listener_name         = "${module.appgw_subnet.name}-http-listener"
  request_routing_rule_backend_address_pool_name  = "${module.appgw_subnet.name}-backend-pool"
  request_routing_rule_backend_http_settings_name = "${module.appgw_subnet.name}-backend-http-setting"
}

# Llamado al modulo de key vault
module "key_vault" {
  source                      = "./modules/key_vault"
  key_vault_name              = "${var.prefix_name}KeyVault"
  location                    = module.resource_group.location
  resource_group_name         = module.resource_group.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
}

module "role_aks_cluster" {
  source                           = "./modules/role_assignment"
  principal_id                     = module.aks_cluster.principal_id
  role_definition_name             = "AcrPull"
  scope                            = module.container_registry.scope
  skip_service_principal_aad_check = true
}

module "role_key_vault_access" {
  source                           = "./modules/role_assignment"
  principal_id                     = module.identity.principal_id
  role_definition_name             = "Reader"
  scope                            = module.key_vault.key_vault_id
  skip_service_principal_aad_check = false
}

module "access_policy_current_user" {
  source                  = "./modules/access_policy"
  key_vault_id            = module.key_vault.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = coalesce(data.azurerm_client_config.current.object_id)
  key_permissions         = ["Get", "Create", "List", "Delete", "Purge", "Recover", "SetRotationPolicy", "GetRotationPolicy"]
  secret_permissions      = ["Get", "Set", "List", "Delete", "Purge", "Recover"]
  certificate_permissions = ["Get"]
}

module "access_policy_identity" {
  source                  = "./modules/access_policy"
  key_vault_id            = module.key_vault.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = module.identity.principal_id
  key_permissions         = ["Get", "Create", "List", "Delete", "Purge", "Recover", "SetRotationPolicy", "GetRotationPolicy"]
  secret_permissions      = ["Get", "Set", "List", "Delete", "Purge", "Recover"]
  certificate_permissions = ["Get"]

  depends_on = [
    module.access_policy_current_user,
    module.key_vault,
    module.identity
  ]
}

module "access_policy_aks_cluster" {
  source                  = "./modules/access_policy"
  key_vault_id            = module.key_vault.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = module.aks_cluster.secret_provider
  key_permissions         = ["Get", "Create", "List", "Delete", "Purge", "Recover", "SetRotationPolicy", "GetRotationPolicy"]
  secret_permissions      = ["Get", "Set", "List", "Delete", "Purge", "Recover"]
  certificate_permissions = ["Get"]

  depends_on = [
    module.access_policy_current_user,
    module.key_vault,
    module.aks_cluster
  ]
}

module "key_vault_secret_webserver-config" {
  source       = "./modules/key_vault_secret"
  name         = "${var.prefix_name}-conf"
  value        = "config-value"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_webserver_properties" {
  source       = "./modules/key_vault_secret"
  name         = "${var.prefix_name}-prop"
  value        = "properties-value"
  key_vault_id = module.key_vault.key_vault_id
}



module "identity" {
  source              = "./modules/identity"
  name                = "${var.prefix_name}-identity"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

}

# Llamado al modulo de bastion para crear el bastion host
module "bastion" {
  source                = "./modules/bastion"
  name                  = "${var.prefix_name}-bastion"
  location              = module.resource_group.location
  resource_group_name   = module.resource_group.name
  ip_configuration_name = "${var.prefix_name}-config-ip-bastion"
  subnet_id             = module.AzureBastionSubnet.id
  public_ip_address_id  = module.ip_bastion.id
}

### -----------------------CONTAINER REGISTRY--------------------- ###
# Llamado al modulo para la creación del container registry
module "container_registry" {
  source              = "./modules/container_registry"
  container_name      = "${var.prefix_name}cr"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = "Standard"
  admin_enabled       = true
}

### -----------------------COMPUTE--------------------- ###
# Llamado al modulo para la creación del clúster de AKS
module "aks_cluster" {
  source                  = "./modules/aks_cluster"
  name                    = "${var.prefix_name}-aks"
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  dns_prefix              = "${var.prefix_name}-aks"
  node_pool_name          = "${var.prefix_name}pool"
  node_count              = 1
  vm_size                 = "Standard_DS2_v2"
  os_disk_size_gb         = 40
  subnet_id               = module.aks_subnet.id
  network_plugin          = "azure"
  identity_type           = "SystemAssigned"
  secret_rotation_enabled = true
  local_file              = "KubeConfig"
}


### -----------------------SCRIPTING--------------------- ###

resource "null_resource" "execute_script" {
  depends_on = [
    module.application_gateway,
    module.key_vault,
    module.aks_cluster,
    module.role_key_vault_access,
    module.role_aks_cluster,
    module.container_registry,
    module.bastion,
    module.resource_group,
    module.access_policy_aks_cluster,
    module.access_policy_identity,
    module.access_policy_current_user,
    module.key_vault_secret_webserver-config,
    module.key_vault_secret_webserver_properties
  ]
  provisioner "local-exec" {
    command = "chmod +x script.sh && ./script.sh"
  }
}