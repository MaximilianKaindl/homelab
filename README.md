# Proxmox Homelab

Infrastructure-as-code for a self-hosted homelab running on Proxmox VE. Everything is provisioned with Terraform, configured with Ansible, and deployed via GitLab CI/CD running on the cluster itself.

## Architecture

```
Proxmox VE
├── bootstrap/
│   ├── vm-build-01     GitLab runner host — executes all CI/CD pipelines
│   └── vm-git-01       Self-hosted GitLab CE — source of truth for all deployments
│
├── infra/
│   ├── vm-ai-ubuntu-01     Ollama inference + OpenWebUI, GPU passthrough
│   ├── vm-apps-01          Mattermost, Synapse, Docmost, OpenWebUI (VLAN 110)
│   ├── vm-auth-01          Authentik identity provider + Postgres + Redis (VLAN 120)
│   ├── vm-monitor-01       Grafana, Loki, Mimir, Tempo — full LGTM stack (VLAN 50)
│   └── vm-nextcloud-01     Nextcloud + Postgres + Redis (VLAN 110)
│
└── shared/
    ├── proxmox-vm-module       Reusable Terraform module for Proxmox VMs
    ├── proxmox-lxc-module      Reusable Terraform module for Proxmox LXCs
    └── ansible-common          Shared Ansible roles used by every host
```

## Stack

| Layer | Technology |
|---|---|
| Hypervisor | Proxmox VE |
| Provisioning | Terraform (`bpg/proxmox` provider) |
| Configuration | Ansible |
| CI/CD | Self-hosted GitLab CE + GitLab Runners |
| Identity | Authentik (OIDC/SAML for all services) |
| Reverse proxy | Traefik (internal + edge) |
| Observability | Grafana · Loki · Mimir · Tempo · Alloy |
| Secret management | HashiCorp Vault |
| Networking | VLAN segmentation via UniFi |
| DNS | AdGuard Home (internal) + Cloudflare (external) |
| PKI | Step CA — internal TLS for all services |
| AI | Ollama + OpenWebUI + OpenClaw agent |

## Shared Ansible Roles

All VMs pull from `shared/ansible-common`. Five roles ship with every host:

- **base** — system hardening, Alloy agent, Node Exporter, Step CA trust, unattended upgrades
- **deploy_user** — unprivileged deploy user with scoped sudo, SSH key injection
- **docker_host** — Docker CE, daemon hardening, observability sidecar (metrics + log scraping)
- **gitlab_runners** — installs and registers GitLab runners with the internal CI
- **pve_host** — Proxmox-specific hardening: SSH port, no-subscription repo, Alloy integration

## Services

| Service | Stack | Purpose |
|---|---|---|
| [authentik](services/authentik/) | Docker Compose | SSO — all internal services authenticate here |
| [nextcloud](services/nextcloud/) | Docker Compose | File sync and sharing |
| [mattermost](services/mattermost/) | Docker Compose | Team messaging |
| [grafana](services/grafana/) | Docker Compose | Dashboards — queries Loki, Mimir, Tempo |
| [ollama](services/ollama/) | Docker Compose | Local LLM inference (GPU) |
| [openwebui](services/openwebui/) | Docker Compose | Chat UI over Ollama, OIDC via Authentik |
| [docmost](services/docmost/) | Docker Compose | Internal wiki and documentation |
| [vault](services/vault/) | Docker Compose | Secret storage and dynamic credentials |
| [honcho](services/honcho/) | Docker Compose | AI agent process manager |

## Terraform Modules

### `shared/proxmox-vm-module`

Wraps the `bpg/proxmox` provider to provision Ubuntu cloud-init VMs with:
- static IP + VLAN tag via cloud-init
- cloud-init SSH key injection
- configurable disk, CPU, memory
- consistent tagging

### `shared/proxmox-lxc-module`

Same pattern for LXC containers — used for lightweight infrastructure services (DNS, PKI, PBS, internal services).

## What is not published

The following are excluded because they encode live environment topology or control-plane details:

- Cloudflare DNS Terraform root — public IP and zone ID
- UniFi firewall Terraform — full zone/policy definitions
- Platform firewall (Proxmox guest firewall) — per-VM rule sets
- Ansible inventories and host\_vars — live IPs, vault references
- Edge and internal Traefik stacks — routing rules and certificate config
- Mailserver, Synapse, and registry stacks

These may be replaced with sanitized examples over time.
