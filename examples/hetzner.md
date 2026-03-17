# Hetzner
Deploy three nodes on Hetzner, each with at least one additional hard drive
for the Ceph cluster.

We are using a vSwitch setup with five VLANs:
* 4010 - Management (mgmt0)
* 4011 - Overlay (overlay0)
* 4012 - Public (public0)
* 4013 - Storage (storage0)
* 4014 - Storage (storage1)

We will use IPv4 and private networks for predictability.

On Hetzner, an additional network has been ordered and bound to VLAN 4012.
Within Incus, a network named pblc0 will be created (via Ansible).
This is optional and can be skipped - simply comment out the pblc0 network
definition in the inventory.

There are two TODOs to complete on your Hetzner nodes:
1. Hard drive IDs - We cannot know in advance which hard drives should be usedto create the OSDs (mandatory).
2. Network address - The address for the additional public network (optional).

After creating the `hosts.yaml` inventory file, search for "TODO" to locate
these entries.


```
+---------------------------------------------------------------+
|                             incus                             |
+---------------------------------------------------------------+
+------------------------------+ +------------------------------+
|               OVN            | |            CEPH              |
+------------------------------+ +------------------------------+
+---------------------------------------------------------------+
|                      vSwitch (Hetzner)                        |
+---------------------------------------------------------------+
+-------------------+ +-------------------+ +-------------------+
|       node01      | |       node02      | |      node03       |
+-------------------+ +-------------------+ +-------------------+
+---------------------------------------------------------------+
|                            hetzner                            |
+---------------------------------------------------------------+
```

## Nodes
### Install nodes
Boot every node in rescue mode and continue as follows:
```bash
cat > ~/install.conf <<EOF
DRIVE1 /dev/sda
SWRAID 0
SWRAIDLEVEL 6
HOSTNAME me
Ubuntu-2404-noble-amd64-base
USE_KERNEL_MODE_SETTING yes
PART /boot  ext3     1024M
PART /boot/efi esp 256M
PART lvm    system   all
LV system   root   /        xfs          16G
LV system   swap   swap     swap          4G
LV system   home   /home    xfs          64G
LV system   varlog /var/log xfs          16G
LV system   tmp    /tmp     xfs          16G
IMAGE /root/.oldroot/nfs/install/../images/Ubuntu-2404-noble-amd64-base.tar.gz
EOF

# install
installimage -c ~/install.conf -n [HOSTNAME] -d /dev/sda -s en -t yes
```

