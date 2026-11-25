import hashlib
import json
import re
import stat
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZipFile


REPOSITORY = "os6/nospeaker"
ASSET = "nospeaker.zip"
RELEASE_URL = f"https://github.com/{REPOSITORY}/releases/download"
VERSION = r"(?:0|[1-9][0-9]*)(?:\.(?:0|[1-9][0-9]*)){1,2}"
METADATA = rf'^  url "{re.escape(RELEASE_URL)}/v({VERSION})/{re.escape(ASSET)}"\n  sha256 "[0-9a-f]{{64}}"$'


def archive_checksum(url, path):
    # ASVS 12.1.1, 12.3.1: Require HTTPS for both GitHub and its download redirect.
    subprocess.run([
        "curl", "--fail", "--silent", "--show-error", "--location",
        "--proto", "=https", "--proto-redir", "=https", "--tlsv1.2",
        "--connect-timeout", "15", "--max-time", "60", "--retry", "3",
        "--max-filesize", str(16 * 1024**2), "--output", str(path), url,
    ], check=True)

    # ASVS 5.2.2, 5.2.3, 5.2.5: Inspect the executable without extracting it.
    with ZipFile(path) as archive:
        entries = archive.infolist()
        if len(entries) != 1:
            raise ValueError("Expected one file in nospeaker.zip")
        entry = entries[0]
        mode = entry.external_attr >> 16
        if (entry.filename != "nospeaker" or not stat.S_ISREG(mode)
                or not mode & 0o111 or not 0 < entry.file_size <= 32 * 1024**2):
            raise ValueError("Expected a regular nospeaker executable in nospeaker.zip")
        with archive.open(entry) as executable:
            if executable.read(4) not in (b"\xca\xfe\xba\xbe", b"\xca\xfe\xba\xbf"):
                raise ValueError("Expected a universal Mach-O binary in nospeaker.zip")
        if archive.testzip() is not None:
            raise ValueError("Invalid nospeaker.zip checksum")

    # ASVS 11.4.1: Pin the downloaded release with SHA-256.
    with path.open("rb") as archive_file:
        return hashlib.file_digest(archive_file, "sha256").hexdigest()


def main():
    formula_path = Path("Formula/nospeaker.rb")
    formula = formula_path.read_text()
    metadata = re.search(METADATA, formula, re.MULTILINE)
    if metadata is None:
        raise ValueError("Could not find the NoSpeaker release URL and checksum in the formula")

    release = json.loads(subprocess.check_output([
        "gh", "api", f"repos/{REPOSITORY}/releases/latest",
    ]))
    # ASVS 1.2.2, 2.2.1: Only stable numeric versions enter the URL and formula.
    tag = re.fullmatch(rf"v({VERSION})", release["tag_name"])
    if tag is None:
        raise ValueError(f"Unexpected NoSpeaker release tag: {release['tag_name']!r}")
    version = tag[1]
    current_version = metadata[1]
    if tuple(map(int, version.split("."))) <= tuple(map(int, current_version.split("."))):
        print(f"NoSpeaker {current_version} is already packaged. Upstream reports {version}.")
        return

    url = f"{RELEASE_URL}/{tag[0]}/{ASSET}"
    assets = [asset for asset in release["assets"] if asset["name"] == ASSET]
    if len(assets) != 1 or assets[0]["state"] != "uploaded" or assets[0]["browser_download_url"] != url:
        raise ValueError(f"Expected a published {ASSET} asset for {tag[0]}")

    with TemporaryDirectory() as directory:
        checksum = archive_checksum(url, Path(directory) / ASSET)
    if assets[0]["digest"] != f"sha256:{checksum}":
        raise ValueError(f"Downloaded {ASSET} does not match the GitHub release checksum")

    updated_metadata = f'  url "{url}"\n  sha256 "{checksum}"'
    formula_path.write_text(formula[:metadata.start()] + updated_metadata + formula[metadata.end():])
    print(f"Updated Formula/nospeaker.rb to {version}.")


if __name__ == "__main__":
    main()
