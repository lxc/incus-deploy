# Managed by Ansible, do not modify.
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/incus/{{ task_release }}/
Suites: {{ ansible_distribution_release }}
Components: main
Architectures: {{ dpkg_architecture.stdout }}
Signed-By: /etc/apt/keyrings/ansible-zabbly.asc