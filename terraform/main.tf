### -----------------------MAIN--------------------- ###
# Creación del grupo de recursos
module "resource_group" {
  source   = "./modules/resource_group"
  name     = "${var.prefix_name}-rg"
  location = var.region
}

data "azurerm_client_config" "current" {}

### -----------------------NETWORK--------------------- ###
# Creación de la red virtual del aks
module "virtual_network_aks" {
  source              = "./modules/virtual_network"
  name                = "${var.prefix_name}-vn-aks"
  address_space       = ["10.1.0.0/16"]
  location            = var.region
  resource_group_name = module.resource_group.name
}
# Creación de una subnet para el cluster aks
module "aks_subnet" {
  source               = "./modules/subnet"
  name                 = "${var.prefix_name}-sn-aks"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network_aks.name
  address_prefixes     = ["10.1.2.0/24"]
}

### -----------------------SECURITY--------------------- ###
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

module "key_vault_secret_next_public_clerk_publishable_key" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLERK-PUBLISHABLE-KEY"
  value        = "pk_test_ZGlyZWN0LXByaW1hdGUtOS5jbGVyay5hY2NvdW50cy5kZXYk"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_clerk_secret_key" {
  source       = "./modules/key_vault_secret"
  name         = "CLERK-SECRET-KEY"
  value        = "sk_test_WebkU17WzKULXRFNRJu1GtTPg53ppp2klORhDWrHGa"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_clerk_sign_in_url" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLERK-SIGN-IN-URL"
  value        = "/sign-in"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_clerk_sign_up_url" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLERK-SIGN-UP-URL"
  value        = "/sign-up"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_clerk_after_sign_in_url" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLERK-AFTER-SIGN-IN-URL"
  value        = "/"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_clerk_after_sign_up_url" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLERK-AFTER-SIGN-UP-URL"
  value        = "/"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_database_url" {
  source       = "./modules/key_vault_secret"
  name         = "DATABASE-URL"
  value        = "mysql://admin:Pass123.@mysql:3306/ecommerce_db"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_cloudinary_cloud_name" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-CLOUDINARY-CLOUD-NAME"
  value        = "dat9omhgf"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_stripe_api_key" {
  source       = "./modules/key_vault_secret"
  name         = "STRIPE-API-KEY"
  value        = "sk_test_51POmsOHDtVBmcKUIIFRQ2C65AqO0TL4DdPjvU7Nd8Jv73UeFFQnjvyO1qfPxfulf3ofbPC4YDu8onwOdFgVCqV8g008VqhB01X"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_frontend_store_url" {
  source       = "./modules/key_vault_secret"
  name         = "FRONTEND-STORE-URL"
  value        = "http://48.217.211.186:3001"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_stripe_webhook_secret" {
  source       = "./modules/key_vault_secret"
  name         = "STRIPE-WEBHOOK-SECRET"
  value        = "whsec_5188f9ac9e8498dffae7934584e531ad8bd4d28a1915a28351a0400a8ecfcf8f"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_next_public_api_url" {
  source       = "./modules/key_vault_secret"
  name         = "NEXT-PUBLIC-API-URL"
  value        = "http://48.217.211.112:3000/api/cec6cf95-abd3-419e-a223-5c85cbbb0370"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_react_editor" {
  source       = "./modules/key_vault_secret"
  name         = "REACT-EDITOR"
  value        = "atom"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_billboard_id" {
  source       = "./modules/key_vault_secret"
  name         = "BILLBOARD-ID"
  value        = "b321e067-b8d0-435d-bd31-9768581c1733"
  key_vault_id = module.key_vault.key_vault_id
}

module "key_vault_secret_cloudinary_preset_name" {
  source       = "./modules/key_vault_secret"
  name         = "CLOUDINARY-PRESET-NAME"
  value        = "e2wxzg4y"
  key_vault_id = module.key_vault.key_vault_id
}



module "identity" {
  source              = "./modules/identity"
  name                = "${var.prefix_name}-identity"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

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
  node_count              = 2
  vm_size                 = "Standard_DS2_v2"
  os_disk_size_gb         = 40
  subnet_id               = module.aks_subnet.id
  network_plugin          = "azure"
  identity_type           = "SystemAssigned"
  secret_rotation_enabled = true
  local_file              = "KubeConfig"
}

resource "null_resource" "execute_script" {
  depends_on = [
    module.application_gateway,
    module.key_vault,
    module.aks_cluster,
    module.role_key_vault_access,
    module.role_aks_cluster,
    module.container_registry,
    module.resource_group,
    module.access_policy_aks_cluster,
    module.access_policy_identity,
    module.access_policy_current_user,
    module.key_vault_secret_webserver-config,
    module.key_vault_secret_webserver_properties
  ]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "chmod +x script.sh && ./script.sh"
  }
}
