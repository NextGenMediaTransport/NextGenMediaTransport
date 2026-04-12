# Branding assets (SVG masters)

Canonical **vector** marks and Studio **UI glyphs** live under **`svg/`**:

| Directory | Contents |
|-----------|----------|
| `svg/marks/` | App / repo marks (packaging, README, favicon sources) per [app-icons.md](../app-icons.md). |
| `svg/ui/` | Monochrome control icons intended for future **egui** textures (today the apps still use Unicode in several places). |

**Raster exports** (PNG, optional JPG/ICO) are produced with [`../scripts/export-rasters.sh`](../scripts/export-rasters.sh) into `export/` (gitignored by default).
