system_settings
===============

Set appropriate system settings for Incus as described in
the [Server > System settings](https://linuxcontainers.org/incus/docs/main/reference/server_settings/)
section of the documentation.

Requirements
------------

This role only executes on Linux Systems. It is tested on Debian 12, Ubuntu 20.04, 22.04, 24.04 and
CentOS 9.

Role Variables
--------------

This role does not rely on any variable for now.

Dependencies
------------

This role requires the `ansible.posix` and `community.general` collections to be installed. They should
be installed automatically with the collection. It does not require any other role.

Example Playbook
----------------

To use the role, add the following line to your playbook:

    - hosts: servers
      roles:
        - role: lxc.incus.system_settings

License
-------

Apache-2.0
