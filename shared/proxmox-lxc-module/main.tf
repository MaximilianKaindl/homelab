resource "proxmox_virtual_environment_container" "this" {
  node_name     = var.proxmox_node_name
  vm_id         = var.vm_id
  description   = var.description
  tags          = sort(var.tags)
  start_on_boot = var.start_on_boot
  unprivileged  = var.unprivileged

  initialization {
    hostname = var.hostname

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
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_gb
  }

  network_interface {
    name     = "eth0"
    bridge   = var.vm_bridge
    vlan_id  = var.vlan_id
    firewall = var.firewall
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      console,
      description,
      tags,
      vm_id,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
      cpu,
      disk,
      mount_point,
      operating_system,
      protection,
      start_on_boot,
      unprivileged,
    ]
  }
}
