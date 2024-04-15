{% set monitors = lookup('template', '../files/ceph/ceph.monitors.tpl') | from_yaml | default([]) %}
{% set addresses = monitors | map(attribute='ip') | map('regex_replace', '^(.*)$', '[\\1]:6789') | sort | join(',') -%}
{% set names = monitors | map(attribute='name') | sort | join(',') -%}
# Managed by Ansible, do not modify.
[global]
fsid = {{ task_fsid }}
mon_initial_members = {{ names }}
mon_host = {{ addresses }}
{% if task_network_public %}
public_network = {{ task_network_public }}
{% endif %}
{% if task_network_private %}
private_network = {{ task_network_private }}
{% endif %}
auth allow insecure global id reclaim = false
{% if ansible_default_ipv6['address'] | default("") %}
ms bind ipv6 = true
ms bind ipv4 = false
{% else %}
ms bind ipv6 = false
ms bind ipv4 = true
{% endif %}

[client]
rbd_cache = true
rbd_cache_size = {{ task_rbd_cache }}
rbd_cache_writethrough_until_flush = false
rbd_cache_max_dirty = {{ task_rbd_cache_max }}
rbd_cache_target_dirty = {{ task_rbd_cache_target }}
