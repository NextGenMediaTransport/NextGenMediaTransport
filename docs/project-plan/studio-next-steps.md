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

**Recently shipped (2026-04):** items **1–4** below are implemented in [`ngmt-studio`](../../ngmt-studio/README.md): wire-aligned Generator preview + send HUD; Phase 4 plan doc touch-up; Monitor template idle slots + hatched placeholders + **DnD onto ghost binds that tile**; validated editable mDNS instance name + unregister on stop; **mDNS browse upsert** (same `host:port` refreshes label/TXT) + **`ServiceRemoved`** pruning; Generator TXT **`vw` / `vh` / `vfps`** so the **rack** can show res/FPS before decode (see `ngmt-studio` CHANGELOG, [DNS-SD](../protocol/ngmt-wire-format.md#dns-sd), [ngmt-capture-spec](./ngmt-capture-spec.md)).

1. ~~**Generator — wire-faithful preview + send visibility (P0 polish)**~~ **Done**  
   - Central preview taps **pre-encode BGRX** (downsampled texture cap for 4K); HUD shows pattern, W×H, target FPS, VMX quality, mode, mDNS on/off, subscribers, `last_object_id`, send FPS EMA. **Optional follow-up:** “Wire snapshot” (bytes/frame EMA, fragment hints, `track_id` / payload label per [media payload v1](../protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path)).

2. ~~**Phase 4 plan doc — accuracy**~~ **Done**  
   - [04-Phase-4-Developer-UI-and-Visibility.md](./04-Phase-4-Developer-UI-and-Visibility.md) documents VMX datagram path + Generator preview + template idle slots; cross-links [ngmt-wire-format.md](../protocol/ngmt-wire-format.md).

3. ~~**Monitor — layout template ghost slots**~~ **Done**  
   - Templates materialize **idle** slots (`SlotTarget::None`) to the grid size; hatched placeholder + slot index until a source is bound; **drag source onto ghost** fills that slot (`bind_slot_from_payload`) — [studio-ecosystem-matrix.md](./studio-ecosystem-matrix.md).

4. ~~**Discovery — user-controlled source / instance name**~~ **Done**  
   - Generator: **editable** mDNS instance (`validate_mdns_instance_label` in `ngmt-studio-common`), default `ngmt-generator`, unregister on stream end. **TXT hints** `vw` / `vh` / `vfps` (encode W×H + target FPS) are registered with browse and documented in [ngmt-wire-format.md](../protocol/ngmt-wire-format.md#dns-sd). Further TXT keys remain **document-first** before use. **Capture** naming aligned in [ngmt-capture-spec.md](./ngmt-capture-spec.md).

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
