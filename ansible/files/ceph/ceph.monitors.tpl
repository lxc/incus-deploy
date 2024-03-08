{% for host in groups['ceph'] %}
{% if hostvars[host]['ceph_fsid'] == task_ceph_fsid and "mon" in hostvars[host]['ceph_roles'] %}
- name: "{{ host }}"
  ip: "{{ hostvars[host]['ip_internal'] }}"
{% endif %}
{% endfor %}
