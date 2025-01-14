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

variable "network" {
  type = string
}

variable "ovn_uplink_ipv4_address" {
  type    = string
  default = ""
}

variable "ovn_uplink_ipv6_address" {
  type    = string
  default = ""
}
