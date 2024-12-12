variable "project_name" {
  type = string
}

variable "instance_names" {
  type = set(string)
}

variable "image" {
  type = string
}

variable "memory" {
  type = string
}

variable "storage_pool" {
  type = string
}

variable "nic_method" {
  type    = string
  default = "network"
}

variable "nictype" {
  type    = string
  default = ""
}

variable "nictype_parent" {
  type    = string
  default = ""
}

variable "network_name" {
  type    = string
  default = ""
}

variable "ovn_net_uplink_ipv4_address" {
  type    = string
  default = ""
}

variable "ovn_net_uplink_ipv6_address" {
  type    = string
  default = ""
}
