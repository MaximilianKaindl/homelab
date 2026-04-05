output "gitlab_vm_name" {
  value = proxmox_virtual_environment_vm.gitlab.name
}

output "gitlab_ip_address" {
  value = var.gitlab_ipv4_address
}