### Configuration
Apply this configuration to every node.
```bash
##############################################################################
# /etc/hosts
# remove short name aliases, relevant for ceph deployment
sed -i -E "s/(alfi|beni|gabi)$//" /etc/hosts

# add entries for the storage0 (ceph public network)
cat >> /etc/hosts << EOF
172.18.80.32 alfi  alfi.strg0
172.18.80.33 beni  beni.strg0
172.18.80.34 gabi  gabi.strg0
EOF
##############################################################################
# vars
MY_ID=$(
  cat /etc/hosts | grep strg0    | grep "$(hostname -s)" \
    | awk '{print $1}' | awk -F. '{print $4}'
)
MY_NIC=$(ip route | grep default | awk '{print $5}')

##############################################################################
# network
hostnamectl set-hostname $(hostname -s)

# install some packages
apt update
apt install -y openvswitch-common openvswitch-switch python3-openvswitch

cp /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.orig

# enforcing an ipv4-only stack for predictability
sed '/- 2a01:4f8:/d; /- to: default/,/via: fe80::1/d; /- 2a01:4ff:/d' -i  /etc/netplan/01-netcfg.yaml
sed '/ethernets:/!b;n;a \      link-local: [ ]'                       -i  /etc/netplan/01-netcfg.yaml

cat > /etc/netplan/10-vswitch.yaml  <<EOF
---
#
# Bridges and vlan are working independet from main enterface enp7s0 setup (linux ip/ ovs)
#
network:
  bridges:
    mgtm0:
      interfaces: [vlan4010]
      addresses:
        - 172.18.18.$((MY_ID))/24
      dhcp4: false
      dhcp6: false
      link-local: []
      openvswitch: {}
    ovrl0:
      interfaces: [vlan4011]
      addresses:
        - 172.18.10.$((MY_ID))/24
      dhcp4: false
      dhcp6: false
      link-local: []
      openvswitch: {}
    strg0:
      interfaces: [vlan4013]
      addresses:
        - 172.18.80.$((MY_ID))/24
      dhcp4: false
      dhcp6: false
      link-local: []
      openvswitch: {}
    strg1:
      interfaces: [vlan4014]
      addresses:
        - 172.18.81.$((MY_ID))/24
      dhcp4: false
      dhcp6: false
      link-local: []
      openvswitch: {}
  vlans:
    vlan4010:
      id: 4010
      link: $MY_NIC
      mtu: 1400
      dhcp4: false
      dhcp6: false
      link-local: []
    vlan4011:
      id: 4011
      link: $MY_NIC
      mtu: 1400
      dhcp4: false
      dhcp6: false
      link-local: []
    vlan4012:
      id: 4012
      link: $MY_NIC
      mtu: 1400
      dhcp4: false
      dhcp6: false
      link-local: []
    vlan4013:
      id: 4013
      link: $MY_NIC
      mtu: 1400
      dhcp4: false
      dhcp6: false
      link-local: []
    vlan4014:
      id: 4014
      link: $MY_NIC
      mtu: 1400
      dhcp4: false
      dhcp6: false
      link-local: []
EOF
chmod 600 /etc/netplan/10-*
netplan get
netplan apply

##############################################################################
# firewall

cat > /etc/nftables.conf <<EOF
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority filter;
        }
        chain forward {
                type filter hook forward priority filter;
        }
        chain output {
                type filter hook output priority filter;
        }
        chain input {
                type filter hook input priority filter; policy drop;
                iif "lo" accept
                ct state established,related accept
                tcp dport 22 accept
                ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } accept
                drop
        }

    chain output {
        type filter hook output priority filter; policy accept;
    }
}
EOF
systemctl enable nftables
systemctl daemon-reload

##############################################################################
# misc

cat > ~/.ssh/config <<EOF
Host alfi beni gabi *.localdomain
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
EOF

# reboot
reboot
```

## Ansible
Install ansible on one of the nodes (or use an aditional node for incus deployment)
```bash
apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install pyenv
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"'                                >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"'                                          >> ~/.bashrc
source ~/.bashrc

# Install virtualenv with pyenv
pyenv install 3.13.1
pyenv virtualenv 3.13.1 incus_deploy
pyenv activate incus_deploy
pip install -U pip pipenv
source ~/.bashrc

# Clone the repository
git clone https://github.com/lxc/incus-deploy.git
cd incus-deploy/ansible/
# setting to put dependencies within virtual env
sed "/\[defaults\]/a home=\$VIRTUAL_ENV/.ansible" -i ansible.cfg
  
# Install dependencies
pipenv install
ansible-galaxy install -r ansible_requirements.yml
```


