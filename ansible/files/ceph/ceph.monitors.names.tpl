{%- set found = namespace(count=0) %}
{%- for host in vars['ansible_play_hosts'] %}
{% if 'ceph_fsid' in hostvars[host] and hostvars[host]['ceph_fsid'] == task_fsid and 'ceph_roles' in hostvars[host] and "mon" in hostvars[host]['ceph_roles'] %}
{% set found.count = found.count + 1 %}
- "{{ host }}"
{% endif %}
{% endfor %}
{%- if found.count == 0 %}
[]
{%- endif %}
