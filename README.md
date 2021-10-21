# TinyKloud

This project allow to create a little k3s cluster on proxmox with some additional features.

## Requirements

Python3 and python-pip are required packages for installation. You can install python required packages using this command line:

```bash
pip3 install -r requirements.txt
```

## Installation

Configure you `host` file with pve the node of your proxmox cluster: 

```
[vms]
master1  ansible_host=192.168.0.1    pve=pve1   template=9001
slave1   ansible_host=192.168.0.2    pve=pve2   template=9002
slave2   ansible_host=182.168.0.3    pve=pve3   template=9003

[master]
master1

[node]
slave1
slave2

[k3s_cluster:children]
master
node
```

You aso need to defined some group vars:
```yaml
proxmox_user: root@pam
proxmox_password: STRONG_PASSWORD
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

