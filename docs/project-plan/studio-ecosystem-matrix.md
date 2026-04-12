---
title: "Studio and ecosystem matrix (NDI-style parity)"
phase: 0
status: living
---

# Studio and ecosystem matrix

This matrix maps **NGMT first-party apps and integrations** to **roadmap phases**, **NDI Tools–style analogues**, and **dependencies** (codec, transport, TLS, wire format). It exists so **Phase 4 lab tools** are not confused with **Phase 5 production** deliverables.

| Deliverable | Repo / location | Phase | NDI analogue (approx.) | Depends on |
| ----------- | ---------------- | ----- | ---------------------- | ---------- |
| **Generator** | `ngmt-studio` (`ngmt-generator`) | 4 (done) | Test Patterns | VMX, QUIC, mDNS |
| **Monitor** | `ngmt-studio` (`ngmt-monitor`) | 4 (done) | Studio Monitor (partial) | VMX decode, QUIC, mDNS browse |
| **OBS input (source)** | `ngmt-obs-plugin` → `src/input/` | **5 — v1.0 P0** | NDI Source | libobs, VMX, QUIC, TLS policy |
| **OBS output** | `ngmt-obs-plugin` → `src/output/` | 5 — **P1** default | NDI Output | libobs, VMX encode, QUIC send |
| **Virtual camera** | TBD (Phase 5) | **5 — v1.0** | NDI Webcam | OS virtual cam APIs, decode path |
| **Virtual audio** | TBD (Phase 5) | **5 — v1.0 (scoped)** | NDI audio device patterns | OS audio plumbing, wire audio |
| **Desktop / window capture** | **`ngmt-capture`** (spec: [ngmt-capture-spec.md](./ngmt-capture-spec.md)) | 5+ | Screen Capture / HX | Capture APIs, VMX, QUIC, permissions |
| **Bridge / gateway** | TBD | post-v1 priority | Bridge | QUIC relay, TLS, ops docs |
| **Recorder / ISO** | TBD | post-v1 priority | (various ISO tools) | File format choice, mux, clocking |
| **Access / groups manager** | TBD | post-v1 + security pillar | Access Manager | TLS identity, policy UI |
| **PTZ / tally** | `ngmt-core` / hardware | 6 | tally adjacent | Control plane, schemas ([Phase 6](./06-Phase-6-Hardware-and-Commercial-Adoption.md)) |
| **SDK wrappers** | `ngmt-bindings` etc. | **5b** | developer kits | Stable C ABI / docs |

---

## Monitor gaps vs “full” broadcast monitor

Future enhancements (not v1.0 gates unless promoted):

- **Audio meters** and embedded audio monitoring.
- **Solo / fullscreen** polish (Monitor already has solo toggle).
- **Timecode / metadata** overlays when the wire format exposes them.

---

## Reading order for integrators

1. [version-1-release-status.md](./version-1-release-status.md) — Four Pillars and gap list.
2. [05-Phase-5-Integrations-and-Ecosystem.md](./05-Phase-5-Integrations-and-Ecosystem.md) — OBS input vs output policy.
3. [ngmt-wire-format.md](../protocol/ngmt-wire-format.md) — payload and OWD fields.
4. [`ngmt-obs-plugin` README](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/README.md) — OBS build notes and sibling layout.

---

## Related documents

- [post-v1 ecosystem priorities](./post-v1-ecosystem-priorities.md) (bridge vs recording vs tally)
- [intercom R&D note](./intercom-r-and-d.md) (far future; product boundary)
