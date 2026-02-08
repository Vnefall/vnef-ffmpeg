#!/usr/bin/env bash
set -euo pipefail

# Example LGPL-only build for Linux (VP9 via libvpx).
# Requires: build-essential, yasm/nasm, pkg-config, libvpx-dev

FFMPEG_VERSION="6.1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"
BUILD_DIR="$ROOT_DIR/build/tmp"
OUT_DIR="$ROOT_DIR/artifacts/linux"

mkdir -p "$SRC_DIR" "$BUILD_DIR" "$OUT_DIR"

TARBALL="ffmpeg-${FFMPEG_VERSION}.tar.xz"
URL="https://ffmpeg.org/releases/${TARBALL}"

cd "$SRC_DIR"
if [ ! -f "$TARBALL" ]; then
  curl -L -o "$TARBALL" "$URL"
fi

rm -rf "$BUILD_DIR/ffmpeg-${FFMPEG_VERSION}"
mkdir -p "$BUILD_DIR"

tar -xf "$TARBALL" -C "$BUILD_DIR"
cd "$BUILD_DIR/ffmpeg-${FFMPEG_VERSION}"

./configure \
  --disable-gpl \
  --disable-nonfree \
  --enable-libvpx \
  --enable-shared \
  --disable-static \
  --disable-programs \
  --enable-ffmpeg

make -j

cp -f ffmpeg "$OUT_DIR/ffmpeg"

cat > "$ROOT_DIR/build_flags.txt" <<FLAGS
./configure --disable-gpl --disable-nonfree --enable-libvpx --enable-shared --disable-static --disable-programs --enable-ffmpeg
FLAGS

cat > "$ROOT_DIR/SOURCE_URL.txt" <<SRC
$URL
SRC

echo "Built ffmpeg -> $OUT_DIR/ffmpeg"
