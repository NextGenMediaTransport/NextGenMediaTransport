#!/usr/bin/env bash
# Rasterize SVG masters under docs/branding/assets/svg/ to PNG (and optionally JPG / ICO).
#
# Prerequisites:
#   - resvg CLI — https://github.com/linebender/resvg  (e.g. brew install resvg)
#   - ImageMagick "magick" — for --jpg and --ico (e.g. brew install imagemagick)
#
# Usage (from repo root or any cwd):
#   docs/branding/scripts/export-rasters.sh
#   docs/branding/scripts/export-rasters.sh --jpg --ico
#   docs/branding/scripts/export-rasters.sh --input docs/branding/assets/svg/marks/ngmt-meta.svg
#   docs/branding/scripts/export-rasters.sh --out-dir /tmp/ngmt-export
#
# Generated output defaults to docs/branding/assets/export/ (gitignored).

set -euo pipefail

BRANDING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SVG_DIR="${BRANDING_DIR}/assets/svg"
EXPORT_ROOT="${BRANDING_DIR}/assets/export"
SIZES=(16 32 48 64 128 256)
JPG_BG="#1c1c1e"
DO_JPG=0
DO_ICO=0
SINGLE_INPUT=""

die() { echo "error: $*" >&2; exit 1; }

usage() {
  echo "usage: $(basename "$0") [--jpg] [--ico] [--input PATH.svg] [--out-dir DIR] [--sizes \"16 32 256\"]"
  echo "  Default: all *.svg under ${SVG_DIR#/} -> PNG at multiple widths."
  echo "  --jpg   largest PNG -> JPG (alpha flattened to Studio-like ${JPG_BG})"
  echo "  --ico   16/32/48/256 PNGs -> single .ico next to PNG tree"
}

require() { command -v "$1" >/dev/null 2>&1 || die "missing '$1' in PATH (see header comments in this script)"; }

OUT_DIR="$EXPORT_ROOT"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --jpg) DO_JPG=1; shift ;;
    --ico) DO_ICO=1; shift ;;
    --input)
      [[ $# -ge 2 ]] || die "--input requires a path"
      SINGLE_INPUT="$2"
      shift 2
      ;;
    --out-dir)
      [[ $# -ge 2 ]] || die "--out-dir requires a path"
      OUT_DIR="$2"
      shift 2
      ;;
    --sizes)
      [[ $# -ge 2 ]] || die "--sizes requires a list"
      SIZES=()
      for x in $2; do SIZES+=("$x"); done
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

require resvg
if [[ "$DO_JPG" -eq 1 || "$DO_ICO" -eq 1 ]]; then
  require magick
fi

mkdir -p "$OUT_DIR/png"

FILES=()
if [[ -n "$SINGLE_INPUT" ]]; then
  [[ -f "$SINGLE_INPUT" ]] || die "not a file: $SINGLE_INPUT"
  FILES+=("$SINGLE_INPUT")
else
  while IFS= read -r line; do
    [[ -n "$line" ]] && FILES+=("$line")
  done < <(find "$SVG_DIR" -type f -name '*.svg' | LC_ALL=C sort)
fi

[[ "${#FILES[@]}" -gt 0 ]] || die "no SVG files under $SVG_DIR"

last_size="${SIZES[$((${#SIZES[@]} - 1))]}"

for svg in "${FILES[@]}"; do
  base="$(basename "$svg" .svg)"
  dest_dir="$OUT_DIR/png/$base"
  mkdir -p "$dest_dir"
  echo "png: $base -> $dest_dir/"
  for s in "${SIZES[@]}"; do
    resvg "$svg" "$dest_dir/${base}-${s}.png" -w "$s" -h "$s"
  done

  largest="$dest_dir/${base}-256.png"
  [[ -f "$largest" ]] || largest="$dest_dir/${base}-${last_size}.png"

  if [[ "$DO_JPG" -eq 1 ]]; then
    mkdir -p "$OUT_DIR/jpg"
    echo "jpg: $base (alpha flattened to $JPG_BG)"
    magick "$largest" -background "$JPG_BG" -alpha remove -alpha off \
      "$OUT_DIR/jpg/${base}.jpg"
  fi

  if [[ "$DO_ICO" -eq 1 ]]; then
    mkdir -p "$OUT_DIR/ico"
    f16="$dest_dir/${base}-16.png"
    f32="$dest_dir/${base}-32.png"
    f48="$dest_dir/${base}-48.png"
    f256="$dest_dir/${base}-256.png"
    [[ -f "$f16" && -f "$f32" && -f "$f48" && -f "$f256" ]] || die "missing expected PNG sizes for ICO: $base"
    echo "ico: $base"
    magick "$f16" "$f32" "$f48" "$f256" "$OUT_DIR/ico/${base}.ico"
  fi
done

echo "done. Output under: $OUT_DIR"
