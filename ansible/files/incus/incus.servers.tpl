{% for host in vars['play_hosts'] | sort %}
{% if hostvars[host]['incus_name'] == task_name and "cluster" in hostvars[host]['incus_roles'] %}
- {{ host }}
{% endif %}
{% endfor %}
