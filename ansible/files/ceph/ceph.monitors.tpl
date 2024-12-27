{% for host in groups['all'] %}
{% if hostvars[host]['ceph_fsid'] == task_fsid and "mon" in hostvars[host]['ceph_roles'] %}
- name: "{{ host }}"
  ip: "{{ hostvars[host]['ceph_ip_address'] | default(hostvars[host]['ansible_default_ipv6']['address'] | default(hostvars[host]['ansible_default_ipv4']['address'])) }}"
{% endif %}
{% endfor %}
