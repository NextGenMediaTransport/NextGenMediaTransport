---
title: "Post–virtual-device ecosystem priorities"
phase: 5
status: living
---

# After virtual camera / virtual audio: what to build next

**Context:** [Phase 5](./05-Phase-5-Integrations-and-Ecosystem.md) targets **virtual camera** and **virtual audio** alongside the **OBS input** plugin for v1.0. Once those exist, several **NDI Tools–class** capabilities compete for engineering time. This note records a **default prioritization** informed by typical **broadcast and IT operator** needs; revisit after user research.

## Recommended order (default)

1. **Bridge / gateway (WAN ↔ LAN)** — Unlocks remote production and firewall-friendly paths where raw LAN discovery is insufficient. **QUIC** and the **security baseline** (TLS pinning / user PEM) are natural foundations; often a **headless** service rather than an egui app.
2. **Recorder / ISO (incoming NGMT to disk)** — High value for **comms verification**, **incident replay**, and **sales demos** without relying on OBS. Depends on a **file/container decision** (mezzanine vs lightweight proxy) and **clocking** semantics.
3. **Access / grouping manager** — Analogous to **NDI Access Manager**: **allowlists**, **named groups**, **WAN vs LAN profiles**. Becomes more important as bridges and remote sources multiply; can start as **config file + CLI** before a GUI.

## Tally / metadata / routing UI

- **Priority:** **After** the above unless a **hardware partner** or **house-of-worship** pilot explicitly needs **tally-first** (see [Phase 6](./06-Phase-6-Hardware-and-Commercial-Adoption.md)).
- **Rationale:** Tally and rich metadata need a **stable control-plane story** and often **PTZ** schemas; shipping tally without **bridge + security** risks wrong-footing enterprise buyers.

## Engine integrations (Unreal / Unity)

**Out of scope for this ordering doc** until **`ngmt-bindings`** (or equivalent) stabilizes. **Unreal** and **Unity** **input + output** plugins are tracked in [Phase 5 — stretch](./05-Phase-5-Integrations-and-Ecosystem.md#game-engines--unreal-and-unity-input--output) and the [studio ecosystem matrix](./studio-ecosystem-matrix.md); they typically land **after** SDKs and **OBS** prove the stack in production.

## How to use this doc

- Treat ordering as **program guidance**, not a contract.
- When research contradicts this stack (e.g. **access manager** must precede **bridge** for a customer), update this file and link the decision in [CHANGELOG](../../CHANGELOG.md) if the change is significant.

## Related documents

- [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md)
- [version-1-release-status.md](./version-1-release-status.md)
