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

### Create the test VMs with OpenTofu
Go to terraform directory:
```
cd test/terraform/
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
Go back to the root directory:
```
cd ../../
```

Run the Playbook with the test inventory:
```
ansible-playbook -i test/inventory/ deploy.yaml
```

NOTE: When re-deploying the same cluster (e.g. following a `terraform
destroy`), you need to make sure to also clear any local state from the
`data` directory, failure to do so will cause Ceph/OVN to attempt
connection to the previously deployed systems which will cause the
deployment to get stuck.

## Deploying against production systems
### Requirements (when using Incus with both Ceph and OVN)

 - At least 3 servers
 - One main network interface (or bond/VLAN), referred to as `enp5s0` in the examples
 - One additional network interface (or bond/VLAN) to use for ingress into OVN, referred to as `enp6s0` in the examples
 - Configured IPv4/IPv6 subnets on that additional network interface, in the examples, we're using:
   - IPv4 subnet: `172.31.254.0/24`
   - IPv4 gaterway: `172.31.254.1`
   - IPv6 subnet: `fd00:1e4d:637d:1234::/64`
   - IPv6 gateway: `fd00:1e4d:637d:1234::1`
   - DNS server: `1.1.1.1`
 - A minimum of 3 disks (or partitions) on distinct servers across the cluster for consumption by Ceph, in the examples, we're using (on each server):
   - `nvme-QEMU_NVMe_Ctrl_incus_disk1`
   - `nvme-QEMU_NVMe_Ctrl_incus_disk2`
 - A minimum of 1 disk (or partition) on each server for local storage, that's `/dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_incus_disk3` in the examples

### Configuring Ansible

With a deployment against physical servers, Terraform isn't currently used at all.
Ansible will be used to deploy Ceph, OVN and Incus on the servers.

You'll need to create a new `hosts.yaml` which you can base on the example one provided.

You'll then need to do the following changes at minimum:
 - Generate a new `ceph_fsid` (use `uuidgen`)
 - Set a new `incus_name`
 - Set a new `ovn_name`
 - Update the number and name of servers to match the FQDN of your machines
 - Ensure that you have 3 servers with the `mon` `ceph_role` and 3 servers with the `central` `ovn_role`
 - Update the connection details to fit your deployment:
   - Unset `ansible_connection`, `ansible_incus_remote`, `ansible_user` and `ansible_become` as those are specific to our test environment
   - Set the appropriate connection information to access your servers (`ansible_connection`, `ansible_user`, SSH key, ...)
 - Update the list of ceph and local disks for each servers (look at `/dev/disk/by-id` for identifiers)
 - Tweak the `incus_init` variable to match your environment

You'll find more details about the Ansible configuration options in [ansible/README.md](ansible/README.md).
