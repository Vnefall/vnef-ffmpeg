# vnef-ffmpeg

LGPL-only FFmpeg build scripts and release artifacts for Vnefall tooling.

## Goals
- Provide **LGPL-only** ffmpeg binaries (no GPL / nonfree).
- Keep build flags + source links for compliance.
- Make vnef-tools auto-detect bundled ffmpeg to reduce user friction.

## Layout
```
build/
  linux.sh
  macos.sh
  windows-msys2.md
artifacts/
  linux/
  macos/
  windows/
LICENSES/
  LGPL-2.1.txt
SOURCE_URL.txt
build_flags.txt
```

## Usage (Linux/macOS)
1. Run the build script for your OS.
2. Copy the resulting `ffmpeg` into `artifacts/<os>/`.
3. Update `build_flags.txt` and `SOURCE_URL.txt`.

## Compliance
- Keep the **exact source** used for the build.
- Keep the **exact configure flags**.
- Ship the LGPL license text.

See `LICENSES/LGPL-2.1.txt` and `SOURCE_URL.txt`.
