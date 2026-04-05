#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path


def read_vault_json(base_url: str, token: str, path: str) -> dict[str, str]:
    request = urllib.request.Request(
        f"{base_url.rstrip('/')}/v1/kv/data/{path}",
        headers={"X-Vault-Token": token},
    )
    with urllib.request.urlopen(request) as response:
        payload = json.load(response)
    return payload["data"]["data"]


def shell_quote(value: str) -> str:
    return "'" + value.replace("'", "'\"'\"'") + "'"


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: build_agent_payload.py <manifest-path> <agent-id>")

    manifest = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    agent_id = sys.argv[2]
    vault_addr = os.environ.get("VAULT_ADDR")
    vault_token = os.environ.get("VAULT_TOKEN")

    if not vault_addr or not vault_token:
        raise SystemExit("VAULT_ADDR and VAULT_TOKEN are required")

    agent = next((entry for entry in manifest["agents"] if entry["id"] == agent_id), None)
    if agent is None:
        raise SystemExit(f"unknown agent {agent_id}")

    shared_data = read_vault_json(vault_addr, vault_token, "openclaw/shared")
    agent_data = read_vault_json(vault_addr, vault_token, f"openclaw/agents/{agent_id}")

    env_lines = [
        "#!/bin/sh",
        "set -eu",
        "",
    ]
    for key in agent.get("sharedKeys", []):
        env_lines.append(f"export {key}={shell_quote(str(shared_data[key]))}")
    for env_name, vault_key in agent.get("agentEnv", {}).items():
        if vault_key.startswith("/"):
            env_lines.append(f"export {env_name}={shell_quote(vault_key)}")
        else:
            env_lines.append(f"export {env_name}={shell_quote(str(agent_data[vault_key]))}")

    payload = {
        "id": agent_id,
        "image": agent["image"],
        "envScript": "\n".join(env_lines) + "\n",
        "files": [],
    }

    for item in agent.get("files", []):
        payload["files"].append(
            {
                "path": item["path"],
                "mode": item.get("mode", "0600"),
                "content": str(agent_data[item["vaultKey"]]),
            }
        )

    json.dump(payload, sys.stdout)


if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as error:
        raise SystemExit(f"Vault request failed: {error.code} {error.reason}") from error
