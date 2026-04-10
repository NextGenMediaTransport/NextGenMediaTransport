# NextGenMediaTransport (NGMT)

NextGenMediaTransport is a modernized fork of [Open Media Transport (OMT)](https://www.openmediatransport.org/), aimed at competing with NDI. The focus is **developer and operator experience**, **modern networks**, and **permissive licensing** so vendors can adopt the stack without friction.

## Strategic pillars

- **QUIC-based transport (WAN)** — NAT traversal and lossy links as first-class. **QUIC/WAN is implemented in NGMT** (`ngmt-transport`); upstream OMT today uses TCP on the LAN and has no QUIC repository to fork.
- **AV1 / VMX codec support** — Aligned with `ngmt-codec` (forked from upstream `libvmx`).
- **Zero-configuration LAN discovery** — mDNS / Zeroconf-style discovery, building on OMT’s DNS-SD story where applicable.

See [docs/project-plan/00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md) for the six-phase roadmap; [**phase and Version 1 gap status**](docs/project-plan/version-1-release-status.md) summarizes shipped vs missing work. (foundation → build → core transport and simulation → developer UI → integrations → hardware) and [docs/project-plan/01-Phase-1-Foundation-and-Forking.md](docs/project-plan/01-Phase-1-Foundation-and-Forking.md) for Phase 1 (organization, forks, CI, licensing, docs automation).

## This meta-repository

This repo holds **project planning**, **cross-cutting documentation** (testing methodology, wire format, phase plans), **agent rules** under `.cursor/rules/`, and **coordination** (MIT `LICENSE`, contributor docs). **Implementation** lives in sibling repositories (`ngmt-core`, `ngmt-codec`, `ngmt-transport`, `ngmt-studio`), each with its own build and CI.

Local checkouts of **`ngmt-core`**, **`ngmt-codec`**, **`ngmt-transport`**, and **`ngmt-studio`** live in **this workspace root** (directories next to `docs/`). They are separate Git repositories; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md). `.gitignore` excludes them from the meta-repo tree if you initialize Git here.

### Related NGMT repositories

| NGMT repo | Origin |
| --- | --- |
| `ngmt-core` | Fork of [`openmediatransport/libomtnet`](https://github.com/openmediatransport/libomtnet) (OMT protocol reference). |
| `ngmt-codec` | Fork of [`openmediatransport/libvmx`](https://github.com/openmediatransport/libvmx) (VMX codec). |
| `ngmt-transport` | **New** first-party repo for QUIC/WAN — not an upstream fork. |
| `ngmt-studio` | **New** first-party repo for Generator + Monitor (egui); depends on `ngmt-transport` via path/sibling checkout. |

Use **GitHub CLI** (`gh`) for forks and org repo creation; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md).

### Continuous integration

- **Per-repository CI** (authoritative for builds): each code repo runs its own GitHub Actions — e.g. `cargo build` / `cargo test` in [`ngmt-transport`](https://github.com/NextGenMediaTransport/ngmt-transport), `cargo check` for [`ngmt-studio`](https://github.com/NextGenMediaTransport/ngmt-studio), CMake in [`ngmt-core`](https://github.com/NextGenMediaTransport/ngmt-core). See each repo’s `.github/workflows/`.
- **Meta-repo workflow** ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)): when this documentation tree is pushed, CI **clones** public `ngmt-transport`, `ngmt-studio`, and `ngmt-core` next to the checkout and runs **release builds** so a docs-only clone still validates the stack layout. It does **not** replace per-repo CI; it is a **smoke check** for contributors using the full workspace.

### Phase 3 testing docs

- [docs/testing/harness_setup.md](docs/testing/harness_setup.md) — `tc` / netem (Fedora), Clumsy (Windows), macOS notes.
- [docs/testing/wlan-simulation.md](docs/testing/wlan-simulation.md) — WLAN baseline vs impaired methodology.
- [docs/protocol/ngmt-wire-format.md](docs/protocol/ngmt-wire-format.md) — NGMT object header and QUIC mapping.

### Phase 4 developer tools (`ngmt-studio`)

Clone [NextGenMediaTransport/ngmt-studio](https://github.com/NextGenMediaTransport/ngmt-studio) beside the engine repos. Build/run: [ngmt-studio/README.md](ngmt-studio/README.md) (also see [Phase 4 plan](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md)).

**Scope (read this):** Generator and Monitor are **lab tools** for QUIC, discovery, and soak testing. They are **not** a **real-world** end-to-end video product yet: payloads are **stubs** (e.g. `frame=N` text), and the Monitor **reconstructs** test patterns locally — **no** transported pixels or production encode/decode. See the Phase 4 plan for the full disclaimer. For **v1.0**, the **primary product path** must use the **ngmt-codec** pipeline end-to-end (VMX encode → QUIC → decode); stubs are not acceptable for that bar — see [version-1-release-status.md](docs/project-plan/version-1-release-status.md) (**Four Pillars**).

## License

This meta-repository is licensed under the MIT License — see [LICENSE](LICENSE).
