## Variables

 - `ovn_ip_address`: Override for the server's IP address (used for tunnels and DB traffic) (type: string)
 - `ovn_az_name`: OVN availability zone name (**required** if using OVN IC, type: string)
 - `ovn_name`: OVN deployment name (**required**, type: string)
 - `ovn_release`: OVN release to deploy, can be `distro` or `ppa` (type: string, default: `distro`)
 - `ovn_roles`: List of roles the server should have in the OVN cluster (**required**, type: list of string):
   - `central`: OVN API server, runs NorthBound and SouthBound database and northd daemon
   - `host`: OVN client / controller, runs OpenVswitch and ovn-controller
   - `ic`: OVN Inter-Connection server, runs the `ovn-ic` daemon
   - `ic-db`: OVN Inter-Connection NorthBound and SouthBound database server
   - `ic-gateway`: OVN Inter-Connection traffic gateway
