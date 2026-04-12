---
title: "Phase 5 — Integrations and Ecosystem"
phase: 5
status: planned
---

## Overview

A protocol succeeds when applications use it. Phase 5 delivers **first-party integrations** so NGMT is usable in real workflows.

**v1.0 (primary goals)** — The **[Four Pillars](./version-1-release-status.md#the-v10-production-bar--four-pillars)** name a **functional OBS Studio source plugin (P0)** and a **real media path** (VMX / **ngmt-codec** → QUIC → decode). For v1.0, Phase 5 focuses on:

- **OBS Studio** plugins: **input (source)** is **v1.0 P0**; **output** (program out) is **P1** by default (same repo, separate modules — see below).
- **Virtual camera** and **virtual audio** (system-level devices so feeds appear in browsers, Zoom, Teams, and similar apps without each app linking NGMT directly).

**Phase 5b (post-v1.0)** — **SDK wrappers** (**Python**, **C++**, **Rust**) and additional ecosystem work are **not** gating v1.0; they ship after the **vertical slice** (codec → transport → OBS) is complete. See [version-1-release-status.md](./version-1-release-status.md).

**Stub / synthetic payloads:** Integrations must consume the **ngmt-codec** real media pipeline for the **primary** product path; lab **stub** payloads in Generator/Monitor are **not** sufficient for v1.0 claims — see [documentation touchpoints](./version-1-release-status.md#documentation-touchpoints--stubs-and-synthetic-payloads).

## OBS Studio integration

### OBS input (source) vs output (program)

| Integration | User story | v1.0 gate |
| ----------- | ---------- | --------- |
| **Input (source)** | Bring **NGMT into OBS** as a video source (discover or dial a peer, receive QUIC, decode **VMX**, present frames to OBS). | **Yes — P0** (Killer App pillar). |
| **Output** | Send **OBS program** (or a dedicated scene) **out** as NGMT for Monitors, another OBS, or edge devices. | **No — P1** unless explicitly promoted before **1.0.0**; ship in the same **`ngmt-obs-plugin`** repo as a **separate module** to share QUIC/codec glue. |

**Rationale:** v1.0 must prove **decode + integration** in the dominant creative tool (**NDI-style source**). **Output** is high value for round-trip workflows but adds **encode-from-compositor** complexity and OBS API surface; it should not slip the **1.0.0** tag if input + virtual devices + pillars are otherwise ready.

**Tracking:** Implementation milestones for input vs output live in [`ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin) ([`TRACKING.md`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/TRACKING.md)); mirror bullets as GitHub Issues as work starts.

### Goals

- Ship an **official, high-performance** OBS **input** plugin (**v1.0 P0**) and an **output** plugin on a **P1** cadence unless the release checklist promotes output to v1.0.
- Align with OBS platform support (Windows, macOS, Linux) per project priorities; document build against supported OBS API versions.
- Repository: **[`NextGenMediaTransport/ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin)** (sibling checkout next to `ngmt-transport` / meta `docs/`) — **one** repo, **two** plugin surfaces sharing a static or dynamic **core** library (QUIC via `ngmt-transport`, VMX via `ngmt-codec` / FFI as used elsewhere).

## Virtual camera and virtual audio

### Goals

- Provide **system-level** virtual camera and virtual microphone devices so feeds appear in **browsers**, **Zoom**, **Teams**, and other apps that only enumerate standard devices—without requiring each app to link NGMT directly (**v1.0** scope alongside OBS).
- Document OS-specific installation, permissions, and limitations (e.g. driver signing, sandboxing).

## SDK wrappers (Phase 5b — post-v1.0)

### Goals

- Offer **simple, documented SDKs** for **Python**, **C++**, and **Rust**, mapped from the evolution of `omt-bindings` / **`ngmt-bindings`**.
- Include minimal **sender/receiver examples**, error handling patterns, and versioning policy for ABI/API stability.

## Future and stretch integrations

- **Unreal Engine** (and similar engines) may be pursued as community or follow-on work once OBS and virtual devices prove the end-to-end story; track explicitly if promoted to a numbered phase later.

## Ecosystem index

- **[Studio ecosystem matrix](./studio-ecosystem-matrix.md)** — all first-party apps / integrations, phases, and NDI-style analogues.
- **[Desktop capture spec](./ngmt-capture-spec.md)** — `ngmt-capture` product draft.
- **[Post–virtual-device priorities](./post-v1-ecosystem-priorities.md)** — bridge vs recorder vs access manager vs tally ordering.
- **[Intercom R&D](./intercom-r-and-d.md)** — far-future audio product boundary (not v1.0 scope).

## Definition of Done

### v1.0 (Phase 5 — ships with 1.0.0 when the Four Pillars are met)

- [ ] Official **OBS Studio** **input (source)** plugin shipped or in public beta with clear build/install docs and issue tracker (**P0**). **Output** plugin: follow **`TRACKING.md`** in `ngmt-obs-plugin`; not a default v1.0 gate.
- [ ] **Virtual camera** and **virtual audio** paths documented for target OSes; minimum supported versions stated.
- [ ] Integration guides updated when protocol or transport APIs change.
- [ ] Primary integration path uses **ngmt-codec** (real media), not **stub** transport payloads.

### Phase 5b (post-v1.0)

- [ ] **Python**, **C++**, and **Rust** SDK wrappers published (or staged in-repo) with **examples** and packaging instructions.
- [ ] Integration guides updated when protocol or transport APIs change.
- [ ] Optional: additional bindings or community integrations as prioritized after v1.0.
