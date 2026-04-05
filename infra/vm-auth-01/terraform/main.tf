locals {
  vm = {
    name              = "auth-01"
    vm_id             = 12001
    description       = "Authentik + Postgres + Redis"
    vlan_id           = 120
    ipv4_address      = "192.168.120.10/24"
    ipv4_gateway      = "192.168.120.1"
    cores             = 2
    memory_mb         = 3072
    os_disk_gb        = 16
    os_disk_datastore = null
    data_disk_gb      = null
    data_disk_ds      = null
    firewall          = true
    tags              = ["authentik", "identity", "terraform"]
  }
}

module "vm" {
  source = "../../../shared/proxmox-vm-module"

  vm_name              = local.vm.name
  vm_id                = local.vm.vm_id
  description          = local.vm.description
  tags                 = local.vm.tags
  proxmox_node_name    = var.proxmox_node_name
  template_vm_id       = var.template_vm_id
  vm_datastore         = var.vm_datastore
  os_disk_datastore    = local.vm.os_disk_datastore
  data_disk_datastore  = local.vm.data_disk_ds
  cloud_init_datastore = var.cloud_init_datastore
  vm_bridge            = var.vm_bridge
  vm_username          = var.vm_username
  vm_password          = var.vm_password
  ssh_public_keys      = var.ssh_public_keys
  dns_servers          = var.dns_servers
  search_domain        = var.search_domain
  ipv4_address         = local.vm.ipv4_address
  ipv4_gateway         = local.vm.ipv4_gateway
  vlan_id              = local.vm.vlan_id
  cores                = local.vm.cores
  memory_mb            = local.vm.memory_mb
  os_disk_gb           = local.vm.os_disk_gb
  data_disk_gb         = local.vm.data_disk_gb
  firewall             = local.vm.firewall
}
