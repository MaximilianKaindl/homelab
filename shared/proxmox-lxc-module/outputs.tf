output "hostname" {
  description = "Container hostname."
  value       = var.hostname
}

output "vm_id" {
  description = "Container ID."
  value       = proxmox_virtual_environment_container.this.vm_id
}

output "ipv4_address" {
  description = "Configured static IPv4 address."
  value       = var.ipv4_address
}

output "vlan_id" {
  description = "Configured VLAN ID."
  value       = var.vlan_id
}
