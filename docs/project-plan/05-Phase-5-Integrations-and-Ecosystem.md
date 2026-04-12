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

**Stub / synthetic payloads:** Integrations must consume the **ngmt-codec** real media pipeline for the **primary** product path; lab **stub** payloads in Generator/Monitor are **not** sufficient for v1.0 claims — see [documentation touchpoints](./version-1-release-status.md#documentation-touchpoints--studio-vs-v10-product-path).

### First-party capture vs integrations

- **`ngmt-capture`** (see [ngmt-capture-spec.md](./ngmt-capture-spec.md)) is the planned **first-party NGMT** application for **desktop / window** pixels → VMX → QUIC, with OS permissions and operator-focused defaults. It shares connection semantics with [`ngmt-generator`](../../ngmt-studio/README.md) so **Monitor** and **OBS** can consume sources uniformly.
- **`ngmt-obs-plugin`** brings NGMT **into** OBS (and eventually **out** of OBS as output); it satisfies the **Killer App** pillar for v1.0 but does not replace owning a **native** capture story for users who do not run OBS. Program emphasis is spelled out under [version-1-release-status — Program emphasis](./version-1-release-status.md#program-emphasis-first-party-capture-vs-integrations).

## OBS Studio integration

### OBS input (source) vs output (program)

| Integration | User story | v1.0 gate |
| ----------- | ---------- | --------- |
| **Input (source)** | Bring **NGMT into OBS** as a video source (discover or dial a peer, receive QUIC, decode **VMX**, present frames to OBS). | **Yes — P0** (Killer App pillar). |
| **Output** | Send **OBS program** (or a dedicated scene) **out** as NGMT for Monitors, another OBS, or edge devices. | **No — P1** unless explicitly promoted before **1.0.0**; ship in the same **`ngmt-obs-plugin`** repo as a **separate module** to share QUIC/codec glue. |

**Rationale:** v1.0 must prove **decode + integration** in the dominant creative tool (**NDI-style source**). **Output** is high value for round-trip workflows but adds **encode-from-compositor** complexity and OBS API surface; it should not slip the **1.0.0** tag if input + virtual devices + pillars are otherwise ready.

**Tracking:** Implementation milestones for input vs output live in [`ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin) ([`TRACKING.md`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/TRACKING.md)); mirror bullets as GitHub Issues as work starts.

**Build status (2026-04):** With **`-DNGMT_WITH_OBS=ON`**, the repo produces **`obs-ngmt-input`** and **`obs-ngmt-output`** (stub) as **separate** loadable modules, each linked to sibling **`ngmt-transport`** (Quinn + rustls, same stack as Studio). **`obs-ngmt-input`** also links sibling **`ngmt-codec`**. **Manual** or **Discovery** (`_ngmt._udp` via transport FFI) QUIC receive + **media payload v1** fragment reassembly + **VMX v1** decode to the OBS GPU path (same wire as **ngmt-generator** → **ngmt-monitor**); **macOS** `.plugin` packaging via [`pack-macos-obs-plugins.sh`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/scripts/pack-macos-obs-plugins.sh). **Public-beta** bar: [README known-good matrix](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/README.md#known-good-matrix-build--runtime), [manual verification](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/README.md#manual-verification-issues-4--6), and [CI policy](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/docs/CI.md). Further polish under [#6](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/issues/6). Use **[`scripts/build.sh`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/scripts/build.sh)** to build **`ngmt-transport`** then CMake.

### Goals

- Ship an **official, high-performance** OBS **input** plugin (**v1.0 P0**) and an **output** plugin on a **P1** cadence unless the release checklist promotes output to v1.0.
- Align with OBS platform support (Windows, macOS, Linux) per project priorities; document build against supported OBS API versions.
- Repository: **[`NextGenMediaTransport/ngmt-obs-plugin`](https://github.com/NextGenMediaTransport/ngmt-obs-plugin)** (sibling checkout next to `ngmt-transport` / meta `docs/`) — **one** repo, **two** plugin surfaces sharing a static or dynamic **core** library (QUIC via `ngmt-transport`, VMX via `ngmt-codec` / FFI as used elsewhere).

## Virtual camera and virtual audio

### Goals

- Provide **system-level** virtual camera and virtual microphone devices so feeds appear in **browsers**, **Zoom**, **Teams**, and other apps that only enumerate standard devices—without requiring each app to link NGMT directly (**v1.0** scope alongside OBS).
- Document OS-specific installation, permissions, and limitations (e.g. driver signing, sandboxing).

### `ngmt-capture` and outbound desktop audio (future)

**Virtual audio** above is the **inbound-to-apps** story (NGMT → device). **[`ngmt-capture`](./ngmt-capture-spec.md)** will eventually offer **optional system / loopback audio** bundled with or alongside the **VMX video** path. That requires agreed **media payload** and **track** semantics (see [ngmt-wire-format](../protocol/ngmt-wire-format.md)); until then the capture spec’s **[Audio roadmap (Phase B)](./ngmt-capture-spec.md#audio-roadmap-phase-b-outbound-system-audio)** tracks spikes and doc work without implying a ship date.

## SDK wrappers (Phase 5b — post-v1.0)

### Goals

- Offer **simple, documented SDKs** for **Python**, **C++**, and **Rust**, mapped from the evolution of `omt-bindings` / **`ngmt-bindings`**.
- Include minimal **sender/receiver examples**, error handling patterns, and versioning policy for ABI/API stability.

## Future and stretch integrations

### Game engines — Unreal and Unity (input + output)

**Not v1.0.** After **OBS**, **virtual camera/audio**, and a stable **C/C++ surface** (e.g. **`ngmt-bindings`** or documented FFI from `ngmt-transport` + `ngmt-codec`), first-party or partner plugins can bring NGMT into real-time 3D pipelines.

| Surface | User story | Typical integration shape |
| ------- | ---------- | ------------------------- |
| **Input** | Use an **NGMT stream** as a **texture / media source** inside the engine (in‑world screen, compositing, LED wall preview). | Decode **VMX** → GPU texture (RHI / graphics API); optional audio for sync. |
| **Output** | Send a **render target** or **game view** **out** as NGMT (VMX over QUIC) for Monitors, OBS, or external production. | Capture back buffer / render target, encode **VMX**, send; discovery advertise optional. |

**Unreal Engine** — Plugin module(s) (Editor + runtime where applicable): align with **Unreal** versioning (major lockstep), **shipping / non-shipping** configs, and console / PC first; target repo name e.g. **`ngmt-unreal-plugin`** when promoted.

**Unity** — Package or native plugin (**Burst/IL2CPP** vs Editor constraints): align with **Unity LTS** tiers and **Render Pipeline** (Built-in / URP / HDRP) capture paths; target repo e.g. **`ngmt-unity-package`** or **`ngmt-unity-plugin`** when promoted.

**Dependencies:** Shared logic should mirror **`ngmt-obs-plugin`** (QUIC session, TLS, VMX encode/decode) — ideally **one** portable **core** library consumed by OBS, Unreal, and Unity to avoid protocol drift.

**Phase placement:** Treat as **post–Phase 5b** stretch (or a future **Phase 5c / ecosystem** line item) until explicitly added to [version-1-release-status](./version-1-release-status.md); see [studio ecosystem matrix](./studio-ecosystem-matrix.md).

### Blender addon (stretch)

**Not v1.0.** A **Blender** addon could provide **input** (NGMT stream → viewport / compositor image) and **output** (render or viewport → VMX over QUIC) for 3D and motion workflows. Target repo name placeholder: **`ngmt-blender-addon`** (TBD). Depends on the same **portable core** (QUIC, TLS policy, VMX) as OBS and game-engine integrations; Python addon constraints and Blender’s release cadence apply. Tracked in [studio ecosystem matrix](./studio-ecosystem-matrix.md).

## Ecosystem index

- **[Studio ecosystem matrix](./studio-ecosystem-matrix.md)** — all first-party apps / integrations, phases, and NDI-style analogues.
- **[Desktop capture spec](./ngmt-capture-spec.md)** — `ngmt-capture` product draft.
- **[Post–virtual-device priorities](./post-v1-ecosystem-priorities.md)** — bridge vs recorder vs access manager vs tally ordering.
- **[Intercom R&D](./intercom-r-and-d.md)** — far-future audio product boundary (not v1.0 scope).
- **[Studio next steps](./studio-next-steps.md)** — ordered backlog for Studio tools and capture.

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
