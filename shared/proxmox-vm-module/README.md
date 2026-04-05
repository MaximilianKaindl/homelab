# proxmox-vm-module

## Purpose
Reusable Terraform module for Proxmox virtual machines.

This repository is a reusable Terraform module, not an environment root. It should stay generic enough to be consumed by multiple bootstrap or infra projects without embedding host-specific assumptions.

## Repository Layout
- main.tf
- outputs.tf
- README.md
- variables.tf

### Module Inputs
- vm_name
- vm_id
- description
- tags
- proxmox_node_name
- template_vm_id
- vm_datastore
- os_disk_datastore
- data_disk_datastore
- cloud_init_datastore
- vm_bridge
- vm_username
- vm_password
- ssh_public_keys
- dns_servers
- search_domain
- ipv4_address
- ipv4_gateway
- vlan_id
- cores
- memory_mb
- os_disk_gb
- data_disk_gb
- firewall
- bios
- machine
- started
- on_boot
- stop_on_destroy
- enable_agent
- cpu_type
- hostpci_mapping

## Usage Guidelines
- Keep provider configuration in the calling root, not in the module consumer contract unless the module truly requires it.
- Add new inputs only when the module needs a stable, reusable interface.
- Prefer sensible defaults for optional behavior and explicit variables for required behavior.
- Document breaking module interface changes clearly in commit messages.

## Operational Notes
- Caller repos should pass values through their own declared variables and subgroup-level TF_VAR_* settings.
- If logic only serves one environment root, keep it in that root instead of expanding the shared module unnecessarily.
