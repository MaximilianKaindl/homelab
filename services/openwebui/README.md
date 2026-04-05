# openwebui

## Purpose
Web UI for local AI services.

This repository is the deployable payload for one service. It stays focused on that service's container definition, configuration files, and any service-specific automation that ships the `docker/` directory to its target host.

## Repository Layout
- `docker/`
- `README.md`
- optional CI configuration

### Docker Payload
- `docker-compose.yml`

### Runtime Inputs
- `OPENWEBUI_OIDC_CLIENT_ID`
- `OPENWEBUI_OIDC_CLIENT_SECRET`

## Deployment Model
- The service repo owns the container payload.
- The target machine is prepared separately by the matching infra repo.
- Secrets belong in CI variables or host-local env files, not in tracked plaintext files.
- Deployment automation should keep the target host explicit.

## What Belongs Here
- Compose files and service-local configuration.
- Health checks or readiness checks that are specific to this service.
- Minimal deployment automation for this service only.

## What Does Not Belong Here
- Shared host hardening or Docker installation logic.
- Reusable Terraform or Ansible logic that should live in shared repos.
- Cross-service routing or platform-wide configuration unless this service is the owner of it.

## Operational Notes
- Target host assumption for this service: apps-01.
- Ollama upstream assumption: `http://192.168.20.10:11434`.
- The published OIDC endpoint uses a generic placeholder so the live identity endpoint is not exposed.
