#!/usr/bin/env bash
set -euo pipefail

# Example LGPL-only build for macOS (VP9 via libvpx).
# Requires: Xcode CLT, pkg-config, nasm/yasm, libvpx (brew install libvpx)

FFMPEG_VERSION="6.1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"
BUILD_DIR="$ROOT_DIR/build/tmp"
OUT_DIR="$ROOT_DIR/artifacts/macos"
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

STAGE="$OUT_DIR/stage"
rm -rf "$STAGE"
make install DESTDIR="$STAGE"

BIN_SRC="$STAGE$PREFIX/bin/ffmpeg"
LIB_SRC="$STAGE$PREFIX/lib"

cp -f "$BIN_SRC" "$OUT_DIR/bin/ffmpeg"

cp -a "$LIB_SRC"/libav*.dylib "$OUT_DIR/lib/" 2>/dev/null || true
cp -a "$LIB_SRC"/libsw*.dylib "$OUT_DIR/lib/" 2>/dev/null || true
cp -a "$LIB_SRC"/libpostproc*.dylib "$OUT_DIR/lib/" 2>/dev/null || true

cat > "$ROOT_DIR/build_flags.txt" <<FLAGS
./configure --disable-gpl --disable-nonfree --enable-libvpx --enable-shared --disable-static --disable-programs --enable-ffmpeg --prefix=$PREFIX
FLAGS

cat > "$ROOT_DIR/SOURCE_URL.txt" <<SRC
$URL
SRC

echo "Built ffmpeg -> $OUT_DIR/bin/ffmpeg"
