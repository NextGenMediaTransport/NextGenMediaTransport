# Branding work — GitHub tracking

Progress for **SVG masters**, **raster exports**, and **packaging** follow-ups is tracked on GitHub: [NextGenMediaTransport/NextGenMediaTransport#7](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/7). **Gap follow-ups filed:** [#10](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/10)–[#14](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/14) (see [github-gap-followups.md](./github-gap-followups.md)).

In-repo spec: [app-icons.md](./app-icons.md). Masters live under **`docs/branding/assets/svg/`**.

## Checklist (keep in sync with the GitHub issue)

- [ ] Review **`docs/branding/assets/svg/marks/`** (11 marks): silhouette at 16×16, accent vs `ngmt-common::theme` **ACCENT** rgb(10, 132, 255).
- [ ] Review **`docs/branding/assets/svg/ui/`** (9 glyphs): monochrome / tint-friendly for egui.
- [ ] Run **`docs/branding/scripts/export-rasters.sh`** (`resvg`); spot-check PNGs under `docs/branding/assets/export/png/` (meta gitignored). **Leaf repos** keep committed **`branding/export/`** rasters per [app-icons.md](./app-icons.md) policy.
- [ ] Optional: **`--jpg --ico`** with ImageMagick `magick` for installer artifacts.
- [ ] Update [app-icons.md](./app-icons.md) **Master** column if any paths or filenames change.
- [x] Follow-up: Studio in-app buttons use vendored PNG textures (`ngmt-studio/branding/export/ui/`); see [github-gap-followups.md](./github-gap-followups.md) for optional **`ui-volume`** and packaging rasters.
