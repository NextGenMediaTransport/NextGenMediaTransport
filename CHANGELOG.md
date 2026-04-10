# Changelog

All notable changes to this repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
where versioning applies.

## 2026-04-10 — Phase 2: Sub-repository publish

- **ngmt-core**, **ngmt-codec**, and **ngmt-transport**: foundational Phase 2 infrastructure committed and pushed to `main` on `https://github.com/NextGenMediaTransport/` (commit message: `chore: finalize Phase 2 build standardization and infrastructure`).

## [Unreleased]

### Fixed

- **ngmt-core:** `advertiser.hpp` now includes `<cstdint>` so Linux (GCC) CI compiles discovery code.
- **ngmt-codec:** portable `VMX_DECLSPEC_ALIGN` replaces MSVC-only `__declspec(align)` in VMX sources so Linux (g++) CI builds; CMake `-fdeclspec` workaround removed.

### Added

- **Roadmap:** new [Phase 4 — Developer UI and Visibility](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md); former integrations and hardware phases renumbered to **Phase 5** and **Phase 6** ([00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md)).
- Documented **in-workspace** layout for `ngmt-core`, `ngmt-codec`, and `ngmt-transport` clones under the meta-repo root; added `.gitignore` for those nested repos. Updated [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md) and [README.md](README.md).
- MIT `LICENSE` (NextGenMediaTransport Contributors, 2026).
- GitHub Actions: `ci.yml` (matrix: Ubuntu, Windows, macOS; placeholder build) on `push` / `pull_request` to `main`.
- GitHub Actions: `docs.yml` (placeholder documentation job) on `push` to `main`.
- Baseline `README.md` and this `CHANGELOG.md`.
- Phase 1 documentation updates: upstream mapping (`libomtnet` → `ngmt-core`, `libvmx` → `ngmt-codec`), `ngmt-transport` as first-party QUIC/WAN repo; contributor guide [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md).
