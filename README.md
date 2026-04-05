# Proxmox Homelab

This repository is the public-facing version of my homelab work. It is intentionally conservative about what gets published.

This is a work in progress. The long-term aim is maximum reproducibility and strong security, but the public repo only contains material that is safe to share.

## What is currently public

- reusable Terraform modules under `shared/`
- sanitized VM Terraform roots and host playbooks for selected workload machines
- selected service payloads with internal edge, DNS, and control-plane details removed
- top-level documentation and repository guardrails

## Included Code

The current public set intentionally includes only code that stays useful after removing environment-specific control-plane details:

- reusable Proxmox VM and LXC Terraform modules
- sanitized VM roots for `vm-ai-ubuntu-01`, `vm-apps-01`, `vm-auth-01`, `vm-monitor-01`, and `vm-nextcloud-01`
- host-specific Ansible entrypoint playbooks for those workload machines
- service payloads for Ollama, Vault, Docmost, Mattermost, Nextcloud, OpenWebUI, and Honcho
- agent-bootstrap helper scripts that do not embed internal registry or routing details

## What is intentionally missing

The following parts of the real homelab are still excluded from the public repository:

- environment-specific bootstrap flows
- DNS, public edge, and firewall control-plane repositories
- Cloudflare, platform firewall, and UniFi firewall roots
- service stacks that still expose ingress, identity, registry, or edge-routing details
- shared inventories, host variables, and orchestration that encode live environment assumptions

Those paths are omitted because they contain sensitive environment details such as:

- internal naming, routing, and service mapping details
- network-policy and reachability rules
- deployment targets and control-plane assumptions
- live edge hostnames, public domains, and registry endpoints

## Purpose

The goal is to share reusable building blocks and the overall direction of the homelab without publishing the live control plane.

Over time I plan to replace more omitted areas with sanitized examples, abstractions, and documentation that improve reproducibility without exposing the active environment.
