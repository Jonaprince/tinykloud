# TinyKloud

This project allow to create a little k3s cluster on proxmox with some additional features.

## Requirements

Python3 and python-pip are required packages for installation. You can install python required packages using this command line:

```bash
pip3 install -r requirements.txt
```

## Installation

Configure you `host` file with pve the node of your proxmox cluster: 

```ini
[pve]
pve1.domain ansible_user=root template=8001
pve2.domain ansible_user=root template=8002
pve3.domain ansible_user=root template=8003

[vms:children]
master1  ansible_host=192.168.0.1    pve=pve1   template=8001
slave1   ansible_host=192.168.0.2    pve=pve2   template=8002
slave2   ansible_host=192.168.0.3    pve=pve3   template=8003

[master]
master1  ansible_host=192.168.0.1    pve=pve1   template=8001

[node]
slave1   ansible_host=192.168.0.2    pve=pve2   template=8002
slave2   ansible_host=192.168.0.3    pve=pve3   template=8003

[k3s_cluster:children]
master
node
```

You aso need to defined some group vars:
```yaml
proxmox_user: root@pam
proxmox_password: STRONG_PASSWORD

# Configure with your network configuration
gateway: "192.168.1.1"
cidr: "/24"
sshkeys: "YOUR PUBLIC KEY"
```

Deploy using this command line:

```bash
ansible-playbook -i <path to your inventory> deploy.yml
```

## Cleanup

To cleanup all Vms run command line below:

```bash
ansible-playbook -i <path to your inventory> destroy.yml
```

