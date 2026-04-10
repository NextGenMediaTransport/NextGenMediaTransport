---
title: "Version 1 release — phase status and gaps"
phase: 0
status: living
---

# Version 1 release — where we are per phase

This document is the **single checklist** for **program status by roadmap phase** and for what is **still missing** before a **Version 1.0 (v1.0)** production-oriented release. It is updated when phases or release criteria change; phase detail remains in each [phase plan](./00-Master-Roadmap.md).

NGMT is moving from **lab / research** posture to a **production-oriented** v1.0 bar: external teams should be able to adopt the stack with clear interfaces, a real media path, and honest validation—not only debug tooling.

## How to read this

- **Phase status** reflects **repositories and docs** in the NGMT workspace today, not unreleased private work.
- **Version 1.0** below is a **defined release bar** (see [The v1.0 production bar — Four Pillars](#the-v10-production-bar--four-pillars)) so “missing from v1” is unambiguous. It is **not** the same as “Phase 4 complete” or “all six phases done.”

---

## Per-phase snapshot

| Phase | Focus | Status | Evidence / notes |
| ----- | ----- | ------ | ---------------- |
| **1** — Foundation | Org, forks, licensing, CI baseline, contributor rules | **Done** (per [plan](./01-Phase-1-Foundation-and-Forking.md)) | Meta-repo, `ngmt-core` / `ngmt-codec` / `ngmt-transport` / `ngmt-studio` on GitHub; MIT licensing; CI in child repos + [meta smoke](../../.github/workflows/ci.yml). |
| **2** — Build standardization | One-command builds, CMake/Cargo hygiene, linting | **Largely done; DoD not fully closed in doc** | Each major repo builds in CI; [Phase 2 plan](./02-Phase-2-Refactor-and-Build-Standardization.md) still lists some DoD boxes unchecked (unified *meta* build script, devcontainer, full dependency audit). |
| **3** — Discovery & WAN | mDNS, QUIC, harness, WAN honesty | **In progress** (per [plan](./03-Phase-3-Core-Features-Discovery-and-WAN.md)) | **Rust:** `ngmt-transport` (QUIC, BBR, FFI, ALPN `ngmt`), `ngmt-studio` mDNS `_ngmt._udp`. **C++:** `ngmt-core` discovery is **facade + manual** until v1.0 parity ([discovery status](../../ngmt-core/docs/discovery-status.md)). **v1.0 blockers:** production TLS policy, C++ mDNS parity (or documented Rust→FFI path), documented impairment at 2/5/10% loss. **Not in v1 transport yet:** STUN/TURN/ICE. |
| **4** — Developer UI | Generator, Monitor, multiview, discovery browser | **Completed** (per [plan](./04-Phase-4-Developer-UI-and-Visibility.md)) | [`ngmt-studio`](../../ngmt-studio/README.md): lab tooling; **stub / synthetic payloads** — must be replaced on the **primary product path** by the **ngmt-codec** pipeline for v1.0 (see [Documentation touchpoints — stubs and synthetic payloads](#documentation-touchpoints--stubs-and-synthetic-payloads)). |
| **5** — Integrations | OBS, virtual camera/audio, SDKs | **Not started** (planned) | **v1.0:** [OBS Studio plugin (P0)](./05-Phase-5-Integrations-and-Ecosystem.md), virtual camera (and virtual audio as scoped). **Post-v1.0 / Phase 5b:** Python and other SDK wrappers — not gating v1.0. |
| **6** — Hardware & commercial | Reference HW, PTZ/tally, outreach | **Not started** (planned) | [Phase 6 DoD](./06-Phase-6-Hardware-and-Commercial-Adoption.md) unchecked. **Not** required for v1.0 software release. |

---

## The v1.0 production bar — Four Pillars

**v1.0** is the **Four Pillars** milestone. All four must be satisfied for a **1.0.0** product-oriented release.

| Pillar | What “done” means |
| ------ | ----------------- |
| **Real Media Path** | End-to-end **VMX / ngmt-codec** encoding → **QUIC** (`ngmt-transport`) → **decoding** — **no** primary-path **stubs** or synthetic transport payloads. Lab Generator/Monitor behavior does not satisfy this pillar. |
| **The Killer App (P0)** | A **functional OBS Studio source plugin** (first-party integration) so real productions can adopt NGMT without ad hoc glue. |
| **Security Baseline** | **Production-ready TLS / identity policy** moving beyond hardcoded lab certs. v1.0 does **not** require building a full **Certificate Authority**; a documented policy for **self-signed with pinning** and/or **user-provided PEM** files is a production-grade v1.0 win (see [v1.0 realities](#v10-realities)). |
| **Audit of Honesty** | **Documented** impairment results at **2%, 5%, and 10%** packet loss in [`impairment-results.md`](../testing/impairment-results.md) (methodology: [`harness_setup.md`](../testing/harness_setup.md)). Results will **vary by platform** (e.g. **Apple Silicon vs x86 Linux**) because **NICs differ in jitter behavior** — **document both** (hardware/OS named); that transparency matches broadcast engineering expectations. |

### Also required for a shippable v1.0

Supporting expectations that sit beside the Four Pillars:

- **Versioned** wire format and ABI where applicable; **CHANGELOG** and upgrade notes for repos that ship binaries.
- **Operational WAN** story documented, including **non-goals** (e.g. direct QUIC today; **STUN/TURN/ICE** not required for v1.0 unless release claims arbitrary NAT — then document or defer).
- **Semantic versioning** for shipping artifacts; security expectations (TLS policy, cert handling) written for operators.

Until the Four Pillars and the items above are true, releases should stay **0.x** or use explicit **preview** naming.

---

## v1.0 realities

Scope and honesty guardrails for engineering and docs (not a second definition of done):

1. **“Good Enough” TLS** — Do not scope v1.0 as operating a **full CA**. **Pinning** or **user PEM** policy is sufficient for the Security Baseline when documented.
2. **The “mDNS trap”** — **C++ mDNS parity** is a v1.0 blocker, but if native C++ mDNS integration **stalls**, **Rust-side discovery** (e.g. `ngmt-studio` / transport) may **resolve peers and feed addresses into `ngmt-core` via FFI** — document and ship that path; it is a valid v1.0 strategy.
3. **Fedora / M2 contrast** — Expect **different** impairment numbers on **Fedora (x86)** vs **Apple M2 (ARM)**; log **both** so the Audit pillar is credible across ecosystems.

---

## Missing for Version 1.0 (gap list)

Cross-check against [The v1.0 production bar — Four Pillars](#the-v10-production-bar--four-pillars).

| # | Pillar / theme | Gap | Phase | Notes |
| - | -------------- | --- | ----- | ----- |
| 1 | **Real Media Path** | **ngmt-codec** pipeline on the **primary** path: encode → QUIC → decode (e.g. to OBS or receiver); replace stub `frame=N` / synthetic payloads for that path | 2–5 | Studio lab tools remain valid for debug; v1.0 **product** path is codec-driven. |
| 2 | **Killer App (P0)** | **OBS Studio** source plugin shipped or in **public beta** with build/install docs and issue tracker | 5 | See [Phase 5](./05-Phase-5-Integrations-and-Ecosystem.md). |
| 2b | *(integration)* | **Virtual camera** (and **virtual audio** if in v1.0 scope) documented for target OSes | 5 | Primary v1.0 integration story alongside OBS; exact OS matrix in release notes. |
| 3 | **Security Baseline** | **TLS / PKI policy** for production (pinning / user PEM / upgrade path); replace **lab-only** rcgen defaults for shipped production-oriented binaries | 3 / release | Not “build a CA”; see [v1.0 realities](#v10-realities). |
| 4 | **Audit of Honesty** | [impairment-results.md](../testing/impairment-results.md) populated for **2%, 5%, and 10%** loss (document tool, revision, **OS + hardware**, metrics). Prefer **at least two** platform classes when practical (e.g. **x86 Linux + Apple ARM**) | 3 | NIC jitter differs; compare [Fedora/M2](#v10-realities). |
| 5 | **Discovery** | **C++ mDNS parity** with Studio / `_ngmt._udp`, **or** shipped migration doc + **Rust→FFI** discovery feed (see [Phase 3](./03-Phase-3-Core-Features-Discovery-and-WAN.md)) | 3 | [discovery-status.md](../../ngmt-core/docs/discovery-status.md). |
| — | *(non-pillar)* | **STUN/TURN/ICE** for arbitrary NAT | 3 | Only if v1.0 **claims** broad consumer NAT; else document **known-peer / datacenter** scope. |
| — | *(non-pillar)* | **Phase 2** meta-build script, **CONTRIBUTING** rigor | 2 | Adoption friction; not a Four Pillar blocker. |
| — | *(non-pillar)* | Telemetry **log export**, extra headless tests | 4–5 | Optional polish. |
| — | *(non-pillar)* | **Reference hardware / PTZ / tally** | 6 | **Not** required for v1.0 **software**. |

**Post-v1.0 (Phase 5b):** **Python SDK**, additional **C++/Rust** SDK wrappers, and other stretch integrations — explicitly **not** gating v1.0.

---

## Documentation touchpoints — stubs and synthetic payloads

The following docs describe **stub** or **synthetic** behavior today. For **v1.0**, the **primary demo and product path** must use the **ngmt-codec** real media pipeline, not stubs:

- [README.md](../../README.md) (Phase 4 scope disclaimer)
- [Phase 4 plan](./04-Phase-4-Developer-UI-and-Visibility.md) (Generator / Monitor)
- Meta [CHANGELOG.md](../../CHANGELOG.md) (historical notes on lab tooling)

---

## Suggested next milestones (toward v1.0)

Priority is the **vertical slice**: **codec (VMX/ngmt-codec) → transport (QUIC) → OBS plugin**, with Phase 3 work in parallel.

1. **Real Media Path:** Wire **ngmt-codec** end-to-end on the primary path (replace stubs for that path).
2. **Parallel — Phase 3 blockers:** **TLS policy** (good-enough: pinning / user PEM); **C++ mDNS** or **Rust discovery → FFI**; append **2% / 5% / 10%** impairment rows (multi-platform where feasible).
3. **Killer App:** **OBS Studio** plugin (P0) on a stated OS set; **virtual camera** as scoped for v1.0.
4. **Tag 1.0.0** only when [Missing for Version 1.0](#missing-for-version-10-gap-list) rows required for the agreed release are closed; **Phase 5b** SDKs follow.

---

## Related documents

- [Master roadmap](./00-Master-Roadmap.md)
- [Phase 3 — Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md)
- [Phase 4 — Developer UI](./04-Phase-4-Developer-UI-and-Visibility.md)
- [Phase 5 — Integrations](./05-Phase-5-Integrations-and-Ecosystem.md)
- [ngmt-wire-format](../protocol/ngmt-wire-format.md)
