# Policy for the OpenClaw gateway process.
# Grants read-only access to the shared secret store only.
# The gateway needs OPENCLAW_GATEWAY_TOKEN and shared API keys — nothing else.
path "kv/data/openclaw/shared" {
  capabilities = ["read"]
}

path "kv/metadata/openclaw/shared" {
  capabilities = ["read"]
}
