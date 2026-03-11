variable "proxmox" {
  type = object({
    node = string
    authorized_keys = string
    api  = object({
      url           = string
      token_id      = string
      token_secret  = string
    })
  })
}

variable "lxc" {
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
  type = list(object({
    name        = string   # VM Name
    id          = number   # VM ID
    ram         = number   # RAM in MB
    cores       = number   # Number of CPU cores
    sockets     = number   # Number of CPU sockets
    os          = string   # OS template to clone from
    disk        = list(object({
      size       = string   # Disk size (e.g., 10G)
      storage    = string   # Storage location (e.g., local-lvm)
      slot       = number   # Disk slot
    }))
    network     = list(object({
      name       = string   # Network interface name (e.g., eth0)
      bridge     = string   # Bridge (e.g., vmbr0)
    }))
  }))
}
