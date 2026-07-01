terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
    ansible = {
      version = "~> 1.4.0"
      source  = "ansible/ansible"
    }
  }
}

resource "ansible_vault" "secrets" {
  vault_file          = "./vars/configuration.yml"
  vault_password_file = "./vars/secret.pass"
}

locals {
  decoded_vault_yaml = yamldecode(ansible_vault.secrets.yaml)
}

provider "proxmox" {
  insecure = true
}

resource "proxmox_virtual_environment_vm" "instance" {
  # General
  node_name = local.decoded_vault_yaml.proxmox_node
  name      = local.decoded_vault_yaml.name
  vm_id     = local.decoded_vault_yaml.vmid
  tags      = local.decoded_vault_yaml.tags
  started   = false

  clone {
    vm_id = local.decoded_vault_yaml.template_vmid
    full  = true
    datastore_id = local.decoded_vault_yaml.cloud_init_template_storage
  }

  # Ressources
  memory {
    dedicated = local.decoded_vault_yaml.ram
  }

  cpu {
    sockets = local.decoded_vault_yaml.sockets
    cores   = local.decoded_vault_yaml.cores
  }

  # Behaviour
  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-pci"
  on_boot       = true

  agent {
    enabled = true
  }

  # Storage
  dynamic "disk" {
    for_each = local.decoded_vault_yaml.disks
    content {
      interface    = disk.value.slot
      size         = disk.value.size
      datastore_id = disk.value.storage
    }
  }

  # Network
  dynamic "network_device" {
    for_each = local.decoded_vault_yaml.networks
    content {
      bridge      = network_device.value.bridge
      vlan_id     = (
        try(tonumber(network_device.value.tag), 0) != 0
        ? tonumber(network_device.value.tag)
        : null
      )
      model       = "virtio"
      firewall    = true
      # mac_address = network_device.value.macaddr
    }
  }

  # Cloud init
  initialization {
    datastore_id = local.decoded_vault_yaml.cloud_init_template_storage

    user_account {
      username = "root"
      password = local.decoded_vault_yaml.root_password
      keys     = local.decoded_vault_yaml.authorized_keys
    }

    dynamic "dns" {
      for_each = local.decoded_vault_yaml.networks
      content {
        servers = [try(dns.value.dns, null)]
      }
    }

    dynamic "ip_config" {
      for_each = local.decoded_vault_yaml.networks
      content {
        ipv4 {
          address = try(ip_config.value.ip, "dhcp")
          gateway = try(ip_config.value.gateway, null)
        }
      }
    }
  }
}