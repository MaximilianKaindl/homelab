#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path


SERVICE_DIR = Path(__file__).resolve().parents[1]
CONFIG_DIR = SERVICE_DIR / "config" / "agents"
BUILD_DIR = SERVICE_DIR / "build"


def load_agents() -> list[dict]:
    return [json.loads(path.read_text(encoding="utf-8")) for path in sorted(CONFIG_DIR.glob("*.json"))]


def main() -> None:
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    payload = {"agents": load_agents()}
    (BUILD_DIR / "agent-bootstrap.json").write_text(
        json.dumps(payload, indent=2) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
