---
title: "Phase 5 — Integrations and Ecosystem"
phase: 5
status: planned
---

## Overview

A protocol succeeds when applications use it. Phase 5 delivers **first-party integrations**: an **OBS Studio** plugin, **system-level virtual camera and virtual audio** so generic apps can consume feeds, and **SDK wrappers** so developers can embed NGMT in Python, C++, and Rust.

## OBS Studio integration

### Goals

- Ship an **official, high-performance** OBS plugin supporting **sender** and **receiver** paths tuned for production workflows.
- Align with OBS platform support (Windows, macOS, Linux) per project priorities; document build against supported OBS API versions.
- Repository target: **`ngmt-obs-plugin`** (or monorepo package) as the maintained home for releases and issues.

## Virtual camera and virtual audio

### Goals

- Provide **system-level** virtual camera and virtual microphone devices so feeds appear in **browsers**, **Zoom**, **Teams**, and other apps that only enumerate standard devices—without requiring each app to link NGMT directly.
- Document OS-specific installation, permissions, and limitations (e.g. driver signing, sandboxing).

## SDK wrappers

### Goals

- Offer **simple, documented SDKs** for **Python**, **C++**, and **Rust**, mapped from the evolution of `omt-bindings` / **`ngmt-bindings`**.
- Include minimal **sender/receiver examples**, error handling patterns, and versioning policy for ABI/API stability.

## Future and stretch integrations

- **Unreal Engine** (and similar engines) may be pursued as community or follow-on work once OBS and virtual devices prove the end-to-end story; track explicitly if promoted to a numbered phase later.

## Definition of Done

- [ ] Official **OBS Studio** plugin shipped or in public beta with clear build/install docs and issue tracker.
- [ ] **Virtual camera** and **virtual audio** paths documented for target OSes; minimum supported versions stated.
- [ ] **Python**, **C++**, and **Rust** SDK wrappers published (or staged in-repo) with **examples** and packaging instructions.
- [ ] Integration guides updated when protocol or transport APIs change.
