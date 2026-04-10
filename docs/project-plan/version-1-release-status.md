---
title: "Version 1 release — phase status and gaps"
phase: 0
status: living
---

# Version 1 release — where we are per phase

This document is the **single checklist** for **program status by roadmap phase** and for what is **still missing** before a **Version 1 (v1.0)** product-grade release. It is updated when phases or release criteria change; phase detail remains in each [phase plan](./00-Master-Roadmap.md).

## How to read this

- **Phase status** reflects **repositories and docs** in the NGMT workspace today, not unreleased private work.
- **Version 1** below is a **defined release bar** (see [What we call “Version 1”](#what-we-call-version-1)) so “missing from v1” is unambiguous. It is **not** the same as “Phase 4 complete” or “all six phases done.”

---

## Per-phase snapshot

| Phase | Focus | Status | Evidence / notes |
| ----- | ----- | ------ | ---------------- |
| **1** — Foundation | Org, forks, licensing, CI baseline, contributor rules | **Done** (per [plan](./01-Phase-1-Foundation-and-Forking.md)) | Meta-repo, `ngmt-core` / `ngmt-codec` / `ngmt-transport` / `ngmt-studio` on GitHub; MIT licensing; CI in child repos + [meta smoke](../../.github/workflows/ci.yml). |
| **2** — Build standardization | One-command builds, CMake/Cargo hygiene, linting | **Largely done; DoD not fully closed in doc** | Each major repo builds in CI; [Phase 2 plan](./02-Phase-2-Refactor-and-Build-Standardization.md) still lists some DoD boxes unchecked (unified *meta* build script, devcontainer, full dependency audit). |
| **3** — Discovery & WAN | mDNS, QUIC, harness, WAN honesty | **In progress** (per [plan](./03-Phase-3-Core-Features-Discovery-and-WAN.md)) | **Rust:** `ngmt-transport` (QUIC, BBR, FFI, ALPN `ngmt`), `ngmt-studio` mDNS `_ngmt._udp`. **C++:** `ngmt-core` discovery is **facade + manual** ([discovery status](../../ngmt-core/docs/discovery-status.md)). **Not in v1 transport yet:** STUN/TURN/ICE. **Impairment:** methodology + [impairment log template](../testing/impairment-results.md) (populate with real runs for audit). |
| **4** — Developer UI | Generator, Monitor, multiview, discovery browser | **Completed** (per [plan](./04-Phase-4-Developer-UI-and-Visibility.md)) | [`ngmt-studio`](../../ngmt-studio/README.md): lab tooling; **stub payloads**, not production encode/decode. Optional Phase 4 items (e.g. **log export**) not required for phase DoD. |
| **5** — Integrations | OBS, virtual camera/audio, SDKs | **Not started** (planned) | [Phase 5 DoD](./05-Phase-5-Integrations-and-Ecosystem.md) unchecked: OBS plugin, vcam/vaudio, Python/C++/Rust SDKs. |
| **6** — Hardware & commercial | Reference HW, PTZ/tally, outreach | **Not started** (planned) | [Phase 6 DoD](./06-Phase-6-Hardware-and-Commercial-Adoption.md) unchecked. |

---

## What we call “Version 1”

**Version 1** means a **first production-oriented release** of the NGMT *stack* that external teams can adopt with a straight face: stable interfaces, real media path, and integration surfaces—not only lab tools.

For this project, **v1.0** is defined as meeting **all** of:

1. **Transport:** Production-oriented **TLS identity** (not lab-only certs), **versioned** wire format and ABI, documented **operational** WAN behavior (including explicit **non-goals** where STUN/TURN are absent).
2. **Media path:** **Encoded** video/audio **end-to-end** (e.g. `ngmt-codec` or agreed codec) **into** QUIC and **out** to a receiver—not stub `frame=N` payloads for the primary demo path.
3. **Discovery:** Consistent story on the LAN—either **real mDNS in `ngmt-core`** aligned with Studio, or a **documented** “Rust discovery is reference; C++ uses manual until …” with a migration plan **shipped in release notes**.
4. **Integrations (minimum):** At least **one** of: **OBS plugin**, **virtual camera**, or **virtual audio** on a stated OS set **plus** a **published SDK** (one language minimum, e.g. Rust or C++) with examples.
5. **Release artifacts:** Semantic versioning for repos that ship binaries; **CHANGELOG** and **upgrade notes**; security expectations (e.g. cert validation in production) documented.

Until those are true, releases should stay **0.x** (e.g. **0.4** after Phase 4 tooling) or use explicit **preview** naming.

---

## Missing for Version 1 (gap list)

Cross-check against [What we call “Version 1”](#what-we-call-version-1).

| # | Gap | Phase | Notes |
| - | --- | ----- | ----- |
| 1 | **Production TLS / PKI story** (replace lab rcgen defaults for shipped binaries) | 3 / release | Required for trustworthy WAN deployments. |
| 2 | **STUN/TURN/ICE or documented alternative** for arbitrary NAT, if v1 claims broad WAN | 3 | Today: direct QUIC + honest docs; v1 may scope “known peer / datacenter” only—then say so in release. |
| 3 | **C++ `Advertiser` real mDNS** or **shipped** migration doc + timeline | 3 | See [discovery-status.md](../../ngmt-core/docs/discovery-status.md). |
| 4 | **Real codec path** camera/file → encode → QUIC → decode → display (or to OBS buffer) | 2–5 | `ngmt-codec` + pipeline work; Studio stubs are not sufficient for v1 media claims. |
| 5 | **OBS plugin and/or virtual camera/audio** | 5 | Phase 5 DoD. |
| 6 | **Published SDK** + packaging (crate, CMake, or PyPI as agreed) | 5 | Phase 5 DoD. |
| 7 | **Impairment results** populated in [impairment-results.md](../testing/impairment-results.md) for at least one **documented** profile | 3 | Proves WAN story is measured, not only designed. |
| 8 | **Optional v1 polish:** telemetry **log export** from Monitor, headless/integration tests beyond transport loopback | 4–5 | Not blockers if v1 scope is narrow. |
| 9 | **Phase 2 meta-build** (single script/build-all) and **CONTRIBUTING.md** rigor | 2 | Reduces adoption friction for v1 contributors. |
| 10 | **Reference hardware / PTZ / tally** | 6 | **Not** required for a minimal v1 **software** release; required only if marketing v1 as “broadcast hardware ready.” |

---

## Suggested next milestones (toward v1)

1. Close **Phase 3** remaining engineering: C++ discovery or explicit product decision; production TLS policy; impairment log entries.
2. Define **v1 scope** in a short **RFC** or release issue: which OSes, which integrations (OBS vs vcam only), and whether WAN is “known peer” or full NAT.
3. Execute **Phase 5** minimum slice: codec pipeline + one integration + one SDK.
4. Tag **1.0.0** only after [Missing for Version 1](#missing-for-version-1-gap-list) rows required by that RFC are done.

---

## Related documents

- [Master roadmap](./00-Master-Roadmap.md)
- [Phase 3 — Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md)
- [Phase 4 — Developer UI](./04-Phase-4-Developer-UI-and-Visibility.md)
- [Phase 5 — Integrations](./05-Phase-5-Integrations-and-Ecosystem.md)
- [ngmt-wire-format](../protocol/ngmt-wire-format.md)
