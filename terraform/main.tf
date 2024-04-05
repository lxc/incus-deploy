module "baremetal" {
  source = "./baremetal-incus"

  project_name   = "dev-incus-deploy"
  instance_names = ["server01", "server02", "server03", "server04", "server05"]
  image          = "images:ubuntu/22.04"
  memory         = "4GiB"
  storage_pool   = "default"
}

module "services" {
  source = "./services"

  project_name   = "dev-incus-deploy-services"
  instance_names = ["ceph-mds01", "ceph-mds02", "ceph-mds03", "ceph-mgr01", "ceph-mgr02", "ceph-mgr03", "ceph-rgw01", "ceph-rgw02", "ceph-rgw03"]
  image          = "images:ubuntu/22.04"
  storage_pool   = "default"
}
