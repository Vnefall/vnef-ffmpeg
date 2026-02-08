#!/usr/bin/env bash
set -euo pipefail

# Example LGPL-only build for Linux (VP9 via libvpx).
# Requires: build-essential, yasm/nasm, pkg-config, libvpx-dev

FFMPEG_VERSION="6.1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"
BUILD_DIR="$ROOT_DIR/build/tmp"
OUT_DIR="$ROOT_DIR/artifacts/linux"
PREFIX="/usr"

mkdir -p "$SRC_DIR" "$BUILD_DIR" "$OUT_DIR/bin" "$OUT_DIR/lib"

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
  --enable-ffmpeg \
  --prefix="$PREFIX"

make -j

# Stage install so we can collect binaries + shared libs.
STAGE="$OUT_DIR/stage"
rm -rf "$STAGE"
make install DESTDIR="$STAGE"

BIN_SRC="$STAGE$PREFIX/bin/ffmpeg"
LIB_SRC="$STAGE$PREFIX/lib"

cp -f "$BIN_SRC" "$OUT_DIR/bin/ffmpeg"

# Copy FFmpeg shared libs
cp -a "$LIB_SRC"/libav*.so* "$OUT_DIR/lib/" 2>/dev/null || true
cp -a "$LIB_SRC"/libsw*.so* "$OUT_DIR/lib/" 2>/dev/null || true
cp -a "$LIB_SRC"/libpostproc*.so* "$OUT_DIR/lib/" 2>/dev/null || true

# Best-effort: copy libvpx if present on the system
if ldconfig -p | grep -q "libvpx"; then
  LIBVPX_PATH=$(ldconfig -p | awk '/libvpx.so/{print $NF; exit}')
  if [ -n "${LIBVPX_PATH:-}" ] && [ -f "$LIBVPX_PATH" ]; then
    cp -a "$LIBVPX_PATH" "$OUT_DIR/lib/" || true
  fi
fi

cat > "$ROOT_DIR/build_flags.txt" <<FLAGS
./configure --disable-gpl --disable-nonfree --enable-libvpx --enable-shared --disable-static --disable-programs --enable-ffmpeg --prefix=$PREFIX
FLAGS

cat > "$ROOT_DIR/SOURCE_URL.txt" <<SRC
$URL
SRC

echo "Built ffmpeg -> $OUT_DIR/bin/ffmpeg"
