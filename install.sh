#!/bin/sh
set -eu

repository="${PPS_RELEASE_REPOSITORY:-PROJECT-PS/PPS-CLI}"
install_dir="${PPS_INSTALL_DIR:-$HOME/.local/bin}"
version="${PPS_VERSION:-}"

fail() {
  printf 'pps installer: %s\n' "$*" >&2
  exit 1
}

command -v curl >/dev/null 2>&1 || fail "curl is required"
command -v tar >/dev/null 2>&1 || fail "tar is required"

case "$(uname -s)" in
  Linux) os="linux" ;;
  Darwin) os="darwin" ;;
  *) fail "unsupported operating system: $(uname -s)" ;;
esac

case "$(uname -m)" in
  x86_64|amd64) arch="amd64" ;;
  arm64|aarch64) arch="arm64" ;;
  *) fail "unsupported CPU architecture: $(uname -m)" ;;
esac

if [ -z "$version" ]; then
  latest_url=$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$repository/releases/latest") || fail "could not resolve the latest release"
  tag=${latest_url##*/}
  version=${tag#v}
fi

printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || fail "invalid version: $version"

archive="pps_${version}_${os}_${arch}.tar.gz"
base_url="https://github.com/$repository/releases/download/v${version}"
tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t pps-install) || fail "could not create a temporary directory"
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

printf 'Downloading PPS CLI %s for %s/%s...\n' "$version" "$os" "$arch"
curl -fL --retry 3 -o "$tmp_dir/$archive" "$base_url/$archive" || fail "could not download $archive"
curl -fL --retry 3 -o "$tmp_dir/checksums.txt" "$base_url/checksums.txt" || fail "could not download checksums.txt"

expected=$(awk -v file="$archive" '$2 == file { print $1 }' "$tmp_dir/checksums.txt")
[ -n "$expected" ] || fail "release checksum for $archive is missing"
if command -v sha256sum >/dev/null 2>&1; then
  actual=$(sha256sum "$tmp_dir/$archive" | awk '{ print $1 }')
elif command -v shasum >/dev/null 2>&1; then
  actual=$(shasum -a 256 "$tmp_dir/$archive" | awk '{ print $1 }')
else
  fail "sha256sum or shasum is required"
fi
[ "$expected" = "$actual" ] || fail "SHA-256 verification failed"

mkdir -p "$tmp_dir/extract" "$install_dir"
tar -xzf "$tmp_dir/$archive" -C "$tmp_dir/extract"
[ -f "$tmp_dir/extract/pps" ] || fail "the release archive does not contain pps"
install -m 0755 "$tmp_dir/extract/pps" "$install_dir/pps"

printf 'Installed PPS CLI %s to %s/pps\n' "$version" "$install_dir"
case ":$PATH:" in
  *:"$install_dir":*) ;;
  *) printf 'Add %s to PATH before running pps.\n' "$install_dir" ;;
esac
