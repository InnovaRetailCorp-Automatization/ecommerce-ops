#!/bin/bash

# Obtener el nombre del grupo de recursos
resourceGroupName=$(terraform output -raw resource_group_name)

# Obtener el nombre del Application Gateway
applicationGatewayName=$(terraform output -raw application_gateway_name)

# Obtener el nombre del cluster
clusterName=$(terraform output -raw cluster_name)

# Obtener el nombre del container registry
crName=$(terraform output -raw cr_name)

# Obtener el client_id del identity
clientId=$(terraform output -raw identity_client_id)

# Obtener el ID del Application Gateway
appgwId=$(az network application-gateway show --resource-group $resourceGroupName --name $applicationGatewayName --query "id" -o tsv)

# Verifica si se obtuvo el ID del Application Gateway
if [ -z "$appgwId" ]; then
  echo "Error: No se pudo obtener el ID del Application Gateway."
  exit 1
fi

# Habilita los addons para la puerta de enlace de aplicaciones
az aks enable-addons --resource-group $resourceGroupName --name $clusterName --addons ingress-appgw --appgw-id $appgwId

# Verifica si se habilitaron los addons correctamente
if [ $? -ne 0 ]; then
  echo "Error: No se pudo habilitar el addon ingress-appgw."
  exit 1
fi

# Activa la identidad gestionada
az aks update --resource-group $resourceGroupName --name $clusterName --enable-managed-identity

# Verifica si se habilitó la identidad gestionada correctamente
if [ $? -ne 0 ]; then
  echo "Error: No se pudo habilitar la identidad gestionada en el clúster AKS."
  exit 1
fi

# Iniciar sesión en el Azure Container Registry
az acr login --name $crName

# Verifica si el inicio de sesión en ACR fue exitoso
if [ $? -ne 0 ]; then
  echo "Error: No se pudo iniciar sesión en el Azure Container Registry."
  exit 1
fi

echo "Configuración completada con éxito."
