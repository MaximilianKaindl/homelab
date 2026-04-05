locals {
  gitlab_vm = {
    name         = var.gitlab_vm_name
    vm_id        = var.gitlab_vm_id
    description  = "GitLab platform VM for Dockerized GitLab"
    vlan_id      = var.gitlab_vlan_id
    ipv4_address = var.gitlab_ipv4_address
    ipv4_gateway = var.gitlab_ipv4_gateway
    cores        = var.gitlab_cores
    memory_mb    = var.gitlab_memory_mb
    os_disk_gb   = var.gitlab_os_disk_gb
    data_disk_gb = var.gitlab_data_disk_gb
  }
}

resource "proxmox_virtual_environment_vm" "gitlab" {
  name        = local.gitlab_vm.name
  description = local.gitlab_vm.description
  tags        = sort(["terraform", "gitlab", "bootstrap"])
  node_name   = var.proxmox_node_name
  vm_id       = local.gitlab_vm.vm_id

  clone {
    vm_id = var.template_vm_id
  }

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores = local.gitlab_vm.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.gitlab_vm.memory_mb
  }

  disk {
    datastore_id = var.vm_datastore
    interface    = "scsi0"
    size         = local.gitlab_vm.os_disk_gb
    discard      = "on"
    iothread     = true
  }

  disk {
    datastore_id = var.gitlab_data_datastore
    interface    = "scsi1"
    size         = local.gitlab_vm.data_disk_gb
    discard      = "on"
    iothread     = true
  }

  initialization {
    datastore_id = var.cloud_init_datastore
    interface    = "ide2"

    dns {
      servers = ["192.168.60.10", local.gitlab_vm.ipv4_gateway]
      domain  = var.search_domain
    }

    ip_config {
      ipv4 {
        address = local.gitlab_vm.ipv4_address
        gateway = local.gitlab_vm.ipv4_gateway
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = var.ssh_public_keys
    }
  }

  network_device {
    bridge   = var.vm_bridge
    model    = "virtio"
    vlan_id  = local.gitlab_vm.vlan_id
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [initialization]
  }
}
