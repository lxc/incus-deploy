variable "project_name" {
  type = string
}

variable "instance_names" {
  type = set(string)
}

variable "image" {
  type = string
}

variable "storage_pool" {
  type = string
}

variable "nic_method" {
  type    = string
  default = "network"
  validation {
    condition     = contains(["network", "nictype"], var.nic_method)
    error_message = "Valid value is one of the following: network, nictype."
  }
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
