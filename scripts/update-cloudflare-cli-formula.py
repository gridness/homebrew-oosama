import base64
import hashlib
import json
import re
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory


REGISTRY = "https://registry.npmjs.org"
PACKAGE_URL = f"{REGISTRY}/cf/-/cf"
FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "cloudflare-cli.rb"
VERSION = r"(?:0|[1-9][0-9]*)(?:\.(?:0|[1-9][0-9]*)){2}(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?"
METADATA = re.compile(
    rf'^  url "{re.escape(PACKAGE_URL)}-({VERSION})\.tgz"\n'
    r'  version "\1"\n  sha256 "[a-f0-9]{64}"$',
    re.MULTILINE,
)


def download(url, max_bytes):
    # ASVS 12.1.1, 13.2.4: Use HTTPS on the npm registry and reject redirects.
    return subprocess.check_output([
        "curl", "--fail", "--silent", "--show-error", "--proto", "=https", "--tlsv1.2",
        "--connect-timeout", "10", "--max-time", "60", "--retry", "3",
        "--max-filesize", str(max_bytes), url,
    ])


def main():
    formula = FORMULA.read_text(encoding="utf-8")
    current = METADATA.search(formula)
    if current is None:
        raise ValueError(f"Could not find the npm URL, version, and checksum in {FORMULA.name}")

    release = json.loads(download(f"{REGISTRY}/cf/latest", 1024**2))
    version = release["version"]
    # ASVS 1.2.2, 2.2.1: Only Cloudflare's package and a version string can update the formula.
    if (release["name"] != "cf" or release["repository"]["url"] != "https://github.com/cloudflare/cf.git"
            or not re.fullmatch(VERSION, version)):
        raise ValueError("Expected a release of Cloudflare's cf package")
    url = f"{PACKAGE_URL}-{version}.tgz"
    if release["dist"]["tarball"] != url:
        raise ValueError(f"Unexpected npm tarball URL for cf {version}")
    if version == current[1]:
        print(f"Cloudflare CLI {version} is already packaged.")
        return

    archive = download(url, 128 * 1024**2)
    # ASVS 11.4.1: Verify npm's SHA-512 integrity value before pinning SHA-256 for Homebrew.
    integrity = base64.b64encode(hashlib.sha512(archive).digest()).decode("ascii")
    if release["dist"]["integrity"] != f"sha512-{integrity}":
        raise ValueError(f"Downloaded cf {version} does not match npm's integrity metadata")
    checksum = hashlib.sha256(archive).hexdigest()

    metadata = f'  url "{url}"\n  version "{version}"\n  sha256 "{checksum}"'
    updated = formula[:current.start()] + metadata + formula[current.end():]
    with TemporaryDirectory(dir=FORMULA.parent) as directory:
        generated = Path(directory) / FORMULA.name
        generated.write_text(updated, encoding="utf-8")
        generated.replace(FORMULA)
    print(f"Updated Formula/{FORMULA.name} to {version}.")


if __name__ == "__main__":
    main()
