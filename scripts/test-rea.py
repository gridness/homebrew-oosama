#!/usr/bin/env python3
"""Exercise the distributed CLI with Node.js, npm, and Bun absent from PATH."""

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

executable = Path(sys.argv[1]).resolve()
version = sys.argv[2]
environment = {**os.environ, "PATH": "/usr/bin:/bin"}


def run(*args, env=environment):
    result = subprocess.run(
        [str(executable), *args], env=env, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=120,
    )
    if result.returncode:
        raise RuntimeError(f"rea {args[0]} failed: {result.stderr}\n{result.stdout[:2000]}")
    return result.stdout


assert run("--version").strip() == version
assert "setup" in run("--help")
assert "brew upgrade" in run("update")

with tempfile.TemporaryDirectory(prefix="rea-standalone-test-") as directory:
    fixture = Path(directory)
    (fixture / "package.json").write_text(json.dumps({
        "name": "standalone-smoke", "version": "1.0.0", "type": "module",
    }))
    (fixture / "index.js").write_text("export function greet(name) { return 'Hello, ' + name; }\n")
    analysis = json.loads(run("analyze-javascript-application", directory, "--json"))
    assert analysis["operation"] == "analyze_javascript_application"
    assert len(analysis["normalized_result"]["graph"]["nodes"]) > 1
    assert not analysis.get("error"), analysis.get("error")

setup = json.loads(run("setup", "--dry-run", "--json", "--client", "codex"))
assert setup["status"] == "planned"
registration = next(
    action for action in setup["plannedActions"] if action["id"] == "configure_client:codex"
)
assert str(executable) in registration["detail"]
assert "npx" not in registration["detail"]

# Native PTY addons must launch processes through the embedded runtime.
pty_module = executable.parent / "app/node_modules/@lydell/node-pty"
pty_script = (
    f"const pty = require({json.dumps(str(pty_module))});"
    "const child = pty.spawn('/bin/sh', ['-c', 'printf standalone-pty'], "
    "{name: 'xterm', cols: 80, rows: 24, env: process.env});"
    "let output = ''; child.onData(data => output += data);"
    "child.onExit(event => { if (event.exitCode !== 0 || !output.includes('standalone-pty')) "
    "process.exitCode = 1; else console.log('pty ok'); });"
)
pty_test = executable.parent / "app/.pty-smoke.cjs"
try:
    pty_test.write_text(pty_script)
    assert "pty ok" in run(str(pty_test))
finally:
    pty_test.unlink(missing_ok=True)

# The MCP command must speak the protocol directly, without a runtime wrapper.
messages = [
    {"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {
        "protocolVersion": "2025-03-26", "capabilities": {},
        "clientInfo": {"name": "homebrew-smoke", "version": "1"},
    }},
    {"jsonrpc": "2.0", "method": "notifications/initialized"},
    {"jsonrpc": "2.0", "id": 2, "method": "tools/list", "params": {}},
]
response = subprocess.run(
    [str(executable), "mcp"], env=environment, text=True,
    input="".join(json.dumps(message) + "\n" for message in messages),
    stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=120, check=True,
)
replies = [json.loads(line) for line in response.stdout.splitlines() if line.strip()]
assert any(reply.get("id") == 1 and "result" in reply for reply in replies)
assert any(reply.get("id") == 2 and reply.get("result", {}).get("tools") for reply in replies)
print("Standalone CLI, analysis worker, setup registration, native PTY, and MCP passed.")