## Inventory
Prepare the inventory within incus_deploy repository.
Correct (network address) or comment out pblc0 definition.
```bash
cat > hosts.yaml <<EOF
all:
  children:
    incus_servers:
      children:
        baremetal:
          hosts:
            alfi:
              # TODO: put here disk ids available to create OSDs on
              #       you can run the following command on each node,
              #       to file the suitable candidates:
              #
              #       ls  /dev/disk/by-id/ | grep -i -E "nvme|ssd" | awk '{print "- data: "\$1}'
              #
              ceph_disks:
                - data: [SOME_ID]
                - data: [SOME_ID]
                - data: [SOME_ID]
            beni:
              ceph_disks:
                - data: [SOME_ID]
                - data: [SOME_ID]
                - data: [SOME_ID]
            gabi:
              ceph_disks:
                - data: [SOME_ID]
                - data: [SOME_ID]
                - data: [SOME_ID]
  vars:
    #
    # ansible
    #
    ansible_python_interpreter: auto_silent
    #
    # ceph
    #
    ceph_fsid:             "a075071e-7fb2-4d49-a741-9ab391f2fbad"
    ceph_network_public:   '172.18.80.0/24'
    ceph_network_private:  '172.18.81.0/24'
    ceph_rbd_cache:        "2048Mi"
    ceph_rbd_cache_max:    "1792Mi"
    ceph_rbd_cache_target: "1536Mi"
    ceph_release:          "distro"
    ceph_ip_address:       "{{ansible_strg0['ipv4']['address']}}"
    # NOTE: all nodes will have the same roles in the ceph cluster
    ceph_roles:
      - client
      - mon
      - mds
      - mgr
      - osd
    #
    # OVN
    #
    ovn_name:       bolt
    ovn_release:    distro
    ovn_ip_address: "{{ansible_ovrl0['ipv4']['address']}}"
    ovn_roles:
      - central
      - host
    #
    # incus
    #
    incus_init:
      network:
        #
        # UPLINK network to connect with world outside of the platform
        #
        UPLINK:
          type: bridge
          config:
            bridge.driver:   openvswitch
            bridge.mtu:      1500
            ipv4.address:    172.18.20.1/24
            ipv4.ovn.ranges: 172.18.20.64-172.18.20.127
            ipv4.nat:        true
            ipv4.dhcp:       false
            ipv6.address:    none
          description: "Uplink via infra hosts"
        #
        # Just a network to create first workloads in, connected with UPLINK
        #
        ovn-test:
          type: ovn
          config:
            network:          UPLINK
            ipv4.address:     10.10.10.1/24
            ipv4.nat:         true
            ipv4.dhcp:        true
            ipv4.dhcp.ranges: 10.10.10.64-10.10.10.127
            ipv6.address:     none
            bridge.mtu:       1342 # NOTE: network backed by VLAN with MTU=1400
          description:        "OVN test network"
          default: true
        #
        # Additional public(internet) network can be used to get ips from
        #
        pblc0:
          type: bridge
          config:
            ipv4.dhcp:                  false
            ipv4.address:               116.202.68.154/29
            ipv4.dhcp.ranges:           116.202.68.155-116.202.68.158
            ipv4.nat:                   false
            ipv6.address:               none
            ipv6.nat:                   false
            dns.mode:                   none
            bridge.mtu:                 1400
            bridge.driver:              openvswitch
            bridge.external_interfaces: vlan4012
          description:                  "Hetzner additional network"
      storage:
        octopet:
          driver:              "ceph"
          description:         "Default"
          local_config:
            source:            "bolt"
            ceph.cluster_name: "ceph"
          default: true
    incus_ip_address: "{{ansible_ovrl0['ipv4']['address']}}:18443"
    incus_name:       bolt
    incus_release:    stable
    incus_roles:
      - cluster
      - ui
EOF
```

## Playbook
Prepare the playbook within incus_deploy repository
```bash
mv deploy.yaml deploy.yaml.example
cat > deploy.yaml <<EOF
- hosts: all
  gather_facts: true
  gather_subset:
    - "default_ipv4"
    - "!default_ipv6"
    - "distribution_release"
  pre_tasks:
    - name: Inject inventory ceph_ip_address into the facts dictionary
      set_fact:
        ansible_ceph_ip_address: "{{ ceph_ip_address }}"
  roles:
    - system_settings
    - ceph
    - ovn
    - incus
EOF
```

## Run
Start deployment
```bash
ANSIBLE_ROLES_PATH=../roles ansible-playbook deploy.yaml
```

## Test
After successful deployment we can test the installation with incus client
```bash
# list nodes in cluster
incus cluster ls

# list networks
incus network ls

# list storage
incus storage ls

# create a new instance in in default (ovn-test) network
incus launch images:ubuntu/24.04 test01 --vm  -c limits.cpu=1   -c limits.memory=4GiB

# test connectivity
incus exec test01 -- ping -c3 8.8.8.8

# install tools
incus exec test01 -- apt update
incus exec test01 -- apt install -y curl tcpdump arping net-tools

# test
incus exec test01 -- curl ifconfig.io
```
