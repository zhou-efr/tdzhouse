variable "proxmox_node" {
  type    = string
  default = null
}

variable "proxmox_authorized_keys" {
  type    = string
  default = null
}

variable "proxmox_api_url" {
  type    = string
  default = null
}

variable "proxmox_api_token_id" {
  type    = string
  default = null
}

variable "proxmox_api_token_secret" {
  type    = string
  default = null
}

variable "lxc" {
  default = []
  type = list(object({
    name     = string
    id       = number
    ram      = number
    cores    = number
    os       = string
    pool     = string
    root_disk    = list(object({
      size   = string
      storage  = string
    }))
    network = list(object({
      name = string
      bridge   = string
      ipv4  = string
    }))
  }))
}

variable "vms" {
  default = []
  type = list(object({
    name        = string   # VM Name
    id          = number   # VM ID
    ram         = number   # RAM in MB
    cores       = number   # Number of CPU cores
    sockets     = number   # Number of CPU sockets
    os          = string   # OS template to clone from
    vm_state    = string
    disks        = list(object({
      size       = string   # Disk size (e.g., 10G)
      storage    = string   # Storage location (e.g., local-lvm)
      slot       = string   # Disk slot
    }))
    network     = list(object({
      id         = number
      name       = string   # Network interface name (e.g., eth0)
      bridge     = string   # Bridge (e.g., vmbr0)
      macaddr    = string   # Mac adresse
    }))
  }))
}
