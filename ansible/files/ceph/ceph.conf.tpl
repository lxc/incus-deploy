{% set addresses = task_ceph_monitors | map(attribute='ip') | map('regex_replace', '^(.*)$', '[\\1]:6789') | join(',') -%}
{% set names = task_ceph_monitors | map(attribute='name') | join(',') -%}
# Managed by Ansible, do not modify.
[global]
fsid = {{ task_ceph_fsid }}
mon_initial_members = {{ names }}
mon_host = {{ addresses }}
{% if task_ceph_public_network %}
public_network = {{ task_ceph_public_network }}
{% endif %}
{% if task_ceph_private_network %}
private_network = {{ task_ceph_private_network }}
{% endif %}

[client]
rbd_cache = true
rbd_cache_size = {{ task_ceph_rbd_cache }}
rbd_cache_writethrough_until_flush = false
rbd_cache_max_dirty = {{ task_ceph_rbd_cache_max }}
rbd_cache_target_dirty = {{ task_ceph_rbd_cache_target }}
