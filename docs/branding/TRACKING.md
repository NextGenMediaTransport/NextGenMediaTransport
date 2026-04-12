# Branding work — GitHub tracking

Progress for **SVG masters**, **raster exports**, and **packaging** follow-ups is tracked on GitHub: [NextGenMediaTransport/NextGenMediaTransport#7](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/7).

In-repo spec: [app-icons.md](./app-icons.md). Masters live under **`docs/branding/assets/svg/`**.

## Checklist (keep in sync with the GitHub issue)

- [ ] Review **`docs/branding/assets/svg/marks/`** (11 marks): silhouette at 16×16, accent vs `ngmt-common::theme` **ACCENT** rgb(10, 132, 255).
- [ ] Review **`docs/branding/assets/svg/ui/`** (9 glyphs): monochrome / tint-friendly for egui.
- [ ] Run **`docs/branding/scripts/export-rasters.sh`** (`resvg`); spot-check PNGs under `docs/branding/assets/export/png/`.
- [ ] Optional: **`--jpg --ico`** with ImageMagick `magick` for installer artifacts.
- [ ] Update [app-icons.md](./app-icons.md) **Master** column if any paths or filenames change.
- [ ] Follow-up (separate issue on `ngmt-studio` if needed): embed PNG textures or build-time rasterization for in-app buttons.
