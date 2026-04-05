# openclaw-agent-setup

GitLab-driven post-create bootstrap for OpenClaw sandbox containers on `ai-ubuntu-01`.

This repo owns the full post-deploy OpenClaw setup layer:

- the full `openclaw-home/` bundle for the gateway volume
- agent bootstrap manifests
- gateway-home installation into the running `openclaw` container
- plugin install, skill install, and sandbox recreation
- the scripts that find the running sandbox container for each agent
- Vault lookups for agent-only credentials
- container-local setup such as env bootstrap files and Google service-account materialization

It does not deploy the OpenClaw gateway itself. Deploy `homelab/services/openclaw` first so the sandbox containers exist.

## Credential Model

- Secrets are read from Vault at deploy time and are never committed here.
- Each agent is bootstrapped from `kv/openclaw/agents/<agentId>` plus `kv/openclaw/shared` only for explicitly shared keys.
- The setup script writes only that agent's files inside that agent's sandbox container.
- No cross-agent credential files are created.

## Deploy Order

1. Deploy `homelab/services/vault`.
2. Deploy `homelab/services/openclaw`.
3. Deploy `homelab/services/openclaw-agent-setup`.  

## Runtime Flow

The GitLab pipeline:

- renders `build/agent-bootstrap.json`
- syncs `openclaw-home/`, `config/`, `scripts/`, and `build/` to `/opt/openclaw/agent-setup`
- installs the full `openclaw-home/` bundle into the running `openclaw` container volume
- restarts the gateway and waits for health
- installs plugins and skills through the `openclaw` helper
- recreates all agent sandboxes from the full config
- locates the running sandbox container for each configured agent image
- fetches that agent's secrets from Vault
- writes `/home/node/.config/openclaw-agent/env.sh` inside the matching container
- writes any required credential files such as the organizer Google service-account JSON
- installs a lightweight shell bootstrap so login shells source the agent env file automatically

## Notes

- This repo expects the gateway container to already be running from `homelab/services/openclaw`.
- If an agent sandbox is not running yet, the deploy fails fast so the missing container can be fixed explicitly.
