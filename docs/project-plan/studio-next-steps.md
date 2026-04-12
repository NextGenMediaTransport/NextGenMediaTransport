---
title: "Studio and lab tools — next implementation steps"
phase: 4
status: living
---

# Studio and lab tools — next implementation steps

This file is the **handoff queue** for engineering agents: **ordered hints**, acceptance-style notes, and links. When an item **ships**, update this document and the meta-repo [CHANGELOG](../../CHANGELOG.md) (and the relevant app README) so the “top of queue” stays accurate.

**Repos:** [`ngmt-studio`](../../ngmt-studio/README.md) (Generator, Monitor, `ngmt-studio-common`) lives beside the meta-repo; protocol and roadmap docs live under **`docs/`** here.

---

## Ordered implementation hints

1. **Generator — wire-faithful preview + send visibility (P0 polish)**  
   - **Preview:** The main pattern preview (SMPTE, bounce, counter) must match the **same logical frame** that feeds **VMX encode** (same resolution, animation phase, cadence as the network path — see [ngmt-studio README — Generator operator visibility](../../ngmt-studio/README.md)).  
   - **HUD / summary:** Always-visible send state (pattern, W×H, target FPS, VMX quality, connection mode, port, mDNS on/off, subscriber count, `object_id` / send FPS EMA) aligned with [lab log vocabulary](../testing/lab-log-capture.md).  
   - **Optional:** “Wire snapshot” (bytes/frame EMA, fragment hints, `track_id` / payload label per [media payload v1](../protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path)).

2. **Phase 4 plan doc — accuracy**  
   - [04-Phase-4-Developer-UI-and-Visibility.md](./04-Phase-4-Developer-UI-and-Visibility.md) must describe the **VMX datagram** path (not legacy stub text). Cross-link [ngmt-wire-format.md](../protocol/ngmt-wire-format.md).

3. **Monitor — layout template ghost slots**  
   - When a **template** is selected (1×1, 2×2, 1+5, …), **empty** cells show **muted gray / hatched** placeholders (optional slot index) until a source is bound — [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md) (Monitor gaps).

4. **Discovery — user-controlled source / instance name**  
   - Today Generator registers a **fixed** mDNS instance (`ngmt-generator`); document and implement **editable instance name** + validated DNS-SD rules; optional **TXT** keys once listed in [ngmt-wire-format.md](../protocol/ngmt-wire-format.md#dns-sd). Align **Capture** naming in [ngmt-capture-spec.md](./ngmt-capture-spec.md).

5. **Monitor — multiview fullscreen to selected display (mirror)**  
   - Second window or borderless fullscreen on a **chosen monitor**; same pixels as the canvas (no new encode path). Default order: **before** “send MV as NGMT.”

6. **Monitor — send multiview as NGMT (heavy / future)**  
   - Composite wall → BGRX → VMX → QUIC as a source; separate mode or binary TBD. Depends on performance and product call.

7. **`ngmt-capture` MVP**  
   - Follow [ngmt-capture-spec.md](./ngmt-capture-spec.md); same QUIC modes as Generator so Monitor/OBS consume without special cases.

8. **Blender addon**  
   - Remains **stretch** ([Phase 5 — Blender](./05-Phase-5-Integrations-and-Ecosystem.md#blender-addon-stretch)); track in [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md).

9. **Branding — app/repo icons**  
   - [app-icons.md](../branding/app-icons.md): **SVG masters** in-repo; export **`.icns` / `.ico` / `.png`** for OS bundles and egui textures.

---

## Reading order (integrators and agents)

1. [version-1-release-status.md](./version-1-release-status.md) — Four Pillars; **program emphasis** (capture vs OBS narrative).  
2. [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md) — apps, phases, Monitor gaps.  
3. [05-Phase-5-Integrations-and-Ecosystem.md](./05-Phase-5-Integrations-and-Ecosystem.md) — OBS, virtual devices, stretch engines + Blender.  
4. [ngmt-wire-format.md](../protocol/ngmt-wire-format.md) — payload v1, **DNS-SD** naming.  
5. [ngmt-studio/README.md](../../ngmt-studio/README.md) — build, lab loop, codec knobs, planned UX.

---

## Related documents

- [post-v1-ecosystem-priorities.md](./post-v1-ecosystem-priorities.md) — bridge / recorder / access manager ordering after virtual devices.  
- [ngmt-capture-spec.md](./ngmt-capture-spec.md) — desktop capture product draft.  
- [monitor-preview-decode.md](../testing/monitor-preview-decode.md) — decode pipeline notes.
