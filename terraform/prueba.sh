#!/bin/bash

# Obtener el nombre del grupo de recursos
resourceGroupName=$(terraform output -raw resource_group_name)

# Obtener el nombre de la aplicación de la puerta de enlace de aplicaciones
applicationGatewayName=$(terraform output -raw application_gateway_name)

# Obtener el nombre del cluster
clusterName=$(terraform output -raw cluster_name)

#Obtener el nombre del container registry
cr_name=$(terraform output -raw cr_name)

#Obtener el client_id del identity
client_id=$(terraform output -raw identity_client_id)

# Ejecutar el comando de Azure CLI con los valores obtenidos
#appgwId=$(az network application-gateway list -g $resourceGroupName --query "[?name=='$applicationGatewayName'].id" -o tsv)
appgwId=$(az network application-gateway show --resource-group $resourceGroupName --name innovaAppiGW --query "id" -o tsv)


export AKS_OIDC_ISSUER="$(az aks show --resource-group $resourceGroupName --name $clusterName --query "oidcIssuerProfile.issuerUrl" -o tsv)"

# Habilita los addons para la puerta de enlace de aplicaciones
#az aks enable-addons -n $clusterName -g $resourceGroupName -a ingress-appgw --appgw-id $appgwId
az aks enable-addons --resource-group innova-rg --name $clusterName --addons ingress-appgw --appgw-id $appgwId


# Activa el managed identity
az aks update -g $resourceGroupName -n $clusterName --enable-managed-identity

az acr login --name $cr_name 

# Imprimir los valores de las variables
echo "Resource Group Name: $resourceGroupName"
echo "Application Gateway Name: $applicationGatewayName"
echo "Cluster Name: $clusterName"
echo "Application Gateway ID: $appgwId"
echo "identity client_id: $client_id"
echo $AKS_OIDC_ISSUER