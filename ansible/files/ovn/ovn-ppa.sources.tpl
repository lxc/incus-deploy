# Managed by Ansible, do not modify.
Types: deb
URIs: https://ppa.launchpadcontent.net/stgraber/ovn-stable/ubuntu
Suites: {{ ansible_distribution_release }}
Components: main
Architectures: {{ dpkg_architecture.stdout }}
Signed-By: /etc/apt/keyrings/ansible-ovn-ppa.asc
