{% set servers = lookup('template', '../files/ovn/ovn-central.servers.tpl') | from_yaml -%}
# Managed by Ansible, do not modify.

# This is a POSIX shell fragment                -*- sh -*-

# OVN_CTL_OPTS: Extra options to pass to ovs-ctl.  This is, for example,
# a suitable place to specify --ovn-northd-wrapper=valgrind.

OVN_CTL_OPTS="\
    --db-nb-create-insecure-remote=no \
    --db-sb-create-insecure-remote=no \
    --db-nb-addr=[{{ task_ip_address }}] \
    --db-sb-addr=[{{ task_ip_address }}] \
    --db-nb-cluster-local-addr=[{{ task_ip_address }}] \
    --db-sb-cluster-local-addr=[{{ task_ip_address }}] \
    --ovn-northd-ssl-key=/etc/ovn/{{ task_name }}.server.key \
    --ovn-northd-ssl-cert=/etc/ovn/{{ task_name }}.server.crt \
    --ovn-northd-ssl-ca-cert=/etc/ovn/{{ task_name }}.ca.crt \
    --ovn-northd-nb-db={{ task_central_northbound }} \
    --ovn-northd-sb-db={{ task_central_southbound }}{% if task_ip_address != servers[0] %} \
    --db-nb-cluster-remote-addr=[{{ servers[0] }}] \
    --db-sb-cluster-remote-addr=[{{ servers[0] }}]{% endif %}"
