# nextcloud

## Purpose
File sync and collaboration service payload.

This repository is the deployable payload for one service. It should stay focused on that service's container definition, configuration files, and any service-specific CI that ships the docker/ directory to its target host.

## Repository Layout
- docker/
- README.md

### Docker Payload
- docker-compose.yml

## Deployment Model
- The service repo owns the container payload.
- The target machine is prepared separately by the matching bootstrap or infra repo.
- Secrets belong in GitLab CI/CD variables or host-local env files, not in tracked plaintext files.
- If you add CI, keep it limited to protected main and make the deploy target explicit.

## What Belongs Here
- Compose files and service-local configuration.
- Health checks or readiness checks that are specific to this service.
- Minimal deployment automation for this service only.

## What Does Not Belong Here
- Shared host hardening or Docker installation logic.
- Reusable Terraform or Ansible logic that should live in shared repos.
- Cross-service routing or platform-wide configuration unless this service is the owner of it.

## Operational Notes
- Target host assumption for this service: nextcloud-01.
- Review the compose file before each image or port change because these repos are intentionally small and direct.
