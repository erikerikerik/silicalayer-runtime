#!/bin/sh
set -eu

[ "$(uname -s)" = Darwin ] && [ "$(uname -m)" = arm64 ] || {
  printf '%s\n' 'This runtime is built only on Apple Silicon macOS.' >&2
  exit 1
}
command -v curl >/dev/null
command -v cargo >/dev/null

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
BUILD=$(mktemp -d "${TMPDIR:-/tmp}/silicalayer-runtime.XXXXXX")
trap 'rm -rf "$BUILD"' EXIT HUP INT TERM
PYTHON_ARCHIVE="$BUILD/python.tar.gz"
COMFY_ARCHIVE="$BUILD/comfy.tar.gz"
STAGE="$BUILD/stage"
FLAT="$BUILD/flat"
OUTPUT=${1:-"$ROOT/SilicaLayer-ComfyUI-0.43.0-macos-arm64.7z"}

PYTHON_URL='https://github.com/astral-sh/python-build-standalone/releases/download/20260901/cpython-3.12.14%2B20260901-aarch64-apple-darwin-install_only.tar.gz'
PYTHON_SHA='3ee3ee547cedfeb7c2b16b2b7156039f7b470bb8f857e226fd3d2eb11db83c76'
COMFY_URL='https://github.com/Comfy-Org/ComfyUI/archive/426f5eea52a7ece1dd599fff4cb6cd1f352ddd24.tar.gz'
COMFY_SHA='96c0680fa97ae0f6a0cb23ae8f24347e076eb535b9b3292efcb4a98d72d67ce1'

fetch() {
  url=$1 expected=$2 destination=$3
  curl -fL --retry 3 -o "$destination" "$url"
  actual=$(shasum -a 256 "$destination" | awk '{print $1}')
  [ "$actual" = "$expected" ] || {
    printf 'Checksum mismatch for %s\n' "$url" >&2
    exit 1
  }
}

mkdir -p "$STAGE/ComfyUI" "$FLAT"
fetch "$PYTHON_URL" "$PYTHON_SHA" "$PYTHON_ARCHIVE"
fetch "$COMFY_URL" "$COMFY_SHA" "$COMFY_ARCHIVE"
tar -xzf "$PYTHON_ARCHIVE" -C "$STAGE"
tar -xzf "$COMFY_ARCHIVE" --strip-components=1 -C "$STAGE/ComfyUI"
"$STAGE/python/bin/python3" -m pip install --disable-pip-version-check --no-input --require-hashes -r "$ROOT/requirements-macos-arm64.lock"
"$STAGE/python/bin/python3" -m pip check

# The secure application unpacker refuses links. Dereference the standalone
# distribution's small set of internal aliases into regular files.
cp -RL "$STAGE/." "$FLAT/"
[ "$(find "$FLAT" -type l | wc -l | tr -d ' ')" = 0 ]

cargo run --quiet --release --manifest-path "$ROOT/archiver/Cargo.toml" -- "$FLAT" "$OUTPUT"
printf 'archive=%s\nsha256=%s\nbytes=%s\n' \
  "$OUTPUT" \
  "$(shasum -a 256 "$OUTPUT" | awk '{print $1}')" \
  "$(stat -f '%z' "$OUTPUT")"
