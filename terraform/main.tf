terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_lxc" "lxc_instances" {
  count = length(var.lxc)

  target_node  = var.proxmox_node
  hostname     = var.lxc[count.index].name
  vmid = var.lxc[count.index].id
  ostemplate   = var.lxc[count.index].os
  cores = var.lxc[count.index].cores
  memory = var.lxc[count.index].ram
  pool = var.lxc[count.index].pool
  tags = var.vms[count.index].tags
  nameserver = "1.1.1.1"
  unprivileged = true

  ssh_public_keys = <<-EOT
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBfQOXHJNhLYqyF9YIbOJdCvdNCIC2+aN9H7uyLY50x
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBHovtHE37E3kGaY6NNxdFKm5UBg0EOgXfOMjL8I37E
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6Cg91yjrIRXcytm3pFIXPOPat9I6SF+8MBsRlqCR0A
  EOT

  rootfs {
    size     = var.lxc[count.index].root_disk[0].size
    storage  = var.lxc[count.index].root_disk[0].storage
  }

  dynamic "network" {
    for_each = var.lxc[count.index].network
    content {
      name   = network.value.name
      bridge = network.value.bridge
      ip     = network.value.ipv4
      ip6    = "static"
      tag    = try(tonumber(network.value.tag), 0)
      gw  = network.value.gw
    }
  }
}

resource "proxmox_vm_qemu" "instances" {
  count = length(var.vms)

  # General
  target_node = var.proxmox_node
  name        = var.vms[count.index].name
  vmid        = var.vms[count.index].id
  tags        = var.vms[count.index].tags
  vm_state    = var.vms[count.index].vm_state
  # clone       = var.vms[count.index].os

  # Ressources
  memory      = var.vms[count.index].ram
  cpu {
    sockets     = var.vms[count.index].sockets
    cores       = var.vms[count.index].cores
  }

  # Behaviour
  boot        = "order=scsi0"
  scsihw      = "virtio-scsi-pci"
  agent       = 1
  start_at_node_boot      = true

  # Storage
  dynamic "disk" {
    for_each = var.vms[count.index].disks

    content {
      type       = "disk"
      size       = disk.value.size
      storage    = disk.value.storage
      slot       = disk.value.slot
    }
  }
  
  dynamic "network" {
    for_each = var.vms[count.index].network
    content {
      id     = network.value.id
      bridge = network.value.bridge
      tag    = try(tonumber(network.value.tag), 0)
      model  = "virtio"
      firewall = true
      macaddr = network.value.macaddr
    }
  }
}
