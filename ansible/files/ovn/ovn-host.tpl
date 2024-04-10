# Managed by Ansible, do not modify.

# This is a POSIX shell fragment                -*- sh -*-

# OVN_CTL_OPTS: Extra options to pass to ovs-ctl.  This is, for example,
# a suitable place to specify --ovn-controller-wrapper=valgrind.
OVN_CTL_OPTS="\
    --ovn-controller-ssl-key=/etc/ovn/{{ task_name }}.server.key \
    --ovn-controller-ssl-cert=/etc/ovn/{{ task_name }}.server.crt \
    --ovn-controller-ssl-ca-cert=/etc/ovn/{{ task_name }}.ca.crt"
