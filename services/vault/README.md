# vault

GitLab-driven Vault stack for `ai-ubuntu-01`.

This repo owns:

- the Vault runtime container
- the tracked OpenClaw policy files under `policies/`
- the tracked seed templates under `seeds/`
- the manual GitLab bootstrap job that initializes Vault and writes the current OpenClaw keys

## Purpose

OpenClaw now reads credentials only through Vault-backed SecretRefs at runtime, but Vault lifecycle and seeding are deployed separately from the gateway.

## Deploy Flow

The GitLab pipeline:

1. deploys the Vault container to `/opt/openclaw/vault`
2. verifies the service is reachable
3. exposes a manual `seed:bootstrap` job for first-time init and reseeding

## Notes

- `seed:bootstrap` still prints the initial root token and unseal key if Vault is not initialized yet, so treat that job log as sensitive
- policy and seed files were copied from the current OpenClaw-generated output to give the split repo a working baseline
- future agent changes in `homelab/services/openclaw` should be mirrored here when they change required Vault policy or seed shape
