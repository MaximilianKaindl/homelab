resource "proxmox_virtual_environment_vm" "this" {
  name            = var.vm_name
  description     = var.description
  tags            = sort(var.tags)
  node_name       = var.proxmox_node_name
  vm_id           = var.vm_id
  bios            = var.bios
  machine         = var.machine
  started         = var.started
  on_boot         = var.on_boot
  stop_on_destroy = var.stop_on_destroy

  clone {
    vm_id = var.template_vm_id
  }

  agent {
    enabled = var.enable_agent
    trim    = true
  }

  cpu {
    cores = var.cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = coalesce(var.os_disk_datastore, var.vm_datastore)
    interface    = "scsi0"
    size         = var.os_disk_gb
    discard      = "on"
    iothread     = true
  }

  dynamic "disk" {
    for_each = var.data_disk_gb == null ? [] : [var.data_disk_gb]

    content {
      datastore_id = coalesce(var.data_disk_datastore, var.os_disk_datastore, var.vm_datastore)
      interface    = "scsi1"
      size         = disk.value
      discard      = "on"
      iothread     = true
    }
  }

  initialization {
    datastore_id = var.cloud_init_datastore
    interface    = "ide2"

    dns {
      servers = var.dns_servers
      domain  = var.search_domain
    }

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
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
    vlan_id  = var.vlan_id
    firewall = var.firewall
  }

  dynamic "hostpci" {
    for_each = var.hostpci_mapping == null ? [] : [var.hostpci_mapping]

    content {
      device  = "hostpci0"
      mapping = hostpci.value
      pcie    = true
      xvga    = false
    }
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
