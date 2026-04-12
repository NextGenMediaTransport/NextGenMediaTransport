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
| **VMX alpha (BGRA)** | `ngmt-codec` + wire/session | **future** | NDI-style alpha | `VMX_EncodeBGRA` / `DecodeBGRA` exist; need [wire flags / payload v2](../protocol/ngmt-wire-format.md#pixel-format-and-alpha-channel-additional-feature), discovery, premult rules |
| **SDK wrappers** | `ngmt-bindings` etc. | **5b** | developer kits | Stable C ABI / docs |
| **Unreal input + output** | TBD (e.g. `ngmt-unreal-plugin`) | **post–5b stretch** | NDI for Unreal–class | VMX, QUIC, TLS, UE RHI / plugin ABI |
| **Unity input + output** | TBD (e.g. `ngmt-unity-package`) | **post–5b stretch** | NDI for Unity–class | VMX, QUIC, TLS, RP capture, IL2CPP |
| **Blender input + output** | TBD (e.g. `ngmt-blender-addon`) | **post–5b stretch** | NDI-style viewport / compositor | VMX, QUIC, TLS, Python addon API, shared core with OBS |

**Engine plugins** mirror **OBS**: **input** = NGMT → engine texture; **output** = render target / game view → NGMT. See [Phase 5 — Future and stretch](./05-Phase-5-Integrations-and-Ecosystem.md#game-engines--unreal-and-unity-input--output) and [Blender addon (stretch)](./05-Phase-5-Integrations-and-Ecosystem.md#blender-addon-stretch).

---

## Monitor gaps vs “full” broadcast monitor

Future enhancements (not v1.0 gates unless promoted):

- **Audio meters** and embedded audio monitoring.
- **Solo / fullscreen** polish (Monitor already has solo toggle).
- **Timecode / metadata** overlays when the wire format exposes them.
- **Multiview → dedicated display:** fullscreen or second window on a **user-selected monitor** showing the **same** composited wall as the main canvas (mirror-only; NDI Studio Monitor–class operator output).
- **Multiview as NGMT source:** encode the **composited** wall (BGRX → VMX → QUIC) and advertise like other senders — heavier than mirror-only; product/perf TBD.
- **Layout preset ghosts:** **Shipped in `ngmt-studio`:** templates materialize idle slots; empty cells show **hatched** placeholders with a **slot index** until a source is bound.

**Implementation order (default):** mirror multiview to external display **before** publishing multiview as a network source — see [studio-next-steps.md](./studio-next-steps.md).

---

## Reading order for integrators

1. [version-1-release-status.md](./version-1-release-status.md) — Four Pillars and gap list.
2. [studio-next-steps.md](./studio-next-steps.md) — ordered Studio / capture backlog for implementers.
3. [05-Phase-5-Integrations-and-Ecosystem.md](./05-Phase-5-Integrations-and-Ecosystem.md) — OBS input vs output policy.
4. [ngmt-wire-format.md](../protocol/ngmt-wire-format.md) — payload, OWD, and DNS-SD naming.
5. [`ngmt-obs-plugin` README](https://github.com/NextGenMediaTransport/ngmt-obs-plugin/blob/main/README.md) — OBS build notes and sibling layout.

---

## Related documents

- [studio-next-steps.md](./studio-next-steps.md) (ordered Studio / capture implementation queue)
- [post-v1 ecosystem priorities](./post-v1-ecosystem-priorities.md) (bridge vs recording vs tally)
- [intercom R&D note](./intercom-r-and-d.md) (far future; product boundary)
