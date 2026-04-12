# NextGenMediaTransport (NGMT)

<p align="center"><img src="docs/branding/assets/svg/marks/ngmt-meta.svg" width="100" height="100" alt="NGMT meta mark"/></p>

NextGenMediaTransport is a modernized fork of [Open Media Transport (OMT)](https://www.openmediatransport.org/), aimed at competing with NDI. The focus is **developer and operator experience**, **modern networks**, and **permissive licensing** so vendors can adopt the stack without friction.

## Strategic pillars

- **QUIC-based transport (WAN)** — NAT traversal and lossy links as first-class. **QUIC/WAN is implemented in NGMT** (`ngmt-transport`); upstream OMT today uses TCP on the LAN and has no QUIC repository to fork.
- **AV1 / VMX codec support** — Aligned with `ngmt-codec` (forked from upstream `libvmx`).
- **Zero-configuration LAN discovery** — mDNS / Zeroconf-style discovery, building on OMT’s DNS-SD story where applicable.

See [docs/project-plan/00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md) for the six-phase roadmap; [**phase and Version 1 gap status**](docs/project-plan/version-1-release-status.md) summarizes shipped vs missing work. (foundation → build → core transport and simulation → developer UI → integrations → hardware) and [docs/project-plan/01-Phase-1-Foundation-and-Forking.md](docs/project-plan/01-Phase-1-Foundation-and-Forking.md) for Phase 1 (organization, forks, CI, licensing, docs automation).

**Version 1.0 on GitHub:** Each org repo has milestones **`v1.0`** (close before tagging **1.0.0**) and **`v1.0-adoption`** (tooling and polish not gating the tag); see **Issues → Milestones** on each repository. Cross-repo program board: [NextGenMediaTransport#3](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/3).

## This meta-repository

This repo holds **project planning**, **cross-cutting documentation** (testing methodology, wire format, phase plans), **agent rules** under `.cursor/rules/`, and **coordination** (MIT `LICENSE`, contributor docs). **Implementation** lives in sibling repositories (`ngmt-core`, `ngmt-codec`, `ngmt-transport`, `ngmt-studio`, `ngmt-capture`, `ngmt-obs-plugin`), each with its own build and CI. **Contributing:** see [CONTRIBUTING.md](CONTRIBUTING.md) (which repo to patch, versioning, milestones). **`ngmt-capture`** is a **first-party desktop capture** repo ([`NextGenMediaTransport/ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture)); clone it beside the engines per that README (path dependencies into **`ngmt-studio`** for **`ngmt-common`**, in-repo **`ngmt-vmx-sys`**, sibling **`ngmt-transport`** / **`ngmt-codec`**).

Local checkouts of **`ngmt-core`**, **`ngmt-codec`**, **`ngmt-transport`**, **`ngmt-studio`**, **`ngmt-capture`**, and **`ngmt-obs-plugin`** live in **this workspace root** (directories next to `docs/`). They are separate Git repositories; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md). `.gitignore` excludes them from the meta-repo tree if you initialize Git here.

### Related NGMT repositories

| NGMT repo | Origin |
| --- | --- |
| `ngmt-core` | Fork of [`openmediatransport/libomtnet`](https://github.com/openmediatransport/libomtnet) (OMT protocol reference). |
| `ngmt-codec` | Fork of [`openmediatransport/libvmx`](https://github.com/openmediatransport/libvmx) (VMX codec). |
| `ngmt-transport` | **New** first-party repo for QUIC/WAN — not an upstream fork. |
| `ngmt-studio` | **New** first-party repo for Generator + Monitor (egui); depends on `ngmt-transport` via path/sibling checkout. |
| `ngmt-obs-plugin` | **OBS** integration (**input** v1.0 P0, **output** P1); clone [`NextGenMediaTransport/ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin). See [studio ecosystem matrix](docs/project-plan/studio-ecosystem-matrix.md). |
| `ngmt-capture` | **Desktop capture** (macOS v0.1 MVP); clone [`NextGenMediaTransport/ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture) — [README](https://github.com/NextGenMediaTransport/ngmt-capture/blob/main/README.md), [ngmt-capture-spec](docs/project-plan/ngmt-capture-spec.md). |

Use **GitHub CLI** (`gh`) for forks and org repo creation; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md).

### Continuous integration

- **Per-repository CI** (authoritative for builds): each code repo runs its own GitHub Actions — e.g. `cargo build` / `cargo test` in [`ngmt-transport`](https://github.com/NextGenMediaTransport/ngmt-transport), `cargo check` for [`ngmt-studio`](https://github.com/NextGenMediaTransport/ngmt-studio), CMake in [`ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin) (default **info** scaffold on Linux; **OBS module** when `NGMT_WITH_OBS=ON` and libobs is installed), CMake in [`ngmt-core`](https://github.com/NextGenMediaTransport/ngmt-core). See each repo’s `.github/workflows/`.
- **Meta-repo workflow** ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)): when this documentation tree is pushed, CI **clones** public `ngmt-transport`, `ngmt-studio`, `ngmt-codec`, **`ngmt-capture`**, `ngmt-core`, and `ngmt-obs-plugin` next to the checkout and runs a **stack smoke check** (not a substitute for per-repo CI): **`ngmt-transport`** — `cargo build --release` and `cargo test`; **`ngmt-studio`** — `cargo check --workspace` after Ubuntu GTK/XCB packages; **`ngmt-capture`** — `cargo check` with the same GUI deps; **`ngmt-core`** — CMake **Release** build plus optional **transport FFI** smoke (`NGMT_ENABLE_TRANSPORT_FFI_SMOKE`); **`ngmt-obs-plugin`** — CMake **`NGMT_WITH_OBS=OFF`** and the **`ngmt-obs-plugin-info`** target only.

### Build on Linux (Fedora)

- [docs/build/linux-fedora.md](docs/build/linux-fedora.md) — **`dnf`** packages, **rustup**, **`ngmt-transport`** / **`ngmt-studio`** / optional **`ngmt-core`**, and troubleshooting (maps Ubuntu CI deps to Fedora).

### Phase 3 testing docs

- [docs/testing/harness_setup.md](docs/testing/harness_setup.md) — `tc` / netem (Fedora), Clumsy (Windows), macOS notes.
- [docs/testing/lab-log-capture.md](docs/testing/lab-log-capture.md) — **`NGMT_LOG_FILE`**, `target/<profile>/logs/`, Mac + Fedora command templates.
- [docs/testing/wlan-simulation.md](docs/testing/wlan-simulation.md) — WLAN baseline vs impaired methodology.
- [docs/protocol/ngmt-wire-format.md](docs/protocol/ngmt-wire-format.md) — NGMT object header and QUIC mapping.

### Phase 4 developer tools (`ngmt-studio`)

Clone [NextGenMediaTransport/ngmt-studio](https://github.com/NextGenMediaTransport/ngmt-studio) beside the engine repos. Build/run: [ngmt-studio/README.md](ngmt-studio/README.md) (also see [Phase 4 plan](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md)).

**Scope:** Generator and Monitor are **developer lab tools**; the **Studio primary path** now runs **VMX** (`ngmt-codec`) **encode → QUIC → decode** with real bitstreams and OWD timestamps — see [ngmt-studio/README.md](ngmt-studio/README.md) and [media payload v1](docs/protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path). **v1.0** still requires the broader **Four Pillars** (e.g. OBS, TLS policy, impairment audit) — see [version-1-release-status.md](docs/project-plan/version-1-release-status.md).

**Next implementation steps** for Studio tools, Monitor UX backlog, capture alignment, and branding: [docs/project-plan/studio-next-steps.md](docs/project-plan/studio-next-steps.md).

## License

This meta-repository is licensed under the MIT License — see [LICENSE](LICENSE).
