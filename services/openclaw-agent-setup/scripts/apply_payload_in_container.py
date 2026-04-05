#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import sys
from pathlib import Path


import pwd

payload = json.load(sys.stdin)

# Detect the unprivileged user: prefer /home/node, otherwise first uid >= 1000 with a real home.
_node_home: Path | None = None
if Path("/home/node").is_dir():
    _stat = os.stat("/home/node")
    node_uid: int = _stat.st_uid
    node_gid: int = _stat.st_gid
    _node_home = Path("/home/node")
else:
    for _entry in sorted(pwd.getpwall(), key=lambda e: e.pw_uid):
        if _entry.pw_uid >= 1000 and _entry.pw_dir not in ("", "/"):
            node_uid = _entry.pw_uid
            node_gid = _entry.pw_gid
            _node_home = Path(_entry.pw_dir)
            break

if _node_home is None:
    raise RuntimeError("No non-root user home directory found in container")

node_home = _node_home


def write_owned(path: Path, content: str, mode: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    os.chmod(path, mode)
    os.chown(path, node_uid, node_gid)


env_path = node_home / ".config/openclaw-agent/env.sh"
write_owned(env_path, payload["envScript"], 0o600)

snippet = f"if [ -f {env_path} ]; then . {env_path}; fi\n"
profile_paths = [
    (Path("/etc/profile.d/openclaw-agent.sh"), 0o644, None),
    (node_home / ".profile", 0o644, (node_uid, node_gid)),
    (node_home / ".bashrc", 0o644, (node_uid, node_gid)),
]
for profile, mode, owner in profile_paths:
    profile.parent.mkdir(parents=True, exist_ok=True)
    existing = profile.read_text(encoding="utf-8") if profile.exists() else ""
    if snippet not in existing:
        profile.write_text(existing + ("\n" if existing and not existing.endswith("\n") else "") + snippet, encoding="utf-8")
    os.chmod(profile, mode)
    if owner:
        os.chown(profile, owner[0], owner[1])

for item in payload["files"]:
    write_owned(Path(item["path"]), item["content"], int(item["mode"], 8))

# Write a fixed-path marker so verify:bootstrap can confirm success without
# needing to detect the user's home directory (avoids shell quoting nightmares).
Path("/etc/openclaw-agent/.bootstrapped").parent.mkdir(parents=True, exist_ok=True)
Path("/etc/openclaw-agent/.bootstrapped").touch()
