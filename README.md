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
