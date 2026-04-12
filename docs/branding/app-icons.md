---
title: "NGMT app and repository icons"
status: living
---

# NGMT app and repository icons

Distinct **icons** help operators and contributors recognize binaries, repos, and docs at a glance. This document defines **ownership**, **master format**, and **shipping** rules until each product ships its own `resources/` tree.

## Canonical format: SVG

- **SVG** is the **canonical in-repo master** for logos and app marks: scalable, diff-friendly, easy to tweak in Inkscape / Figma / Illustrator.
- **Shipped** desktop artifacts still need **raster exports** at fixed sizes:
  - **macOS:** `.icns` (multiple embedded PNG sizes).
  - **Windows:** `.ico` (multi-resolution).
  - **Linux:** `.png` (e.g. 16, 32, 48, 128, 256 px for `.desktop` and window icons).
- **egui / eframe** apps in `ngmt-studio` typically display **textures** (`ColorImage`), not runtime SVG. Plan on a **build-time or release-time** step to rasterize SVG → PNG (e.g. [`resvg`](https://crates.io/crates/resvg), Inkscape CLI, or a design export) unless a future dependency adds in-app SVG rasterization.

## Inventory (per repo / surface)

| Deliverable | Repo / location | Icon intent | Master (planned path) | Shipped rasters |
|-------------|-----------------|-------------|------------------------|-----------------|
| Meta / docs | This meta-repo | NGMT umbrella / docs site | TBD under `docs/branding/` or `assets/` | Favicon PNG/SVG for any static site |
| `ngmt-core` | Protocol / C++ reference | Engine / network core | TBD in `ngmt-core` | CMake / package branding if needed |
| `ngmt-codec` | VMX / compression | Codec / waveform motif | TBD in `ngmt-codec` | Optional crate badge |
| `ngmt-transport` | QUIC / WAN | Transport / path motif | TBD in `ngmt-transport` | Optional |
| **`ngmt-generator`** | `ngmt-studio` binary | **Send** / pattern / “lab source” | TBD — **sub-mark** of Studio or standalone | `.icns` / `.ico` / `.png` in packaging |
| **`ngmt-monitor`** | `ngmt-studio` binary | **Receive** / multiview / “wall” | TBD — **sub-mark** of Studio or standalone | Same as above |
| `ngmt-studio` (workspace) | Optional umbrella | Suite / “NGMT Tools” | TBD | README / installer banner |
| `ngmt-obs-plugin` | OBS modules | OBS + NGMT bridge | TBD in `ngmt-obs-plugin` | OBS plugin asset conventions |
| `ngmt-capture` | [`NextGenMediaTransport/ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture) | Screen / window / permissions | TBD in capture repo `resources/` | PKG/MSI/deb artwork |
| `ngmt-bindings` | SDK | Developer kit | TBD | Docs + package managers |
| Unreal / Unity / Blender | Stretch plugins | Engine-specific co-branding | TBD per [Phase 5 — stretch](../project-plan/05-Phase-5-Integrations-and-Ecosystem.md) | Per marketplace guidelines |

**Shape / color discipline (guidance):** one **primary accent** consistent with `ngmt-common::theme` broadcast palette where possible; **silhouette** readable at 16×16; avoid fine text inside small marks.

## Repo of record

Until each code repo owns its `resources/` directory, **SVG masters** may live under **`docs/branding/`** in this meta-repo (this file’s directory). When an app gains a real installer, **move** or **submodule** the assets next to the binary that ships them and update this table.

## Related documents

- [Studio next steps](../project-plan/studio-next-steps.md) — backlog item **(9)** for branding pipeline work.
- [Studio ecosystem matrix](../project-plan/studio-ecosystem-matrix.md) — product surface list.
