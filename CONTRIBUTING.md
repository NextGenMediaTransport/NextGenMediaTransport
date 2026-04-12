# Contributing to NextGenMediaTransport (meta repository)

This **meta** repository holds **`docs/`**, harness tooling, branding assets, Cursor rules, and CI that clones sibling app repos. Transport, codec, Studio, OBS, and capture code live in **separate org repositories** under [NextGenMediaTransport](https://github.com/NextGenMediaTransport).

## Where to send changes

| Change | Repository |
|--------|------------|
| QUIC, TLS, discovery FFI, Rust smoke | [`ngmt-transport`](https://github.com/NextGenMediaTransport/ngmt-transport) |
| VMX / media codec | [`ngmt-codec`](https://github.com/NextGenMediaTransport/ngmt-codec) |
| C++ protocol / discovery facade | [`ngmt-core`](https://github.com/NextGenMediaTransport/ngmt-core) |
| Generator, Monitor, `ngmt-common` | [`ngmt-studio`](https://github.com/NextGenMediaTransport/ngmt-studio) |
| OBS plugin | [`ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin) |
| Desktop capture | [`ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture) |
| Roadmap, wire format, impairment methodology, meta CI | **This repo** |

## Expectations

- **Rust:** `cargo fmt` / `cargo clippy` / `cargo test` as enabled in each child repo.
- **C++ / CMake:** match existing presets; see child **README** files.
- **Documentation:** public APIs, wire format changes, and phase gates must stay in sync — see `.cursor/rules/documentation.mdc` and [docs/project-plan/](docs/project-plan/).
- **Versioning:** shipping artifacts follow **Semantic Versioning**; protocol fields are documented in [docs/protocol/ngmt-wire-format.md](docs/protocol/ngmt-wire-format.md) (see **Versioning** there).

## Local workspace

Clone the meta repo and add siblings **next to** it (same parent folder) as in the root [README.md](README.md). Use **`tools/`** scripts and **`docs/testing/`** for WAN simulation where applicable.

## Issues and milestones

Program board: [meta#3](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/3). Release checklist: [meta#6](https://github.com/NextGenMediaTransport/NextGenMediaTransport/issues/6). Use org milestones **`v1.0`** vs **`v1.0-adoption`** as documented in [version-1-release-status.md](docs/project-plan/version-1-release-status.md).
