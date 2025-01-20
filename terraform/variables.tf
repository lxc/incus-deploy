variable "incus_remote" {
  type    = string
  default = "local"
}

variable "incus_image" {
  type    = string
  default = "ubuntu/22.04"
}

variable "incus_storage_pool" {
  type    = string
  default = "default"
}

variable "incus_network" {
  type    = string
  default = "incusbr0"
}

variable "ovn_uplink_ipv4_address" {
  type    = string
  default = "172.31.254.1/24"
}

variable "ovn_uplink_ipv6_address" {
  type    = string
  default = "fd00:1e4d:637d:1234::1/64"
}
