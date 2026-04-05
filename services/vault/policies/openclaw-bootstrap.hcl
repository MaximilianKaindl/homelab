# Policy for the CI bootstrap pipeline (build_agent_payload.py).
# Grants read-only access to all agent secret paths and shared.
# Cannot write secrets, cannot access sys/, auth/, or any other path.
path "kv/data/openclaw/shared" {
  capabilities = ["read"]
}

path "kv/metadata/openclaw/shared" {
  capabilities = ["read"]
}

path "kv/data/openclaw/agents/*" {
  capabilities = ["read"]
}

path "kv/metadata/openclaw/agents/*" {
  capabilities = ["read"]
}
