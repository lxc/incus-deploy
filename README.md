# Incus deployment tools

This is a collection of Ansible playbooks, Terraform configurations and scripts to deploy and operate Incus clusters.

## How to get the test setup run:

### Install incus and OpenTofu
Install incus stable or LTS on your system from the [zabbly/incus](https://github.com/zabbly/incus) release and initialize it on your local machine.

Install [OpenTofu](https://opentofu.org/docs/intro/install/).

Install the required ceph packages for ansible on the controller, on Debian that's the `ceph-base` and `ceph-common` packages:
```
apt install --no-install-recommends ceph-base ceph-common
```
Version required : reef

Install instructions : [Ceph Doc](https://docs.ceph.com/en/latest/install/get-packages/)


### Create the test VMs with OpenTofu
Go to terraform directory:
```
cd terraform/
```

Init the terraform project:
```
tofu init
```

Create the VMs for testing:
```
tofu apply
```

### Run the Ansible Playbook
Go to the ansible directory:
```
cd ../ansible/
```

Copy the example inventory file:
```
cp hosts.yaml.example hosts.yaml
```

Run the Playbooks:
```
ansible-playbook deploy.yaml
```

## How to use in prod, for newbees : 

### Out of the box, ansible look for : 

A local ethernet interface on each server, laying in the same network : enp5s0
A local ethernet interface on each server, laying on a different subnet, with DHCP, configured as follow : 

  - ip : 172.31.254.0/24
  - gw4 : 172.31.254.1/24
  - gw6 : fd00:1e4d:637d:1234::1/64
  - dns : 1.1.1.1

Two local empty disks on each server for ceph storage : 

  - nvme-QEMU_NVMe_Ctrl_incus_disk1
  - nvme-QEMU_NVMe_Ctrl_incus_disk2

An empty disk on each server, for 'local storage' : 

  - /dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_incus_disk3

One can edit hosts.yaml.example to fit his needs : 

First of all, use uuidgen to generate a unique UUID for your deployment, and remplace it in hosts.yaml.

  ### Baremetal vars : 

  - ansible_connection: incus
Probably needs to be changed, as you're not going to interact with your servers the same way you do with local VMs.
(typical value : ansible_connection: ssh)

  - ansible_incus_remote: local
As you're probably using SSH to log into your servers, not Incus, and therefore not using "connector" incus.py, you should comment this setting.

  - ansible_user: root
Depending on your setup, you should consider changing this.

  - ansible_become: no
Depending on your setup, could be 'true', and will default to "sudo" privilege escalation.

  ### incus_init vars :

  -  network: LOCAL: parent: enp5s0 / network: UPLINK: parent: enp6s0
Must be changed to fit, two interfaces of each of your servers. Else you are using the same hardware, and, it's an easy task, else you don't and would probably prefer to move the whole "incus_init" part to the server "own" vars.

  - network: ipv4.gateway: "172.31.254.1/24" / ipv6.gateway: "fd00:1e4d:637d:1234::1/64" / ipv4.ovn.ranges: "172.31.254.10-172.31.254.254" / dns.nameservers: "1.1.1.1,1.0.0.1"
Might be changed to fit your network plugged on 'enp6s0/eth2' network card. DHCP Must be running on network.

  - storage: local: driver: zfs
Used to define "local" storage pool on target servers, driver can be changed if needed.

  - storage: local: local_config: source: "/dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_incus_disk3"
Used to define source for local storage pool. Can be either a drive, or a directory.

  ### hosts vars : 

  - hosts: server01:
Can be changed, to match FQDN of the actual server, or one can add the address of each server as : ansible_host: <ip address>.
Server names can also be changed to their IP, but, it's annoying when you're on an IPv6 stack ;-)

  -  ceph_disks: data: nvme-QEMU_NVMe_Ctrl_incus_disk1 / ceph_disks: data: nvme-QEMU_NVMe_Ctrl_incus_disk2
Must be changed to match hardware drives. To avoid problems, it is suggested to use their name, as seen in /dev/disk/by-id/.
