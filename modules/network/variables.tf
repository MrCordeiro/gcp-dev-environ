variable "network_name" {
  description = "Name for the VPC network"
  type        = string
}

variable "subnetwork_name" {
  description = "Name for the subnetwork"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnetwork"
  type        = string
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
}

variable "project" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "firewall_name" {
  description = "Name for the firewall rule"
  type        = string
}

variable "router_name" {
  description = "Name for the router"
  type        = string
}

variable "nat_name" {
  description = "Name for the NAT gateway"
  type        = string
}

variable "host_ip" {
  description = "IP of the host which will have access to the instances"
  type        = string
}
