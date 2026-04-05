# openwebui

## Purpose
Web UI for local AI services.

This repository is the deployable payload for one service. It should stay focused on that service's container definition, configuration files, and any service-specific CI that ships the docker/ directory to its target host.

## Repository Layout
- docker/
- README.md
- .gitlab-ci.yml

### Docker Payload
- docker-compose.yml

### CI/CD Variables
- `ANSIBLE_SSH_PRIVATE_KEY`
- `SSH_KNOWN_HOSTS`
- `OPENWEBUI_OIDC_CLIENT_ID`
- `OPENWEBUI_OIDC_CLIENT_SECRET`

## Deployment Model
- The service repo owns the container payload.
- The target machine is prepared separately by the matching bootstrap or infra repo.
- Secrets belong in GitLab CI/CD variables or host-local env files, not in tracked plaintext files.
- CI is limited to protected `main` and deploys directly to the explicit target host.

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
- Deployment path assumption: `/opt/openwebui`.
- Ollama upstream is configurable through `OLLAMA_BASE_URL`.
- Review the compose file before each image or port change because these repos are intentionally small and direct.
