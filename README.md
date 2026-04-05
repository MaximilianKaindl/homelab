# Proxmox Homelab

This repository is the public-facing version of my homelab work. It is intentionally conservative about what gets published.

This is a work in progress. The long-term aim is maximum reproducibility and strong security, but the public repo will only contain material that is safe to share.

## What is currently public

- reusable Terraform modules under `shared/`
- selected real code that is useful without exposing live environment topology
- selected bootstrap host-prep code and shared Ansible building blocks
- top-level documentation and repository guardrails

## Included Code

The current public set intentionally includes only code that remains useful after removing environment-specific control-plane details:

- reusable Proxmox VM and LXC Terraform modules
- bootstrap playbooks for `build-01` and `git-01`
- an AI-host helper for container sandbox authorization
- an NVIDIA + Ollama host setup playbook
- a small Ollama service payload
- a few additional service payloads with sanitized endpoints and routing details
- a Vault service payload with policy and seed examples
- agent-bootstrap helper code with placeholder registry and GitLab endpoints
- example VM and LXC Terraform roots wired to the shared public modules
- shared Ansible roles and playbooks without inventories, host vars, or edge-specific orchestration

## What is intentionally missing

The following parts of the real homelab are currently excluded from the public repository:

- environment-specific bootstrap flows
- infrastructure environment roots and network-specific control layers
- service deployment stacks that still expose edge or control-plane details
- DNS, public-edge, and firewall control-plane repositories
- shared inventories, host variables, and orchestration that encode live environment assumptions

Those paths are omitted because they contain sensitive environment details such as:

- private IP ranges and host addressing
- internal naming, routing, and service mapping details
- network-policy and reachability rules
- deployment targets and internal routing assumptions
- live edge hostnames, public domains, and registry endpoints

## Purpose

The goal is to share the reusable building blocks and the overall direction of the homelab without publishing internal network topology or security-sensitive operational details.

Over time I plan to replace omitted areas with sanitized examples, abstractions, and documentation that improve reproducibility without exposing the live environment.
