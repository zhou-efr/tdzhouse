variable "proxmox" {
  type = object({
    node = string
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
      size   = bool
      storage  = string
    }))
    network = list(object({
      bridge   = string
      ipv4  = string
    }))
  }))
}
