---
title: "Program parallel tracks (scheduling)"
status: living
---

# Parallel work without starving v1.0 blockers

**P0 (gate **1.0.0**):** Four Pillars in [version-1-release-status.md](version-1-release-status.md) — Phase **3** TLS / discovery / impairment audit, Phase **5** OBS input + real media path, release hygiene [meta#6](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/6).

**High-leverage parallel (not a pillar substitute):**

- **`ngmt-capture`** — [ngmt-capture-spec.md](ngmt-capture-spec.md), [studio-next-steps.md](studio-next-steps.md). Staff **after** weekly P0 burn-down or in a **second** engineer slot.
- **Branding / packaging** — meta [#7](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/7)–[#14](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/14); batch raster export and CI **when** installers exist; do not block transport/OBS merges.

**Adoption / polish (P2, `v1.0-adoption` milestone):**

- Meta [#2](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/2) (meta build, devcontainer, CONTRIBUTING), [#5](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/5) (telemetry export, extra tests), [#4](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/4) (Phase 6 hardware backlog).

**Rule of thumb:** if a week’s P0 issues are **not** moving, **pause** parallel polish until OBS + TLS + impairment rows progress.
