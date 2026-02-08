# Windows (MSYS2/MinGW) Build Notes

This is a minimal path for an **LGPL-only** ffmpeg build on Windows.

1. Install MSYS2 and open the **MSYS2 MinGW 64-bit** shell.
2. Install deps:
   - `pacman -S --needed base-devel mingw-w64-x86_64-toolchain`\
     `mingw-w64-x86_64-yasm mingw-w64-x86_64-nasm`\
     `mingw-w64-x86_64-pkg-config mingw-w64-x86_64-libvpx`
3. Download FFmpeg source:
   - `curl -L -o ffmpeg.tar.xz https://ffmpeg.org/releases/ffmpeg-6.1.tar.xz`
   - `tar -xf ffmpeg.tar.xz`
4. Configure (LGPL-only):
   - `./configure --disable-gpl --disable-nonfree --enable-libvpx --enable-shared --disable-static --disable-programs --enable-ffmpeg`
5. Build:
   - `make -j`
6. Copy `ffmpeg.exe` to `artifacts/windows/`.

Update `build_flags.txt` and `SOURCE_URL.txt` afterwards.
