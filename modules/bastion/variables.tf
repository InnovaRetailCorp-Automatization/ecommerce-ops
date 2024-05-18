# Variables del bastion

variable "name" {
  description = "The name of the Bastion."
}

variable "location" {
  description = "The location of the Bastion."
}

variable "resource_group_name" {
  description = "The location of the Bastion."
}

# Variables del ip_configuration

variable "ip_configuration_name" {
  description = "The name of the ip_configuration of the Bastion."
}

variable "subnet_id" {
  description = "The name of the ip_configuration of the Bastion."
}

variable "public_ip_address_id" {
  description = "The name of the ip_configuration of the Bastion."
}
