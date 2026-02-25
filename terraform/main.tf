terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox.api.url
  pm_api_token_id = var.proxmox.api.token_id
  pm_api_token_secret = var.proxmox.api.token_secret
  pm_tls_insecure = true
}

resource "proxmox_lxc" "lxc_instances" {
  count = length(var.lxc)

  target_node  = var.proxmox.node
  hostname     = var.lxc[count.index].name
  vmid = var.lxc[count.index].id
  ostemplate   = var.lxc[count.index].os
  cores = var.lxc[count.index].cores
  memory = var.lxc[count.index].ram
  pool = var.lxc[count.index].pool
  nameserver = "1.1.1.1"
  onboot = true
  unprivileged = true

  ssh_public_keys = var.proxmox.authorized_keys

  rootfs {
    size    = var.lxc[count.index].root_disk.size
    storage = var.lxc[count.index].root_disk.storage
  }

  network {
    name   = "eth0"
    bridge = var.lxc[count.index].bridge
    ip     = var.lxc[count.index].ipv4
    ip6    = "dhcp"
  }
}