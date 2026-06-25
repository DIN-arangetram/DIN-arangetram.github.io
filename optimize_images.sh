#!/usr/bin/env bash
set -euo pipefail

# Convert all .jpg/.JPG/.jpeg/.JPEG files in assets to .webp, preserving name and handling spaces.
# Scale to max width 1200px, preserve aspect ratio, use decent quality for web.

shopt -s nullglob
cd "$(dirname "$0")"

for f in assets/*.[jJ][pP][gG] assets/*.[jJ][pP][eE][gG]; do
  [ -f "$f" ] || continue
  base=$(basename "$f")
  name="${base%.*}"
  out="assets/${name}.webp"
  echo "Converting: '$f' -> '$out'"
  if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -nostdin -y -i "$f" -vf "scale='min(1200,iw)':'-2'" -compression_level 6 -q:v 80 -pix_fmt yuv420p "$out"
  else
    echo "ERROR: ffmpeg not found in PATH" >&2
    exit 2
  fi
done

echo "Conversion complete."
