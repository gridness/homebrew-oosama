#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:?upstream source directory required}"
version="${2:?release version required}"
platform="${3:?target platform required}"
output_dir="${4:?output directory required}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ASVS 2.2.1: validate release identifiers before using them in paths.
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
case "$platform" in
  aarch64-apple-darwin) host=darwin-arm64 ;;
  x86_64-apple-darwin) host=darwin-x64 ;;
  aarch64-unknown-linux-gnu) host=linux-arm64 ;;
  x86_64-unknown-linux-gnu) host=linux-x64 ;;
  *) echo "Unsupported platform: $platform" >&2; exit 1 ;;
esac
test "$(node -p 'process.platform + "-" + process.arch')" = "$host"

mkdir -p "$output_dir"
output_dir="$(cd "$output_dir" && pwd)"
distribution="$(mktemp -d)"
cd "$source_dir"
test "$(jq -r '.name' package.json)" = rea-agents
test "$(jq -r '.version' package.json)" = "$version"

# The upstream toolchain runs only in CI. Homebrew installs the built archive.
export HUSKY=0
export TURBO_TELEMETRY_DISABLED=1
npm ci --ignore-scripts --no-audit --no-fund
npm run build
npm pack --ignore-scripts --loglevel error --pack-destination "$distribution"
package="${distribution}/rea-agents-${version}.tgz"

# Keep runtime modules and bridge files on disk so upstream worker processes,
# native addons, and external analysis engines retain their original paths.
npm install --prefix "${distribution}/app" --omit=dev --ignore-scripts \
  --no-audit --no-fund "$package"
cp LICENSE "${distribution}/LICENSE"

# Embed the compatible runtime in the Rea executable. The installed formula
# never invokes npm or requires a separately installed Node.js executable.
node_executable="$(node -p 'process.execPath')"
cp "$node_executable" "${distribution}/rea"
cp "$(dirname "$(dirname "$node_executable")")/LICENSE" "${distribution}/RUNTIME_LICENSE"
jq -n --arg main "${script_dir}/rea-launcher.cjs" \
  --arg output "${distribution}/sea.blob" \
  '{main: $main, output: $output, disableExperimentalSEAWarning: true, execArgvExtension: "cli"}' \
  > "${distribution}/sea-config.json"
node --experimental-sea-config "${distribution}/sea-config.json"
npm install --prefix "${distribution}/build-tools" --ignore-scripts \
  --no-audit --no-fund postject@1.0.0-alpha.6

inject_args=(--sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2)
if [[ "$host" == darwin-* ]]; then
  codesign --remove-signature "${distribution}/rea"
  inject_args+=(--macho-segment-name NODE_SEA)
fi
"${distribution}/build-tools/node_modules/.bin/postject" \
  "${distribution}/rea" NODE_SEA_BLOB "${distribution}/sea.blob" "${inject_args[@]}"
if [[ "$host" == darwin-* ]]; then
  codesign --sign - "${distribution}/rea"
fi

jq -n --arg version "$version" --arg platform "$platform" \
  --arg source_sha "$(git rev-parse HEAD)" --arg runtime_version "$(node --version)" \
  '{version: $version, platform: $platform, source_sha: $source_sha, runtime_version: $runtime_version}' \
  > "${distribution}/manifest.json"

python3 "${script_dir}/test-rea.py" "${distribution}/rea" "$version"

archive="${output_dir}/rea-v${version}-${platform}.tar.gz"
tar -czf "$archive" -C "$distribution" rea app manifest.json LICENSE RUNTIME_LICENSE
echo "Built $archive"
