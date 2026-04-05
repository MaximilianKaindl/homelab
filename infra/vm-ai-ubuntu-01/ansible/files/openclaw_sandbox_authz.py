#!/usr/bin/env python3
import argparse
import base64
import json
import os
import re
import socketserver
import sys


def load_body(raw_body):
    if not raw_body:
        return {}
    if isinstance(raw_body, list):
        raw = bytes(raw_body)
    elif isinstance(raw_body, str):
        try:
            raw = base64.b64decode(raw_body)
        except Exception:
            raw = raw_body.encode("utf-8")
    else:
        raw = bytes(raw_body)
    if not raw:
        return {}
    return json.loads(raw.decode("utf-8"))


def deny(message):
    print(f"[DENY] {message}", file=sys.stderr, flush=True)
    return {"Allow": False, "Msg": message, "Err": ""}


def allow():
    return {"Allow": True, "Msg": "", "Err": ""}


class AuthzPolicy:
    def __init__(self, allowed_image_prefixes):
        self.allowed_image_prefixes = [prefix for prefix in allowed_image_prefixes if prefix]

    def evaluate_request(self, payload):
        method = payload.get("RequestMethod", "")
        uri = payload.get("RequestUri") or payload.get("RequestURI") or ""
        if method != "POST":
            return allow()
        if not re.search(r"/containers/create(?:\?|$)", uri):
            return allow()

        try:
            body = load_body(payload.get("RequestBody"))
        except Exception as exc:
            return deny(f"invalid create payload: {exc}")

        image = body.get("Image") or ""
        if self.allowed_image_prefixes and not any(image.startswith(prefix) for prefix in self.allowed_image_prefixes):
            return deny("sandbox image is not in the approved registry namespace")

        host_config = body.get("HostConfig") or {}

        if host_config.get("Privileged") is True:
            return deny("privileged containers are not allowed")

        cap_add = [str(cap).upper() for cap in (host_config.get("CapAdd") or [])]
        if cap_add:
            return deny("adding Linux capabilities is not allowed")

        if host_config.get("Devices"):
            return deny("device passthrough is not allowed")

        if host_config.get("DeviceRequests"):
            return deny("device requests are not allowed")

        if host_config.get("PidMode") == "host":
            return deny("host PID namespace is not allowed")

        if host_config.get("IpcMode") == "host":
            return deny("host IPC namespace is not allowed")

        if host_config.get("NetworkMode") == "host":
            return deny("host networking is not allowed")

        if host_config.get("UsernsMode") == "host":
            return deny("host user namespaces are not allowed")

        security_opt = [str(opt).lower() for opt in (host_config.get("SecurityOpt") or [])]
        for opt in security_opt:
            if opt in {"apparmor=unconfined", "seccomp=unconfined", "label=disable", "no-new-privileges=false"}:
                return deny(f"security option '{opt}' is not allowed")

        binds = [str(bind) for bind in (host_config.get("Binds") or [])]
        forbidden_bind_prefixes = (
            "/var/run/docker.sock",
            "/run/openclaw-sbx",
            "/run/docker.sock",
        )
        for bind in binds:
            host_path = bind.split(":", 1)[0]
            if any(host_path == prefix or host_path.startswith(prefix + "/") for prefix in forbidden_bind_prefixes):
                return deny("binding Docker control sockets into a sandbox is not allowed")

        for mount in host_config.get("Mounts") or []:
            source = str((mount or {}).get("Source", ""))
            if any(source == prefix or source.startswith(prefix + "/") for prefix in forbidden_bind_prefixes):
                return deny("mounting Docker control sockets into a sandbox is not allowed")

        return allow()


class UnixHTTPServer(socketserver.ThreadingMixIn, socketserver.UnixStreamServer):
    allow_reuse_address = True
    daemon_threads = True


class RequestHandler(socketserver.StreamRequestHandler):
    server_version = "openclaw-sandbox-authz/1.0"

    def setup(self):
        super().setup()
        self.connection.settimeout(5.0)

    def handle(self):
        request_line = self.rfile.readline().decode("utf-8", errors="replace").strip()
        if not request_line:
            return
        parts = request_line.split()
        if len(parts) != 3:
            self._send(400, {"Allow": False, "Msg": "", "Err": "bad request"})
            return
        method, path, _ = parts
        headers = {}
        content_length = 0
        while True:
            line = self.rfile.readline().decode("utf-8", errors="replace")
            if line in ("\r\n", "\n", ""):
                break
            name, _, value = line.partition(":")
            headers[name.strip().lower()] = value.strip()
        if "content-length" in headers:
            try:
                content_length = int(headers["content-length"])
            except ValueError:
                content_length = 0
        body = self.rfile.read(content_length) if content_length > 0 else b"{}"
        try:
            payload = json.loads(body.decode("utf-8"))
        except Exception:
            self._send(400, {"Allow": False, "Msg": "", "Err": "invalid json"})
            return

        if path == "/Plugin.Activate" and method == "POST":
            response = {"Implements": ["authz"]}
            self._send(200, response)
            return

        if path == "/AuthZPlugin.AuthZReq" and method == "POST":
            response = self.server.policy.evaluate_request(payload)
            self._send(200, response)
            return

        if path == "/AuthZPlugin.AuthZRes" and method == "POST":
            self._send(200, allow())
            return

        self._send(404, {"Allow": False, "Msg": "", "Err": "not found"})

    def log_message(self, fmt, *args):
        sys.stderr.write((fmt % args) + "\n")

    def _send(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        reason = {
            200: "OK",
            400: "Bad Request",
            404: "Not Found",
        }.get(status, "OK")
        response = [
            f"HTTP/1.1 {status} {reason}",
            "Content-Type: application/json",
            f"Content-Length: {len(body)}",
            "Connection: close",
            "",
            "",
        ]
        self.wfile.write("\r\n".join(response).encode("utf-8") + body)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--socket", required=True)
    parser.add_argument("--allowed-image-prefix", action="append", default=[])
    args = parser.parse_args()

    os.makedirs(os.path.dirname(args.socket), exist_ok=True)
    try:
        os.unlink(args.socket)
    except FileNotFoundError:
        pass

    server = UnixHTTPServer(args.socket, RequestHandler)
    server.policy = AuthzPolicy(args.allowed_image_prefix)
    server.serve_forever()


if __name__ == "__main__":
    main()
