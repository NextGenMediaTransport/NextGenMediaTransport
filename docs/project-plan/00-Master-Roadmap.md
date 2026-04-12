---
title: "NextGenMediaTransport — Master Roadmap"
phase: 0
status: planned
---

## Overview

NextGenMediaTransport (NGMT) is a high-performance, open-source media transport protocol positioned to compete with NDI. It is a modernized fork of Open Media Transport (OMT), focused on **developer and operator experience**, **modern networks**, and **permissive licensing** so hardware and software vendors can adopt it without friction.

### Strategic pillars

- **QUIC-based transport** — WAN and remote production paths (NAT traversal, lossy links) as first-class, not an afterthought. Implemented in **NGMT** (`ngmt-transport`); upstream OMT today is LAN/TCP-based and provides no QUIC transport repository to fork.
- **AV1 / VMX codec support** — Modern compression aligned with `ngmt-codec` and ecosystem goals.
- **Zero-configuration local discovery** — Sources appear automatically on the LAN (mDNS / Zeroconf), matching the best user-facing aspects of entrenched tools.

Competing with an entrenched standard requires more than cleaner code: NGMT must remove adoption friction (buildability, docs, integrations) and deliver **WAN credibility** alongside **LAN simplicity**.

### Version 1.0 production bar (Four Pillars)

The project is moving from **lab / research** to a **production-oriented** **v1.0**. That release is **not** “Phase 6 complete”; it is defined by the **Four Pillars** and the **vertical slice** (real media → QUIC → OBS), documented in [**version-1-release-status.md**](./version-1-release-status.md):

| Pillar | Summary |
| ------ | -------- |
| **Real Media Path** | VMX / **ngmt-codec** → QUIC → decode — no primary-path stubs. |
| **The Killer App (P0)** | **OBS Studio** source plugin. |
| **Security Baseline** | Production TLS / identity policy (e.g. pinning, user PEM — not necessarily a private CA). |
| **Audit of Honesty** | Impairment documented at **2%, 5%, 10%** loss; **multi-platform** honesty (e.g. x86 vs ARM NIC behavior). |

**v1.0 baseline (spanning phases):** Phases **1–2** are prerequisites. **v1.0** lands when **Phase 3** blockers (TLS, discovery/mDNS story, impairment audit), the **ngmt-codec** media path, and **Phase 5** integrations (**OBS** + scoped virtual devices) meet that bar. **Phase 4** (developer UI) supports debugging but is **not** the v1.0 gate. **Phase 5b** (e.g. Python SDK) is **post-v1.0**.

## Release status (v1)

For **where we are per phase** and **what is still missing for Version 1.0**, see [**version-1-release-status.md**](./version-1-release-status.md) (living document). **Parallel scheduling** (capture vs blockers): [program-parallel-tracks.md](./program-parallel-tracks.md). **`ngmt-core` discovery escape hatch:** [ngmt-core-discovery-escape-hatch.md](./ngmt-core-discovery-escape-hatch.md).

## Phase index

Structured plans for each phase live in this directory:

- [Phase 1 — Foundation and Forking](./01-Phase-1-Foundation-and-Forking.md) — GitHub organization, essential forks, cross-platform CI/CD, MIT/Apache-2.0 licensing, documentation automation, and repository-wide agent rules.
- [Phase 2 — Refactor and Build Standardization](./02-Phase-2-Refactor-and-Build-Standardization.md) — CMake/Cargo alignment, dependency pruning, coding standards, one-click local builds.
- [Phase 3 — Core Features: Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md) — mDNS discovery, QUIC/NAT tuning, loss recovery, congestion control, and **network simulation** validation.
- [Phase 4 — Developer UI and Visibility](./04-Phase-4-Developer-UI-and-Visibility.md) — Studio Monitor–class tools: test pattern sender, single/multiview receivers, discovery browser, and related debug UIs.
- [Phase 5 — Integrations and Ecosystem](./05-Phase-5-Integrations-and-Ecosystem.md) — **v1.0:** OBS Studio plugin, virtual camera/audio. **Phase 5b (post-v1.0):** SDK wrappers (Python, C++, Rust) and further ecosystem work.
- [Phase 6 — Hardware and Commercial Adoption](./06-Phase-6-Hardware-and-Commercial-Adoption.md) — Reference hardware (e.g. Raspberry Pi 5 encoder), PTZ/tally schemas, commercial outreach.

## Documentation governance

Documentation must scale with the codebase. **Humans:** treat `docs/project-plan/` as the strategic source of truth for phases and priorities. **Agents and automation:** **`.cursor/rules/`** (for example always-applied [`documentation.mdc`](../../.cursor/rules/documentation.mdc)) mandates autonomous updates to documentation (API references, architecture notes, changelogs, integration guides) whenever code changes—so the rule applies even when work happens deep in a single crate or submodule. Phase 1 also describes **CI-driven documentation pipelines** (e.g. GitHub Actions) to generate or refresh artifacts on merge; ongoing edits remain a standing obligation, not a one-time setup.

## Phase dependencies

Work is sequential in intent: **Phase 2** assumes **Phase 1** repos, CI, and licensing; **Phase 3** assumes a clean, standardized build from **Phase 2**; **Phase 4** (developer UI) assumes **Phase 3** protocol and transport stability; **Phase 5** and **Phase 6** build on a stable protocol story and benefit from first-party debug tooling from Phase 4. **v1.0** is achieved when the **vertical slice** (see [version-1-release-status.md](./version-1-release-status.md)) is complete—not when every phase through 6 is finished. Parallel work is possible only where interfaces are stable and documented.

## Roadmap at a glance

Phases unfold in order for **overall** program maturity:

```mermaid
flowchart LR
  P1[Phase1_Foundation]
  P2[Phase2_Build]
  P3[Phase3_Transport]
  P4[Phase4_DeveloperUI]
  P5[Phase5_Ecosystem]
  P6[Phase6_Hardware]
  P1 --> P2 --> P3 --> P4 --> P5 --> P6
```

**v1.0** is a **cross-cutting baseline**: the Four Pillars complete when the **vertical slice** converges (Phase 3 + real media path + Phase 5 OBS/vcam). Phase 4 supports validation; Phase 5b and Phase 6 are outside the v1.0 gate.

```mermaid
flowchart TB
  prereq[Phase1_and_Phase2]
  p3[Phase3_WAN_Discovery_TLS_Impairment]
  codec[RealMediaPath_ngmt_codec]
  p5[Phase5_OBS_and_VirtualCam]
  p4[Phase4_LabUI_debug]
  v1Node[v1_0_Four_Pillars_complete]
  prereq --> p3
  prereq --> codec
  prereq --> p4
  p3 --> v1Node
  codec --> v1Node
  p5 --> v1Node
  p4 -.->|supports| v1Node
```
