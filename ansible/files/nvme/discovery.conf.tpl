# Managed by Ansible, do not modify.

# Used for extracting default parameters for discovery
#
# Example:
# --transport=<trtype> --traddr=<traddr> --trsvcid=<trsvcid> --host-traddr=<host-traddr> --host-iface=<host-iface>
{% for target in task_targets %}
--transport=tcp --traddr={{ target }}
{% endfor %}
