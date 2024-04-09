{% for host in vars['play_hosts'] %}
{% if hostvars[host]['ceph_fsid'] == task_fsid and "mon" in hostvars[host]['ceph_roles'] %}
- "{{ host }}"
{% endif %}
{% endfor %}
