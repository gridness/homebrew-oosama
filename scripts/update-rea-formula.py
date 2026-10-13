#!/usr/bin/env python3
"""Generate the formula only after all four standalone archives exist."""

import hashlib
import re
import sys
from pathlib import Path
from string import Template

version, repository, package_directory = sys.argv[1:]
if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
    raise SystemExit("Expected a stable release version")
if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
    raise SystemExit("Invalid GitHub repository")

root = Path(__file__).resolve().parent.parent
values = {"version": version, "repository": repository}
for key, platform in {
    "macos_arm": "aarch64-apple-darwin",
    "macos_intel": "x86_64-apple-darwin",
    "linux_arm": "aarch64-unknown-linux-gnu",
    "linux_intel": "x86_64-unknown-linux-gnu",
}.items():
    archive = Path(package_directory) / f"rea-v{version}-{platform}.tar.gz"
    with archive.open("rb") as stream:
        values[key + "_sha"] = hashlib.file_digest(stream, "sha256").hexdigest()

# ASVS 2.2.1: every substituted identifier has an allowlisted format or is a digest.
template = Template((root / "templates/rea.rb.in").read_text())
(root / "Formula/rea.rb").write_text(template.substitute(values))
