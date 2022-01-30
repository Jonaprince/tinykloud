terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.6.7"
    }
  }
}


provider "proxmox" {
    pm_api_url = "https://pve1.metal.ig2h:8006/api2/json"
    pm_debug = true
}

variable "pve_names" {
  type    = list(string)
  default = ["pve1","pve"]
}

variable "master_ips" {
  type    = list(string)
  default = ["192.168.1.100","192.168.1.101"]
}

variable "master_names" {
  type    = list(string)
  default = ["master0","master1"]
}


variable "node_ips" {
  type    = list(string)
  default = []
}

variable "node_names" {
  type    = list(string)
  default = []
}


variable "masters_conf" {
  type = object({
    nb     = number
    memory = number 
    cpu    = number
    disk   = string
  })
  default  = {
    nb     = 1
    memory = 4096
    cpu    = 2
    disk   = "20G"
  }
}

variable "nodes_conf" {
  type = object({
    nb     = number
    memory = number 
    cpu    = number
    disk   = string
  })
  default  = {
    nb     = 0
    memory = 4096
    cpu    = 2
    disk   = "20G"
  }
}

resource "proxmox_vm_qemu" "k3s_masters" {
    count             = var.masters_conf.nb
    name              = var.master_names[count.index]
    target_node       = var.pve_names[count.index % length(var.pve_names)]

    clone             = "VM 800${count.index % length(var.pve_names)}"

    os_type           = "cloud-init"
    cores             = var.masters_conf.cpu
    sockets           = "1"
    cpu               = "host"
    memory            = var.masters_conf.memory 
    scsihw            = "virtio-scsi-pci"
    bootdisk          = "scsi0"

    network {
      model  = "virtio"
      bridge = "vmbr0"
    }

    disk {
      size            = var.masters_conf.disk
      type            = "scsi"
      storage         = "local-lvm"
  }
  sshkeys = "${file("~/.ssh/id_rsa.pub")}"
  ipconfig0 = "ip=${var.master_ips[count.index]}/16,gw=172.16.0.1"
}

resource "proxmox_vm_qemu" "k3s_nodes" {
    count             = var.nodes_conf.nb
    name              = var.node_names[count.index]
    target_node       = var.pve_names[count.index % length(var.pve_names)]

    clone             = "VM 800${count.index % length(var.pve_names)}"

    os_type           = "cloud-init"
    cores             = var.nodes_conf.cpu
    sockets           = "1"
    cpu               = "host"
    memory            = var.nodes_conf.memory 
    scsihw            = "virtio-scsi-pci"
    bootdisk          = "scsi0"

    network {
      model  = "virtio"
      bridge = "vmbr0"
    }

    disk {
      size            = var.nodes_conf.disk
      type            = "scsi"
      storage         = "local-lvm"
  }
  sshkeys = "${file("~/.ssh/id_rsa.pub")}"
  ipconfig0 = "ip=${var.node_ips[count.index]}/16,gw=172.16.0.1"
}
