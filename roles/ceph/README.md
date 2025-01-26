# Ceph Role
## Variables

 - `ceph_disks`: List of disks to disks to include in the Ceph cluster (type: object)
   - `data`: Path to the disk, recommended to be a /dev/disk/by-id/ path (type: string)
   - `db`: Path to a disk or partition to use for the RocksDB database, recommended to be a /dev/disk/by-id/ path (type: string)
 - `ceph_fsid`: UUID of the Ceph cluster (use `uuidgen` or similar to generate) (**required**, type: string)
 - `ceph_ip_address`: Override for the server's IP address (used to generate ceph.conf) (type: string)
 - `ceph_keyrings`: List of keyrings to deploy on the system (type: list of string, default: ["client"])
 - `ceph_network_private`: CIDR subnet of the backend network (type: string)
 - `ceph_network_public`: CIDR subnet of the consumer facing network (type: string)
 - `ceph_rbd_cache`: Amount of memory for caching of librbd client requests (type: string)
 - `ceph_rbd_cache_max`: Maximum amount of memory to be used for librbd client request caching (type: string)
 - `ceph_rbd_cache_target`: Ideal amount of memory used for librbd client request caching (type: string)
 - `ceph_release`: Ceph release to deploy, can be `distro` to use distribution version (type: string, default: `reef`)
 - `ceph_roles`: List of roles the server should have in the Ceph cluster (**required**, type: list of string):
   - `client`: Ceph client, gets ceph.conf and keyring
   - `mds`: Ceph Metadata Server, used for exporting distributed filesystems (CephFS)
   - `mgr`: Ceph Manager server, used to process background management tasks and services
   - `mon`: Ceph Monitor server, provides the core Ceph API used by all other services
   - `osd`: Ceph Object Storage Daemon, used to export disks to the cluster
   - `rbd-mirror`: Ceph Rados Block Device mirroring server, used for cross-cluster replication
   - `rgw`: A RADOS (object) Gateway, used to expose an S3 API on top of Ceph objects

