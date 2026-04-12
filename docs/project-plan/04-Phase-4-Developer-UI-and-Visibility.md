---
title: "Phase 4 — Developer UI and Visibility"
phase: 4
status: completed
---

## Overview

Phase 4 delivers **first-party developer and operator tools** with **Studio Monitor–class** usability: synthetic sources, receivers, and discovery browsing so teams can **debug, demo, and soak-test** the stack without relying on production integrations (OBS, virtual devices) or ad hoc scripts.

This phase assumes **stable protocol and FFI boundaries** from [Phase 3 — Core Features: Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md). It does not replace Phase 3 validation; it **visualizes** and **operationalizes** it.

### Important: lab tooling vs product

Be **transparent with stakeholders**: **Generator + Monitor** are **developer / lab** tools, not a substitute for a full **production** stack (OBS plugin, TLS policy, capture devices).

- **Primary path (Studio):** **VMX** (`ngmt-codec`) **encode → QUIC (`ngmt-transport`) → decode** with **real** compressed bitstreams and **OWD** timestamps on the wire — see [media payload v1](../protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path). **Pixels** are still **synthetic** test patterns (no camera), which is enough to exercise the codec and transport.
- **Monitor preview** shows **decoded** video from the VMX bitstream (with an optional **mock** mode that draws local SMPTE bars for UI layout testing).
- **Stats and UX** target **debugging, demos, and soak tests** — not certification or SLA until **v1.0** pillars close.

**v1.0** still requires the **Four Pillars** (including OBS, TLS, impairment audit) — see [version-1-release-status.md](./version-1-release-status.md) and [Phase 5](./05-Phase-5-Integrations-and-Ecosystem.md).

## Goals

### Test pattern sender

- Provide a **synthetic** audio/video source (e.g. color bars, moving patterns, tone) so encode → transport → decode can be exercised **without capture hardware**.

### Single receiver

- **One** subscribed source with fullscreen or windowed **preview** and **basic stats** (e.g. FPS, drops, latency hints) for regression and WAN debugging.

### Multiview receiver

- **Grid** or tiled layout for **multiple** sources or sessions—load testing, discovery at scale, and layout validation.

### Discovery browser

- **List** advertised sources on the LAN (mDNS / Zeroconf) and select a target to subscribe—validates discovery **without** manual IP entry or one-off scripts.

### Other debug UIs (as needed)

- Optional **connection / transport** stats panels, **log export** for lab captures, and similar tooling that speeds up day-to-day engineering.

## Implementation (repository and UI)

- **Repository:** [`ngmt-studio`](../../ngmt-studio/README.md) is a **dedicated Git repository** (sibling to `ngmt-core`, `ngmt-codec`, `ngmt-transport` in the meta-workspace). It contains a Cargo workspace: **`ngmt-generator`**, **`ngmt-monitor`**, **`ngmt-studio-common`**.
- **UI:** **egui** / **eframe** (**0.34** as of current `ngmt-studio`) for immediate-mode overlays and fast iteration. Transport uses the Rust API in [`ngmt-transport`](../../ngmt-transport/README.md) (`TransportRuntime::dial` / `accept_one`, `app_api` stats, datagram send/receive).
- **Discovery:** **`_ngmt._udp`** via [`mdns-sd`](https://crates.io/crates/mdns-sd) in `ngmt-studio-common` (browse + register). See [DNS-SD](../protocol/ngmt-wire-format.md#dns-sd) in the wire format doc for instance name and TXT semantics.
- **Primary media path:** QUIC **datagrams** carry **VMX** payloads per [media payload v1](../protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path) (NGMT object header + fragmented bitstream, `origination_timestamp_us`, width/height on fragment 0). **Generator** encodes test-pattern **BGRX** with **`VMX_EncodeBGRX`** / **`VMX_SaveTo`** and sends; **Monitor** reassembles, **`VMX_LoadFrom`** / **`VMX_DecodeBGRX`**, and uploads textures for preview. **Mock preview** in Monitor draws **local** SMPTE bars for UI-only layout testing when no feed is present. Solo/maximize is **manual** (⛶), not automatic on connect.
- **Linking:** local dev uses `path = "../ngmt-transport"` and builds **`ngmt-codec`** via `ngmt-vmx-sys`; pin engines via submodule or versioned crates for releases (documented in `ngmt-studio` README).

## Definition of Done

- [x] **Test pattern sender** is available with documented build and run steps ([`ngmt-studio/README.md`](../../ngmt-studio/README.md)).
- [x] **Single receiver** and **discovery browser** reach **usable** quality for routine debugging (Monitor: Discovery page + per-slot receiver).
- [x] **Multiview receiver** — **2×2** grid with four independent Listen/Dial slots (soak / WLAN scale-out).
- [x] Phase 4 docs **cross-link** to Phase 3 **simulation and harness** documentation for impairment testing where relevant ([`docs/testing/harness_setup.md`](../testing/harness_setup.md)).

## Out of scope

Production **OBS Studio** plugin and **virtual camera/audio** are [Phase 5 — Integrations and Ecosystem](./05-Phase-5-Integrations-and-Ecosystem.md) (**v1.0**). **SDK packaging** (Python, C++, Rust) is **Phase 5b (post-v1.0)** per the same plan.
