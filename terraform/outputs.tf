output "resource_group_name" {
  value = module.resource_group.name
}

output "application_gateway_name" {
  value = module.application_gateway.application_gateway_name
}

output "cluster_name" {
  value = module.aks_cluster.name
}