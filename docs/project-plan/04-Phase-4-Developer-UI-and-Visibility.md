---
title: "Phase 4 — Developer UI and Visibility"
phase: 4
status: in_progress
---

## Overview

Phase 4 delivers **first-party developer and operator tools** with **Studio Monitor–class** usability: synthetic sources, receivers, and discovery browsing so teams can **debug, demo, and soak-test** the stack without relying on production integrations (OBS, virtual devices) or ad hoc scripts.

This phase assumes **stable protocol and FFI boundaries** from [Phase 3 — Core Features: Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md). It does not replace Phase 3 validation; it **visualizes** and **operationalizes** it.

### Important: not “real world” yet

Be **transparent with stakeholders**: **Generator + Monitor today are lab / developer tooling**, not a stand-in for a finished NGMT production path.

- **No real encode → transport → decode video chain:** QUIC datagrams use a **minimal stub payload** (e.g. `frame=N` text plus headers), **not** encoded frames, camera pixels, or shipping-grade NGMT media objects.
- **Monitor “preview”** draws **locally reconstructed** test patterns (e.g. SMPTE-style bars) so operators can *see* that packets arrived; it does **not** decode a transported image.
- **Stats and UX** target **debugging, demos, and soak tests** — not certification, SLA, or “this is how NGMT ships to end users.”

Later phases (codec stack, capture, integrations) are where **real-world** behavior is defined. Until then, treat Studio as **instrumentation on the transport layer**, not a productized video pipeline.

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
- **UI:** **egui** / **eframe** (0.29) for immediate-mode overlays and fast iteration. Transport uses the Rust API in [`ngmt-transport`](../../ngmt-transport/README.md) (`TransportRuntime::dial` / `accept_one`, `app_api` stats, datagram send/receive).
- **Discovery:** **`_ngmt._udp`** via [`mdns-sd`](https://crates.io/crates/mdns-sd) in `ngmt-studio-common` (browse + register).
- **Monitor preview:** QUIC datagrams carry a minimal `frame=N` text body (not raw pixels); the Monitor draws a **SMPTE-style bar pattern** locally to match the Generator preview once frames arrive. Solo/maximize is **manual** (⛶), not automatic on connect.
- **Linking:** local dev uses `path = "../ngmt-transport"`; pin engines via submodule or versioned crates for releases (documented in `ngmt-studio` README).

## Definition of Done

- [x] **Test pattern sender** is available with documented build and run steps ([`ngmt-studio/README.md`](../../ngmt-studio/README.md)).
- [x] **Single receiver** and **discovery browser** reach **usable** quality for routine debugging (Monitor: Discovery page + per-slot receiver).
- [x] **Multiview receiver** — **2×2** grid with four independent Listen/Dial slots (soak / WLAN scale-out).
- [x] Phase 4 docs **cross-link** to Phase 3 **simulation and harness** documentation for impairment testing where relevant ([`docs/testing/harness_setup.md`](../testing/harness_setup.md)).

## Out of scope

Production **OBS Studio** plugin, **virtual camera/audio**, and **SDK packaging** are [Phase 5 — Integrations and Ecosystem](./05-Phase-5-Integrations-and-Ecosystem.md).
