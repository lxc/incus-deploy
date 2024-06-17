# Managed by Ansible, do not modify.

# Cluster is {{ task_name }}

global {
	use_lvmlockd = 1
}

local {
	host_id = {{ task_host_ids[inventory_hostname] }}
}
