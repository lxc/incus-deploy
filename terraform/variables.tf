variable "incus_host_name" {
  type    = string
  default = "incus"
}
variable "incus_host_scheme" {
  type    = string
  default = "https"
}
variable "incus_host_address" {
  type    = string
  default = "127.0.0.1"
}
variable "incus_host_port" {
  type    = number
  default = 443
}
variable "incus_host_default" {
  type    = bool
  default = true
}



variable "incus_storage_pool" {
  type    = string
  default = "default"
}
variable "incus_nic_method" {
  type    = string
  default = "network"
  validation {
    condition     = contains(["network", "nictype"], var.incus_nic_method)
    error_message = "Valid value is one of the following: network, nictype."
  }
}
variable "incus_network_name" {
  description = "optional: only used with incus_nic_method set to network"
  type        = string
  default     = "incusbr0"
}
variable "incus_nictype" {
  description = "optional: only used with incus_nic_method set to nictype"
  type        = string
  default     = "bridged"
}
variable "incus_nictype_parent" {
  description = "optional: only used with incus_nic_method set to nictype"
  type        = string
  default     = "incusbr0"
}



variable "baremetal_net_ipv4_address" {
  type    = string
  default = "172.31.254.1/24"
}
variable "baremetal_net_ipv6_address" {
  type    = string
  default = "fd00:1e4d:637d:1234::1/64"
}
