{% for host in vars['ansible_play_hosts'] | sort %}
{% if hostvars[host]['ovn_name'] == ovn_name | default('') and hostvars[host]['ovn_az_name'] | default('') == ovn_az_name | default('') and "central" in hostvars[host]['ovn_roles'] %}
- "{{ hostvars[host]['ovn_ip_address'] | default(hostvars[host]['ansible_default_ipv6']['address'] | default(hostvars[host]['ansible_default_ipv4']['address'])) }}"
{% endif %}
{% endfor %}
