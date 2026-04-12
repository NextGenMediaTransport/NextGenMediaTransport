---
title: "Intercom over NGMT — R&D and product boundary"
phase: 0
status: draft
---

# Intercom over NGMT — research note (not a commitment)

**Status:** **Far future / optional.** Do **not** scope intercom work into **v1.0** or Phase 5 deliverables until this note is superseded by an **architecture decision** signed off by maintainers.

## Intent

A professional **intercom** (party-line, IFB, program feed, beltpacks) might reuse **QUIC**, **TLS identity**, and **discovery** from NGMT while carrying **low-latency audio** (and optionally video) to **desktop**, **mobile**, or **embedded** endpoints (e.g. **ESP32**-class talk/listen panels).

## Why this may be a separate product

- **Media profile:** Intercom is dominated by **duplex voice**, **mix-minus**, **PTT vs open mic**, and **group semantics** — not the **VMX-first** video path that defines NGMT v1.
- **Codec stack:** Likely **Opus** / **LC3** / similar speech codecs, **AEC**, **jitter buffers**, and optional **MCU/SFU** mixing — orthogonal to **VMX** unless deliberately unified.
- **Embedded:** ESP32-class devices imply **RAM/CPU**, **Wi-Fi**, **battery**, **certification**, and a **different support/SKU** model than **`ngmt-studio`** or **`ngmt-obs-plugin`**.

## Decision framework (when revisiting)

1. **Shared transport only:** If **`ngmt-transport`** (sessions, congestion, TLS) can be reused **without** forking the **video wire format**, intercom can be a **consumer library** in a **new repo** / product name.
2. **Split if protocol forks:** If intercom requires **guaranteed audio cadence**, **mesh**, or **congestion** behavior that complicates the **video-first** protocol, keep **network crates shared**, **protocol and brand separate**.
3. **Embedded last:** Prove **desktop + mobile** intercom before **ESP32** or partner firmware (see [Phase 6](./06-Phase-6-Hardware-and-Commercial-Adoption.md) for hardware posture).

## Checklist before any implementation spike

- [ ] Latency budget (ms) and **jitter tolerance** per use case (IFB vs general party-line).
- [ ] Topology (**mesh** vs **star** vs **SFU**) and **NAT** expectations.
- [ ] Codec choice and **interop** requirements.
- [ ] **Same repo vs new repo** and trademark / support boundaries.

## Related documents

- [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md)
- [Master roadmap](./00-Master-Roadmap.md)
