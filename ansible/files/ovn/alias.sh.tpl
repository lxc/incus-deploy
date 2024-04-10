# Managed by Ansible, do not modify.
alias ovn-nbctl="/usr/bin/ovn-nbctl --db={{ task_central_northbound }} -c /etc/ovn/{{ task_name }}.server.crt -p /etc/ovn/{{ task_name }}.server.key -C /etc/ovn/{{ task_name }}.ca.crt"
alias ovn-sbctl="/usr/bin/ovn-sbctl --db={{ task_central_southbound }} -c /etc/ovn/{{ task_name }}.server.crt -p /etc/ovn/{{ task_name }}.server.key -C /etc/ovn/{{ task_name }}.ca.crt"
{% if task_ic_northbound %}
alias ovn-ic-nbctl="/usr/bin/ovn-ic-nbctl --db={{ task_ic_northbound }} -c /etc/ovn/{{ task_name }}.server.crt -p /etc/ovn/{{ task_name }}.server.key -C /etc/ovn/{{ task_name }}.ca.crt"
{% endif %}
{% if task_ic_southbound %}
alias ovn-ic-sbctl="/usr/bin/ovn-ic-sbctl --db={{ task_ic_southbound }} -c /etc/ovn/{{ task_name }}.server.crt -p /etc/ovn/{{ task_name }}.server.key -C /etc/ovn/{{ task_name }}.ca.crt"
{% endif %}
