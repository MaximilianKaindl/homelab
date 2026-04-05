# Proxmox Homelab

This repository is the public-facing version of my homelab work. It is intentionally conservative about what gets published.

This is a work in progress. The long-term aim is maximum reproducibility and strong security, but the public repo will only contain material that is safe to share.

## What is currently public

- reusable Terraform modules under `shared/`
- top-level documentation and repository guardrails

## What is intentionally missing

The following parts of the real homelab are currently excluded from the public repository:

- environment-specific bootstrap flows
- infrastructure roots for VMs, LXCs, DNS, and firewall policy
- service deployment stacks and reverse-proxy routing
- shared operational automation that contains internal addressing or host assumptions

Those paths are omitted because they contain sensitive environment details such as:

- private IP ranges and host addressing
- internal DNS names and DNS record mappings
- firewall policy, zone layout, and service reachability rules
- deployment targets and internal routing assumptions

## Purpose

The goal is to share the reusable building blocks and the overall direction of the homelab without publishing internal network topology or security-sensitive operational details.

Over time I plan to replace omitted areas with sanitized examples, abstractions, and documentation that improve reproducibility without exposing the live environment.
