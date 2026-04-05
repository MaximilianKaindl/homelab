output "vm_name" {
  description = "VM name."
  value       = proxmox_virtual_environment_vm.this.name
}

output "vm_id" {
  description = "VM ID."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "ipv4_address" {
  description = "Configured static IPv4 address."
  value       = var.ipv4_address
}

output "vlan_id" {
  description = "Configured VLAN ID."
  value       = var.vlan_id
}
