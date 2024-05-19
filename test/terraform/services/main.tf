resource "incus_project" "this" {
  name        = var.project_name
  description = "Project used to test incus-deploy services"
  config = {
    "features.images"          = false
    "features.networks"        = false
    "features.networks.zones"  = false
    "features.profiles"        = true
    "features.storage.buckets" = true
    "features.storage.volumes" = true
  }
}

resource "incus_profile" "this" {
  project     = incus_project.this.name
  name        = "services"
  description = "Profile to be used by the service containers"

  config = {
    "limits.cpu"       = "1"
    "limits.memory"    = "1GiB"
    "limits.processes" = "1000"
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      "pool" = var.storage_pool
      "path" = "/"
    }
  }

  device {
    type = "nic"
    name = "eth0"

    properties = {
      "network" = "incusbr0"
      "name"    = "eth0"
    }
  }
}

resource "incus_instance" "instances" {
  for_each = var.instance_names

  project  = incus_project.this.name
  name     = each.value
  type     = "container"
  image    = var.image
  profiles = ["default", incus_profile.this.name]

  lifecycle {
    ignore_changes = [ running ]
  }
}
