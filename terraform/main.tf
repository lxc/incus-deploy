module "baremetal" {
  source = "./baremetal-incus"

  project_name   = "dev-incus-deploy"
  instance_names = ["server01", "server02", "server03", "server04", "server05"]
  image          = "images:ubuntu/22.04"
  memory         = "4GiB"

  storage_pool = var.incus_storage_pool

  nic_method = var.incus_nic_method
  # network settings
  network_name = var.incus_network_name
  # nictype settings
  nictype        = var.incus_nictype
  nictype_parent = var.incus_nictype_parent

  ovn_net_uplink_ipv4_address = var.baremetal_net_ipv4_address
  ovn_net_uplink_ipv6_address = var.baremetal_net_ipv6_address
}

module "services" {
  source = "./services"

  project_name   = "dev-incus-deploy-services"
  instance_names = ["ceph-mds01", "ceph-mds02", "ceph-mds03", "ceph-mgr01", "ceph-mgr02", "ceph-mgr03", "ceph-rgw01", "ceph-rgw02", "ceph-rgw03"]
  image          = "images:ubuntu/24.04"
  storage_pool   = var.incus_storage_pool

  nic_method = var.incus_nic_method
  # network settings
  network_name = var.incus_network_name
  # nictype settings
  nictype        = var.incus_nictype
  nictype_parent = var.incus_nictype_parent
}
