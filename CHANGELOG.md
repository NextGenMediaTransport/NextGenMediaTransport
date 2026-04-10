# Changelog

All notable changes to this repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
where versioning applies.

## 2026-04-10 — Phase 2: Sub-repository publish

- **ngmt-core**, **ngmt-codec**, and **ngmt-transport**: foundational Phase 2 infrastructure committed and pushed to `main` on `https://github.com/NextGenMediaTransport/` (commit message: `chore: finalize Phase 2 build standardization and infrastructure`).

## [Unreleased]

### Changed

- **Roadmap / v1.0:** [version-1-release-status.md](docs/project-plan/version-1-release-status.md) now defines **v1.0** as the **Four Pillars** (real media path, OBS P0, TLS policy, impairment audit at 2/5/10% loss); [00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md) adds a **v1.0 baseline** diagram; [Phase 3](docs/project-plan/03-Phase-3-Core-Features-Discovery-and-WAN.md) and [Phase 5](docs/project-plan/05-Phase-5-Integrations-and-Ecosystem.md) label **v1.0 blockers** and **Phase 5b** (post-v1.0 SDKs). **Stub/synthetic** lab payloads must be replaced by **ngmt-codec** on the primary path for v1.0; **README** and Phase 4 plan cross-link the audit doc.
- **README:** Reframed as the **meta-repository** (planning + cross-cutting docs); **Continuous integration** section now distinguishes **per-repository CI** from the **meta smoke workflow** ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)).
- **Phase 3 / Phase 4 docs:** [Phase 4 plan](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md) marked **completed**; [Phase 3 plan](docs/project-plan/03-Phase-3-Core-Features-Discovery-and-WAN.md) DoD reconciled with shipped Rust/C++ scope (including **STUN/TURN** not implemented yet); [impairment results log](docs/testing/impairment-results.md) added for auditable lab runs.
- **Release planning:** [version-1-release-status.md](docs/project-plan/version-1-release-status.md) — per-phase snapshot and explicit **Version 1.0** gap list (linked from [Master Roadmap](docs/project-plan/00-Master-Roadmap.md) and [README](README.md)).
- **Documentation:** Phase 4 plan and meta README now **explicitly state** that Generator + Monitor are **lab / debug tooling**, not a **real-world** encode→transport→decode pipeline (stub payloads; Monitor preview is **locally drawn**, not decoded video).
- **`ngmt-monitor`:** Receiver stays on the **2×2 grid** when connecting (no auto-solo). Slot **preview** renders **SMPTE bars** when datagrams arrive (mirrors Generator; wire payload is still `frame=N` text).

### Added

- **Meta CI:** workflow clones public `ngmt-transport`, `ngmt-studio`, and `ngmt-core` and runs `cargo test`, `cargo check` (with Linux GUI deps), **CMake** build, and optional **FFI smoke** (`ngmt_transport_ffi_smoke`) so the documented sibling layout is validated on push.
- **`ngmt-core`:** optional CMake target `ngmt_transport_ffi_smoke` (`-DNGMT_ENABLE_TRANSPORT_FFI_SMOKE=ON`) and [`docs/discovery-status.md`](ngmt-core/docs/discovery-status.md) (mDNS: Rust Studio vs C++ facade).
- **`ngmt-transport`:** `cpp_compat` in `cbindgen.toml` so `ngmt_transport.h` wraps C++ in `extern "C"`; integration test `tests/loopback_connect.rs`; **ALPN `ngmt`** on client configs so dial/accept handshakes match the server.
- **`ngmt-studio` CI:** **Windows** (`windows-latest`) added to the matrix alongside Ubuntu and macOS.
- **`ngmt-generator` / `ngmt-monitor`:** stderr debug tracing (`[ngmt-generator]` / `[ngmt-monitor]` prefixes) for UI interactions, QUIC worker phases, and **before/after `JoinHandle::join()`** on stream stop — run from a terminal to diagnose UI freezes and connection issues.
- **Studio:** `TransportRuntime::close_endpoint()` is invoked from the UI thread before joining stream workers so **Stop** does not hang while the worker is still in `accept` / `connect` (Quinn `block_on`).
- **Phase 4 — `ngmt-studio`:** new sibling repository (Generator, Monitor, common crate) with **egui** UI, mDNS `_ngmt._udp`, QUIC dial/accept integration via **`ngmt-transport`** Rust API. Documented in [docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md), [README.md](README.md), and [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md). Meta-repo `.gitignore` includes `/ngmt-studio/`.
- **`ngmt-transport`:** `app_api` module and session helpers (`dial`, `accept_one`, `local_addr`) for Studio tools.

### Fixed

- **ngmt-core:** `advertiser.hpp` now includes `<cstdint>` so Linux (GCC) CI compiles discovery code.
- **ngmt-codec:** portable `VMX_DECLSPEC_ALIGN` replaces MSVC-only `__declspec(align)` in VMX sources so Linux (g++) CI builds; CMake `-fdeclspec` workaround removed.
- **ngmt-codec:** CMake adds `-msse4.2`, `-mbmi`, and `-mlzcnt` for GCC/Clang x86_64 VMX sources so Ubuntu CI compiles SSE4.1, BMI, and LZCNT intrinsics (default `-march` is too old).

### Added

- **Roadmap:** new [Phase 4 — Developer UI and Visibility](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md); former integrations and hardware phases renumbered to **Phase 5** and **Phase 6** ([00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md)).
- Documented **in-workspace** layout for `ngmt-core`, `ngmt-codec`, and `ngmt-transport` clones under the meta-repo root; added `.gitignore` for those nested repos. Updated [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md) and [README.md](README.md).
- MIT `LICENSE` (NextGenMediaTransport Contributors, 2026).
- GitHub Actions: `docs.yml` (placeholder documentation job) on `push` to `main`.
- Baseline `README.md` and this `CHANGELOG.md`.
- Phase 1 documentation updates: upstream mapping (`libomtnet` → `ngmt-core`, `libvmx` → `ngmt-codec`), `ngmt-transport` as first-party QUIC/WAN repo; contributor guide [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md).
