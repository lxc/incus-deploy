# Variables
## Ceph

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

## Incus
 - `incus_name`: Name identifier for the deployment (**required**, type: string)
 - `incus_init`: Initial configuration data (type: dict)
   - `network`: Dict of networks
     - `name`: Name of the network (**required**, type: string)
     - `type`: Type of network (**required**, type: string)
     - `default`: Whether to include in the default profile (type: bool, default: False)
     - `config`: Dict of global config keys
     - `local_config`: Dict of server-specific config keys
   - `storage`: Dict of storage pools
     - `name`: Name of the storage pool (**required**, type: string)
     - `driver`: Storage pool driver (**required**, type: string)
     - `default`: Whether to include in the default profile (type: bool, default: False)
     - `config`: Dict of global config keys
     - `local_config`: Dict of server-specific config keys
 - `incus_ip_address`: Override for the server's IP address (used cluster and client traffic) (type: string)
 - `incus_release`: Incus release to deploy, can be one of `daily`, `stable` or `lts-6.0` (type: string, default: `stable`)
 - `incus_roles`: Operation mode for the deployed Incus system (**required**, type: string)
   - `standalone`
   - `cluster`
   - `ui`: Whether to serve the Incus UI

## LVM cluster
 - `lvmcluster_metadata_size`: PV metadata size (default to 10MB)
 - `lvmcluster_name`: Name identifier for the deployment (**required**, type: string)
 - `lvmcluster_vgs`: Dict of VG name to storage device path

## OVN

 - `ovn_az_name`: OVN availability zone name (**required** if using OVN IC, type: string)
 - `ovn_clients`: List of certificates to generate for OVN clients (type: list of string)
 - `ovn_ip_address`: Override for the server's IP address (used for tunnels and DB traffic) (type: string)
 - `ovn_name`: OVN deployment name (**required**, type: string)
 - `ovn_release`: OVN release to deploy, can be `distro` or `ppa` (type: string, default: `distro`)
 - `ovn_roles`: List of roles the server should have in the OVN cluster (**required**, type: list of string):
   - `central`: OVN API server, runs NorthBound and SouthBound database and northd daemon
   - `host`: OVN client / controller, runs OpenVswitch and ovn-controller
   - `ic`: OVN Inter-Connection server, runs the `ovn-ic` daemon
   - `ic-db`: OVN Inter-Connection NorthBound and SouthBound database server
   - `ic-gateway`: OVN Inter-Connection traffic gateway
