{% for host in vars['play_hosts'] | sort %}
{% if hostvars[host]['ovn_name'] == task_name and "central" in hostvars[host]['ovn_roles'] %}
- "{{ hostvars[host]['ovn_ip_address'] | default(hostvars[host]['ansible_default_ipv6']['address'] | default(hostvars[host]['ansible_default_ipv4']['address'])) }}"
{% endif %}
{% endfor %}
