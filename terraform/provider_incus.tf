provider "incus" {
  # Incus client library looks in ~/.config/incus for client.crt and client.key for authentication
  generate_client_certificates = true
  accept_remote_certificate    = true

  remote {
    name    = var.incus_host_name
    scheme  = var.incus_host_scheme
    address = var.incus_host_address
    port    = var.incus_host_port
    default = var.incus_host_default
  }
}
