# proxmox-lxc-module

## Purpose
Reusable Terraform module for Proxmox LXC containers.

This repository is a reusable Terraform module, not an environment root. It should stay generic enough to be consumed by multiple bootstrap or infra projects without embedding host-specific assumptions.

## Repository Layout
- main.tf
- outputs.tf
- README.md
- variables.tf

### Module Inputs
- hostname
- vm_id
- description
- tags
- proxmox_node_name
- vm_bridge
- dns_servers
- search_domain
- ipv4_address
- ipv4_gateway
- vlan_id
- cores
- memory_mb
- swap_mb
- disk_gb
- datastore_id
- start_on_boot
- unprivileged
- firewall

## Usage Guidelines
- Keep provider configuration in the calling root, not in the module consumer contract unless the module truly requires it.
- Add new inputs only when the module needs a stable, reusable interface.
- Prefer sensible defaults for optional behavior and explicit variables for required behavior.
- Document breaking module interface changes clearly in commit messages.

## Operational Notes
- Caller repos should pass values through their own declared variables and subgroup-level TF_VAR_* settings.
- If logic only serves one environment root, keep it in that root instead of expanding the shared module unnecessarily.
