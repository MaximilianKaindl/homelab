locals {
  vm = {
    name              = "nextcloud-01"
    vm_id             = 11001
    description       = "Nextcloud + Postgres + Redis"
    vlan_id           = 110
    ipv4_address      = "192.168.110.10/24"
    ipv4_gateway      = "192.168.110.1"
    cores             = 2
    memory_mb         = 3072
    os_disk_gb        = 16
    os_disk_datastore = null
    data_disk_gb      = 150
    data_disk_ds      = "nextcloud"
    firewall          = true
    tags              = ["nextcloud", "public-apps", "terraform"]
  }
}

module "vm" {
  source = "../../shared/proxmox-vm-module"

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
  dns_servers          = ["192.168.60.10", local.vm.ipv4_gateway]
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
