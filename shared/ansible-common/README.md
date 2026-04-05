# ansible-common

## Purpose
Shared inventory, roles, and playbooks consumed by the bootstrap and infra repos.

This repository is the shared Ansible control-plane layer for the homelab split-repo layout. Bootstrap and infra repos keep only thin wrapper playbooks locally and consume this repo at runtime from GitLab CI.

## Repository Layout
- inventories/
- playbooks/
- roles/
- ansible.cfg
- README.md
- vault.example.yml

### Inventories
- homelab\group_vars\all.yml
- homelab\group_vars\build.yml
- homelab\group_vars\compute.yml
- homelab\group_vars\edge.yml
- homelab\group_vars\monitor.yml
- homelab\group_vars\pub_apps.yml
- homelab\host_vars\ai-ubuntu-01.yml
- homelab\host_vars\apps-01.yml
- homelab\host_vars\auth-01.yml
- homelab\host_vars\build-01.yml
- homelab\host_vars\edge-01.yml
- homelab\host_vars\git-01.yml
- homelab\host_vars\monitor-01.yml
- homelab\host_vars\nextcloud-01.yml
- homelab\hosts.yml

### Shared Playbooks
- build-01.yml
- common.yml
- docker-hosts.yml
- edge-01.yml
- git-01.yml
- pve-host.yml
- site.yml

### Roles
- base/
- crowdsec/
- docker_host/
- gitlab/
- gitlab_runners/
- pve_host/
- traefik_edge/

## Design Rules
- Inventories, shared roles, and shared defaults live here.
- Per-host wrapper playbooks live in the individual bootstrap or infra repos.
- Secrets belong in Ansible vault data and GitLab protected variables, not in tracked plaintext files.
- Changes here can affect multiple hosts, so treat them as shared platform changes.

## How Other Repos Use This
- Bootstrap and infra CI jobs clone this repo during pipeline execution.
- The job sets ANSIBLE_CONFIG to ansible.cfg from this repo.
- The local wrapper playbook from the calling repo is executed against the inventory in this repo.
- Vault decryption is provided through a protected GitLab variable.

## Operational Notes
- Keep role boundaries clear so host wrappers stay small.
- Prefer adding reusable logic here instead of copying tasks across host repos.
- Maintain a vault.example.yml pattern that shows expected secret keys without leaking real values.
