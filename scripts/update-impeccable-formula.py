import hashlib
import json
import re
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory


REPOSITORY = "pbakaus/impeccable"
RELEASE_URL = f"https://github.com/{REPOSITORY}/releases/download"
FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "impeccable.rb"
VERSION = r"(?:0|[1-9][0-9]*)(?:\.(?:0|[1-9][0-9]*)){2}"
TAG = re.compile(rf"engine-v{VERSION}")
PLATFORMS = {"macos": "darwin", "linux": "linux"}
ARCHITECTURES = {"arm": "arm64", "intel": "x64"}


def version_key(version):
    return tuple(map(int, version.split(".")))


def latest_engine_release():
    pages = json.loads(subprocess.check_output([
        "gh", "api", "--paginate", "--slurp", f"repos/{REPOSITORY}/releases?per_page=100",
    ]))
    # ASVS 1.2.2, 2.2.1: Only stable engine tags can become URL path components.
    releases = [
        release for page in pages for release in page
        if not release["draft"] and not release["prerelease"] and TAG.fullmatch(release["tag_name"])
    ]
    if not releases:
        raise ValueError("GitHub returned no stable Impeccable engine releases")
    return max(releases, key=lambda release: version_key(release["tag_name"].removeprefix("engine-v")))


def verify_asset(asset, tag, directory):
    name = asset["name"]
    url = f"{RELEASE_URL}/{tag}/{name}"
    digest = re.fullmatch(r"sha256:([a-f0-9]{64})", asset.get("digest") or "")
    size = asset["size"]
    if asset["state"] != "uploaded" or asset["browser_download_url"] != url or not digest or size <= 0:
        raise ValueError(f"Expected a published {name} binary with a SHA-256 digest for {tag}")

    path = directory / name
    # ASVS 12.1.1: Require HTTPS for the release URL and download redirects.
    subprocess.run([
        "curl", "--fail", "--silent", "--show-error", "--location",
        "--proto", "=https", "--proto-redir", "=https", "--tlsv1.2",
        "--connect-timeout", "15", "--max-time", "120", "--retry", "3",
        "--max-filesize", str(size), "--output", str(path), url,
    ], check=True)
    # ASVS 11.4.1: Verify the downloaded binary before pinning its digest.
    with path.open("rb") as binary:
        checksum = hashlib.file_digest(binary, "sha256").hexdigest()
    if path.stat().st_size != size or checksum != digest[1]:
        raise ValueError(f"Downloaded {name} does not match GitHub's release metadata")
    return checksum


def render_formula(version, checksums):
    platform_blocks = []
    for platform, upstream_os in PLATFORMS.items():
        lines = [f"  on_{platform} do"]
        for architecture, upstream_arch in ARCHITECTURES.items():
            name = f"impeccable-{upstream_os}-{upstream_arch}"
            url = f"{RELEASE_URL}/engine-v{version}/{name}"
            lines.extend([
                f"    on_{architecture} do",
                f'      url "{url}", using: :nounzip',
                f'      sha256 "{checksums[name]}"',
                "    end",
            ])
        lines.append("  end")
        platform_blocks.append("\n".join(lines))

    sources = "\n\n".join(platform_blocks)
    return f'''class Impeccable < Formula
  desc "Command-line engine for the Impeccable design skill"
  homepage "https://impeccable.style/"
  version "{version}"
  license "Apache-2.0"

{sources}

  def install
    executable = File.basename(stable.url)
    chmod 0755, executable
    bin.install executable => "impeccable"
  end

  test do
    assert_equal "impeccable-engine #{{version}}\\n", shell_output("#{{bin}}/impeccable engine-probe")
  end
end
'''


def main():
    release = latest_engine_release()
    tag = release["tag_name"]
    version = tag.removeprefix("engine-v")
    if FORMULA.exists():
        current = re.search(rf'^  version "({VERSION})"$', FORMULA.read_text(), re.MULTILINE)
        if current is None:
            raise ValueError(f"Could not find the engine version in {FORMULA.name}")
        if version_key(version) <= version_key(current[1]):
            print(f"Impeccable {current[1]} is already packaged. Upstream reports {version}.")
            return

    assets = {asset["name"]: asset for asset in release["assets"]}
    names = [f"impeccable-{os}-{arch}" for os in PLATFORMS.values() for arch in ARCHITECTURES.values()]
    missing = set(names) - assets.keys()
    if missing:
        raise ValueError(f"{tag} is missing binaries: {', '.join(sorted(missing))}")

    with TemporaryDirectory(prefix=".impeccable-", dir=FORMULA.parent) as temp:
        directory = Path(temp)
        checksums = {name: verify_asset(assets[name], tag, directory) for name in names}
        generated = directory / FORMULA.name
        generated.write_text(render_formula(version, checksums), encoding="utf-8")
        generated.replace(FORMULA)
    print(f"Updated Formula/{FORMULA.name} to {version}.")


if __name__ == "__main__":
    main()
