# Managed by Ansible, do not modify.
Types: deb
URIs: https://download.ceph.com/debian-{{ task_release }}
Suites: {{ ansible_distribution_release }}
Components: main
Architectures: {{ dpkg_architecture.stdout }}
Signed-By: /etc/apt/keyrings/ansible-ceph.asc
