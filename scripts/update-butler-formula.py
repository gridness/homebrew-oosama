import hashlib
import re
import stat
import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZipFile


BASE_URL = "https://broth.itch.zone/butler"
PLATFORMS = {
    "darwin-arm64": "libc7zip.dylib",
    "darwin-amd64": "libc7zip.dylib",
    "linux-arm64": "libc7zip.so",
    "linux-amd64": "libc7zip.so",
}
VERSION_PATTERN = r"(?:0|[1-9][0-9]*)(?:\.(?:0|[1-9][0-9]*)){2}"


def download(url, *options):
    # ASVS 12.1.1, 12.3.1: Broth redirects to its CDN over HTTPS.
    return subprocess.check_output([
        "curl", "--fail", "--silent", "--show-error", "--location",
        "--proto", "=https", "--proto-redir", "=https", "--tlsv1.2",
        "--connect-timeout", "15", "--max-time", "60", "--retry", "3",
        *options, url,
    ])


def latest_version(platform):
    version = download(f"{BASE_URL}/{platform}/LATEST", "--max-filesize", "64").decode().strip()
    # ASVS 1.2.2, 2.2.1: Only stable numeric versions enter URLs and formula code.
    if not re.fullmatch(VERSION_PATTERN, version):
        raise ValueError(f"Unexpected Butler version for {platform}: {version!r}")
    return version


def archive_checksum(platform, library, version, path):
    download(f"{BASE_URL}/{platform}/{version}/archive/default",
             "--max-filesize", str(64 * 1024**2), "--output", str(path))
    # ASVS 5.2.2, 5.2.3, 5.2.5: Validate the ZIP without extracting its contents.
    with ZipFile(path) as archive:
        entries = archive.infolist()
        if (sorted(entry.filename for entry in entries) != ["7z.so", "butler", library]
                or any(not stat.S_ISREG(entry.external_attr >> 16) for entry in entries)
                or sum(entry.file_size for entry in entries) > 128 * 1024**2
                or archive.testzip() is not None):
            raise ValueError(f"Unexpected Butler archive for {platform} {version}")

    # ASVS 11.4.1: Pin the exact upstream archive with SHA-256.
    with path.open("rb") as archive_file:
        return hashlib.file_digest(archive_file, "sha256").hexdigest()


def main():
    formula_path = Path("Formula/butler.rb")
    formula = formula_path.read_text()
    version_line = re.search(rf'^  version "({VERSION_PATTERN})"$', formula, re.MULTILINE)
    if version_line is None:
        raise ValueError("Could not read the version from Formula/butler.rb")

    versions = {platform: latest_version(platform) for platform in PLATFORMS}
    if len(set(versions.values())) != 1:
        print(f"Waiting for the stable Butler channels to agree: {versions}")
        return

    version = versions["darwin-arm64"]
    current_version = version_line[1]
    if tuple(map(int, version.split("."))) <= tuple(map(int, current_version.split("."))):
        print(f"Butler {current_version} is already packaged. Upstream reports {version}.")
        return

    formula = formula.replace(version_line[0], f'  version "{version}"', 1)
    with TemporaryDirectory() as directory:
        for platform, library in PLATFORMS.items():
            path = Path(directory) / f"{platform}.zip"
            checksum = archive_checksum(platform, library, version, path)
            url = re.escape(f"{BASE_URL}/{platform}/#{{version}}/archive/default")
            pattern = rf'^( +url "{url}"\n +sha256 ")[0-9a-f]{{64}}("$)'
            formula, count = re.subn(pattern, rf"\g<1>{checksum}\2", formula, flags=re.MULTILINE)
            if count != 1:
                raise ValueError(f"Could not find one checksum for {platform} in Formula/butler.rb")

    formula_path.write_text(formula)
    print(f"Updated Formula/butler.rb to {version}.")


if __name__ == "__main__":
    main()
