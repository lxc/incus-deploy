resource "incus_project" "this" {
  name        = "baremetal"
  description = "Project used to test incus-deploy"
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
  name        = "cluster"
  description = "Profile to be used by the cluster VMs"

  config = {
    "limits.cpu"    = 4
    "limits.memory" = var.memory
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

  device {
    type = "disk"
    name = "disk4"

    properties = {
      "pool"   = var.storage_pool
      "io.bus" = "nvme"
      "source" = incus_volume.disk4.name
    }
  }
}

resource "incus_volume" "disk1" {
  for_each = var.instance_names

  project      = incus_project.this.name
  name         = "${each.value}-disk1"
  description  = "First CEPH OSD drive"
  pool         = var.storage_pool
  content_type = "block"
  config = {
    "size" = "20GiB"
  }
}

resource "incus_volume" "disk2" {
  for_each = var.instance_names

  project      = incus_project.this.name
  name         = "${each.value}-disk2"
  description  = "Second CEPH OSD drive"
  pool         = var.storage_pool
  content_type = "block"
  config = {
    "size" = "20GiB"
  }
}

resource "incus_volume" "disk3" {
  for_each = var.instance_names

  project      = incus_project.this.name
  name         = "${each.value}-disk3"
  description  = "Local storage drive"
  pool         = var.storage_pool
  content_type = "block"
  config = {
    "size" = "50GiB"
  }
}

resource "incus_volume" "disk4" {
  project      = incus_project.this.name
  name         = "shared-disk"
  description  = "Shared block storage"
  pool         = var.storage_pool
  content_type = "block"
  config = {
    "size" = "50GiB"
    "security.shared" = "true"
  }
}
resource "incus_instance" "instances" {
  for_each = var.instance_names

  project  = incus_project.this.name
  name     = each.value
  type     = "virtual-machine"
  image    = var.image
  profiles = ["default", incus_profile.this.name]

  device {
    type = "disk"
    name = "disk1"

    properties = {
      "pool"   = var.storage_pool
      "io.bus" = "nvme"
      "source" = incus_volume.disk1[each.key].name
    }
  }

  device {
    type = "disk"
    name = "disk2"

    properties = {
      "pool"   = var.storage_pool
      "io.bus" = "nvme"
      "source" = incus_volume.disk2[each.key].name
    }
  }

  device {
    type = "disk"
    name = "disk3"

    properties = {
      "pool"   = var.storage_pool
      "io.bus" = "nvme"
      "source" = incus_volume.disk3[each.key].name
    }
  }

  lifecycle {
    ignore_changes = [ running ]
  }
}
