# Incus deployment tools

This is a collection of Ansible playbooks, Terraform configurations and scripts to deploy and operate Incus clusters.

## How to get the test setup run:

Install incus stable or LTS on your system from the [zabbly/incus](https://github.com/zabbly/incus) release and initialize it on your local machine.

Install [OpenTofu](https://opentofu.org/docs/intro/install/).

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
