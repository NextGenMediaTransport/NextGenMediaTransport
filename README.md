# NextGenMediaTransport (NGMT)

NextGenMediaTransport is a modernized fork of [Open Media Transport (OMT)](https://www.openmediatransport.org/), aimed at competing with NDI. The focus is **developer and operator experience**, **modern networks**, and **permissive licensing** so vendors can adopt the stack without friction.

## Strategic pillars

- **QUIC-based transport (WAN)** — NAT traversal and lossy links as first-class. **QUIC/WAN is implemented in NGMT** (`ngmt-transport`); upstream OMT today uses TCP on the LAN and has no QUIC repository to fork.
- **AV1 / VMX codec support** — Aligned with `ngmt-codec` (forked from upstream `libvmx`).
- **Zero-configuration LAN discovery** — mDNS / Zeroconf-style discovery, building on OMT’s DNS-SD story where applicable.

See [docs/project-plan/00-Master-Roadmap.md](docs/project-plan/00-Master-Roadmap.md) for the six-phase roadmap (foundation → build → core transport and simulation → developer UI → integrations → hardware) and [docs/project-plan/01-Phase-1-Foundation-and-Forking.md](docs/project-plan/01-Phase-1-Foundation-and-Forking.md) for Phase 1 (organization, forks, CI, licensing, docs automation).

## Phase 1 (this repository)

This repo holds **project planning**, **agent rules** under `.cursor/rules/`, and **baseline automation**: MIT `LICENSE`, GitHub Actions CI/docs placeholders, and contributor docs. **Phase 2** introduces unified CMake/Cargo builds for code repositories.

Local checkouts of **`ngmt-core`**, **`ngmt-codec`**, **`ngmt-transport`**, and **`ngmt-studio`** (Phase 4 tools) live in **this workspace root** (directories next to `docs/`). They are separate Git repositories; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md). `.gitignore` excludes them from the meta-repo tree if you initialize Git here.

### Related NGMT repositories

| NGMT repo | Origin |
| --- | --- |
| `ngmt-core` | Fork of [`openmediatransport/libomtnet`](https://github.com/openmediatransport/libomtnet) (OMT protocol reference). |
| `ngmt-codec` | Fork of [`openmediatransport/libvmx`](https://github.com/openmediatransport/libvmx) (VMX codec). |
| `ngmt-transport` | **New** first-party repo for QUIC/WAN — not an upstream fork. |
| `ngmt-studio` | **New** first-party repo for Generator + Monitor (egui); depends on `ngmt-transport` via path/sibling checkout. |

Use **GitHub CLI** (`gh`) for forks and org repo creation; see [docs/contributing/fork-upstream-repos.md](docs/contributing/fork-upstream-repos.md).

### CI status

Workflows under [`.github/workflows/`](.github/workflows/) are **placeholders** until build tooling lands in Phase 2 (matrix runs a no-op `echo` step).

### Phase 3 testing docs

- [docs/testing/harness_setup.md](docs/testing/harness_setup.md) — `tc` / netem (Fedora), Clumsy (Windows), macOS notes.
- [docs/testing/wlan-simulation.md](docs/testing/wlan-simulation.md) — WLAN baseline vs impaired methodology.
- [docs/protocol/ngmt-wire-format.md](docs/protocol/ngmt-wire-format.md) — NGMT object header and QUIC mapping.

### Phase 4 developer tools (`ngmt-studio`)

Clone [NextGenMediaTransport/ngmt-studio](https://github.com/NextGenMediaTransport/ngmt-studio) beside the engine repos. Build/run: [ngmt-studio/README.md](ngmt-studio/README.md) (also see [Phase 4 plan](docs/project-plan/04-Phase-4-Developer-UI-and-Visibility.md)).

**Scope (read this):** Generator and Monitor are **lab tools** for QUIC, discovery, and soak testing. They are **not** a **real-world** end-to-end video product yet: payloads are **stubs** (e.g. `frame=N` text), and the Monitor **reconstructs** test patterns locally — **no** transported pixels or production encode/decode. See the Phase 4 plan for the full disclaimer.

## License

This meta-repository is licensed under the MIT License — see [LICENSE](LICENSE).
