---
title: "Phase 5 — Integrations and Ecosystem"
phase: 5
status: planned
---

## Overview

A protocol succeeds when applications use it. Phase 5 delivers **first-party integrations** so NGMT is usable in real workflows.

**v1.0 (primary goals)** — The **[Four Pillars](./version-1-release-status.md#the-v10-production-bar--four-pillars)** name a **functional OBS Studio source plugin (P0)** and a **real media path** (VMX / **ngmt-codec** → QUIC → decode). For v1.0, Phase 5 focuses on:

- **OBS Studio** plugin (sender/receiver paths as scoped).
- **Virtual camera** and **virtual audio** (system-level devices so feeds appear in browsers, Zoom, Teams, and similar apps without each app linking NGMT directly).

**Phase 5b (post-v1.0)** — **SDK wrappers** (**Python**, **C++**, **Rust**) and additional ecosystem work are **not** gating v1.0; they ship after the **vertical slice** (codec → transport → OBS) is complete. See [version-1-release-status.md](./version-1-release-status.md).

**Stub / synthetic payloads:** Integrations must consume the **ngmt-codec** real media pipeline for the **primary** product path; lab **stub** payloads in Generator/Monitor are **not** sufficient for v1.0 claims — see [documentation touchpoints](./version-1-release-status.md#documentation-touchpoints--stubs-and-synthetic-payloads).

## OBS Studio integration

### Goals

- Ship an **official, high-performance** OBS plugin supporting **sender** and **receiver** paths tuned for production workflows (**v1.0 P0**).
- Align with OBS platform support (Windows, macOS, Linux) per project priorities; document build against supported OBS API versions.
- Repository target: **`ngmt-obs-plugin`** (or monorepo package) as the maintained home for releases and issues.

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

## Definition of Done

### v1.0 (Phase 5 — ships with 1.0.0 when the Four Pillars are met)

- [ ] Official **OBS Studio** plugin shipped or in public beta with clear build/install docs and issue tracker (**P0**).
- [ ] **Virtual camera** and **virtual audio** paths documented for target OSes; minimum supported versions stated.
- [ ] Integration guides updated when protocol or transport APIs change.
- [ ] Primary integration path uses **ngmt-codec** (real media), not **stub** transport payloads.

### Phase 5b (post-v1.0)

- [ ] **Python**, **C++**, and **Rust** SDK wrappers published (or staged in-repo) with **examples** and packaging instructions.
- [ ] Integration guides updated when protocol or transport APIs change.
- [ ] Optional: additional bindings or community integrations as prioritized after v1.0.
