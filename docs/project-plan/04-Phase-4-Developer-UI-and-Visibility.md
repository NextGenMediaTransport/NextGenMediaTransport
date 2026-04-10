---
title: "Phase 4 — Developer UI and Visibility"
phase: 4
status: planned
---

## Overview

Phase 4 delivers **first-party developer and operator tools** with **Studio Monitor–class** usability: synthetic sources, receivers, and discovery browsing so teams can **debug, demo, and soak-test** the stack without relying on production integrations (OBS, virtual devices) or ad hoc scripts.

This phase assumes **stable protocol and FFI boundaries** from [Phase 3 — Core Features: Discovery and WAN](./03-Phase-3-Core-Features-Discovery-and-WAN.md). It does not replace Phase 3 validation; it **visualizes** and **operationalizes** it.

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

## Implementation note

The **UI framework and repository layout** (e.g. dedicated `ngmt-*` app package vs. examples under existing crates) are **TBD** until **Phase 3 FFI** and public APIs are sufficiently stable to avoid churn. Document the chosen approach when Phase 4 implementation starts.

## Definition of Done

- [ ] **Test pattern sender** is available with documented build and run steps.
- [ ] **Single receiver** and **discovery browser** reach **usable** quality for routine debugging.
- [ ] **Multiview receiver** and additional inspectors are **planned or delivered** as follow-ons.
- [ ] Phase 4 docs **cross-link** to Phase 3 **simulation and harness** documentation for impairment testing where relevant.

## Out of scope

Production **OBS Studio** plugin, **virtual camera/audio**, and **SDK packaging** are [Phase 5 — Integrations and Ecosystem](./05-Phase-5-Integrations-and-Ecosystem.md).
