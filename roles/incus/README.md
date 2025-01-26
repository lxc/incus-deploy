# Incus Role
## Variables
 - `incus_name`: Name identifier for the deployment (**required**, type: string)
 - `incus_init`: Initial configuration data (type: dict)
   - `config`: Dict of config keys
   - `clients`: Dict of client certificates to trust
     - `type`: Type of certificate, typically `client` or `metrics` (**required**, type: string)
     - `certificate`: PEM encoded certificate (**required**, type: string)
   - `network`: Dict of networks
     - `name`: Name of the network (**required**, type: string)
     - `type`: Type of network (**required**, type: string)
     - `default`: Whether to include in the default profile (type: bool, default: False)
     - `config`: Dict of global config keys
     - `local_config`: Dict of server-specific config keys
   - `storage`: Dict of storage pools
     - `name`: Name of the storage pool (**required**, type: string)
     - `driver`: Storage pool driver (**required**, type: string)
     - `default`: Whether to include in the default profile (type: bool, default: False)
     - `config`: Dict of global config keys
     - `local_config`: Dict of server-specific config keys
 - `incus_ip_address`: Override for the server's IP address (used cluster and client traffic) (type: string)
 - `incus_release`: Incus release to deploy, can be one of `daily`, `stable` or `lts-6.0` (type: string, default: `stable`)
 - `incus_roles`: Operation mode for the deployed Incus system (**required**, type: string)
   - `standalone`
   - `cluster`
   - `ui`: Whether to serve the Incus UI

