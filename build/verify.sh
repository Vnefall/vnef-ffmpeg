#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(
  "$ROOT_DIR/README.md"
  "$ROOT_DIR/LICENSES/LGPL-2.1.txt"
  "$ROOT_DIR/SOURCE_URL.txt"
  "$ROOT_DIR/build_flags.txt"
  "$ROOT_DIR/build/linux.sh"
  "$ROOT_DIR/build/macos.sh"
  "$ROOT_DIR/build/windows-msys2.md"
)

missing=0
for f in "${required[@]}"; do
  if [ ! -f "$f" ]; then
    echo "Missing: $f"
    missing=1
  fi
done

if [ $missing -ne 0 ]; then
  echo "Verify failed."
  exit 1
fi

echo "Verify OK."
