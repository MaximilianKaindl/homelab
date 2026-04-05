# honcho

CI-driven Honcho stack for `ai-ubuntu-01`.

This repo owns only the Honcho runtime services:

- `honcho-db`
- `honcho-redis`
- `honcho`
- `honcho-deriver`

## Purpose

OpenClaw uses the Honcho plugin, but the plugin and the Honcho service deploy from separate repos. This keeps memory-service rollouts independent from gateway changes.

## Deploy

The deployment pipeline:

- resolves provider defaults from CI variables, with explicit provider/model overrides winning over auto-detection
- writes `/opt/openclaw/honcho/docker/.env`
- syncs `docker/` to the VM
- creates or reuses the shared `ai-ubuntu-01_ai` Docker network
- starts Postgres and Redis, runs Honcho database migrations, then starts the Honcho app and deriver
- verifies `http://127.0.0.1:8000/openapi.json` from inside the container

Deploy this repo before the OpenClaw service payload so the Honcho plugin can connect to `http://honcho:8000`.

Supported CI/CD overrides:

- `HONCHO_LLM_PROVIDER` or `HONCHO_PROVIDER` to force the primary provider
- `HONCHO_MODEL` to force the primary model
- `HONCHO_SUMMARY_PROVIDER` and `HONCHO_SUMMARY_MODEL` to override summary defaults
- legacy `DIALECTIC_PROVIDER`, `DIALECTIC_MODEL`, `SUMMARY_PROVIDER`, and `SUMMARY_MODEL` are still honored as fallbacks

If no provider override is set, the pipeline falls back to auto-detecting from `OPENAI_API_KEY` and `GEMINI_API_KEY`. The generated `.env` writes complete `DIALECTIC_LEVELS__...` entries for every reasoning level so Honcho does not fall back to Anthropic defaults for `medium`, `high`, or `max` when you intend to run a Google-only setup.
