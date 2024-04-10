{% set servers = lookup('template', '../files/ovn/ovn-ic.servers.tpl') | from_yaml -%}
# Managed by Ansible, do not modify.

# This is a POSIX shell fragment                -*- sh -*-

# OVN_CTL_OPTS: Extra options to pass to ovs-ctl.  This is, for example,
# a suitable place to specify --ovn-northd-wrapper=valgrind.

OVN_CTL_OPTS="\
    --db-ic-nb-create-insecure-remote=no \
    --db-ic-sb-create-insecure-remote=no \
    --db-ic-nb-addr=[{{ task_ip_address }}] \
    --db-ic-sb-addr=[{{ task_ip_address }}] \
    --db-ic-nb-cluster-local-addr=[{{ task_ip_address }}] \
    --db-ic-sb-cluster-local-addr=[{{ task_ip_address }}] \
    --ovn-ic-ssl-key=/etc/ovn/{{ task_name }}.server.key \
    --ovn-ic-ssl-cert=/etc/ovn/{{ task_name }}.server.crt \
    --ovn-ic-ssl-ca-cert=/etc/ovn/{{ task_name }}.ca.crt \
    --ovn-northd-nb-db={{ task_central_northbound }} \
    --ovn-northd-sb-db={{ task_central_southbound }} \
    --ovn-ic-nb-db={{ task_ic_northbound }} \
    --ovn-ic-sb-db={{ task_ic_southbound }}{% if task_ip_address != servers[0] %} \
    --db-ic-nb-cluster-remote-addr=[{{ servers[0] }}]
    --db-ic-sb-cluster-remote-addr=[{{ servers[0] }}]{% endif %}"
