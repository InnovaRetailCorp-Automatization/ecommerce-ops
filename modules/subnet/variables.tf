variable "name" {
  description = "The name of the resource"
}

variable "resource_group_name" {
  description = "Resource group of the IaC"
}

variable "virtual_network_name" {
  description = "Virtual network or supernet of the subnet"
}

variable "address_prefixes" {
  description = "Range of ip for the subnet"
}

