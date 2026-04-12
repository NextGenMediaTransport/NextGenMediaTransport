---
title: "NGMT desktop capture — product specification (draft)"
phase: 5
status: draft
---

# Desktop / window capture (`ngmt-capture`) — draft specification

This document specifies a **first-party screen and window capture** application analogous to **NDI Screen Capture**: real pixels → **VMX** (`ngmt-codec`) → **QUIC** (`ngmt-transport`) with **mDNS** discovery (`_ngmt._udp`), aligned with [media payload v1](../protocol/ngmt-wire-format.md#media-payload-v1-vmx-video--studio-primary-path).

**Relationship to `ngmt-studio`:** [`ngmt-generator`](../../ngmt-studio/README.md) remains the **synthetic pattern / lab** sender. **`ngmt-capture`** is the **operator** tool for production-style sources (permissions, HDR/SDR, multi-monitor). Shared Rust helpers ship from **`ngmt-studio`** as **`ngmt-common`**; **`ngmt-capture`** is its **own repository** ([`NextGenMediaTransport/ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture)) with the same sibling-checkout pattern as `ngmt-studio`.

**Program status (2026-04):** **`ngmt-capture`** on macOS has **shipped** incoming QUIC + VMX + mDNS through **v0.2** (display picker, multi-session, Studio-style UI — see the **MVP** section below). **Still missing vs goals:** per-**window/region** capture, **outgoing dial** parity with Generator, non-macOS backends, HDR/cursor, and **audio** (Phase B — wire format first). **Monitor “mirror the canvas to a second physical display”** stays **deferred** until multi-display hardware validation ([studio-next-steps](./studio-next-steps.md)).

---

## Goals

- Capture **full desktop**, **region**, or **single application window** and publish as an NGMT source discoverable on the LAN.
- Match **Generator** connection semantics (incoming vs outgoing QUIC) so **Monitor** and **OBS input** can consume the stream without special cases.
- Document **OS permissions**, **performance**, and **known limitations** (protected content, Wayland).

## Non-goals (initial release)

- **Mobile** capture (separate product / phase).
- **Audio loopback** from the system (optional later; coordinate with Phase 5 virtual audio and wire-format audio).
- **Cloud relay** without an explicit bridge (see [post-v1 ecosystem priorities](./post-v1-ecosystem-priorities.md)).

---

## Platforms and capture APIs

| OS | API direction (research / implementation) | Notes |
| -- | ------------------------------------------- | ----- |
| **macOS** | **ScreenCaptureKit** (preferred on supported releases); document **Screen Recording** privacy toggle. | Retina scaling: document logical vs physical resolution sent on the wire. |
| **Windows** | **Windows.Graphics.Capture** / DXGI **Desktop Duplication** (choose per Windows version matrix). | Multi-GPU and **protected content** paths: explicit “black frame” or failure mode. |
| **Linux** | **X11** vs **Wayland**: PipeWire / portal where required; document **which compositors** are tested. | CI may remain **headless**; manual matrix in release notes. |

---

## Permissions and UX

- **macOS:** Prompt for **Screen Recording**; link to System Settings; tray/menu-bar presence for status (sending / idle / error).
- **Windows:** If elevated or UAC edge cases exist for certain capture modes, document them.
- **Linux:** Document `xdg-desktop-portal` / Flatpak gaps if distributing as sandboxed bundle.

---

## Discovery and naming

- **DNS-SD:** Register **`_ngmt._udp`** consistent with Generator (see `ngmt-common` and [wire format](../protocol/ngmt-wire-format.md) — especially [DNS-SD: instance name and TXT](../protocol/ngmt-wire-format.md#dns-sd)).
- **Instance name:** Human-readable default (hostname + “Display 1” or window title); **user override in UI**, validated with the same **`validate_mdns_instance_label`** rules as **Generator** (single DNS label, ≤63 UTF-8 bytes, no dots — see [DNS-SD](../protocol/ngmt-wire-format.md#dns-sd)). **`ngmt-monitor`** and **OBS** browse lists should treat **Generator**, **Capture**, and any future senders with the **same** naming and TXT rules once standardized.
- **TXT records / metadata:** Follow whatever keys Studio standardizes for version and intent (align with transport registration helpers); document new keys in the wire format doc before relying on them in the field.

---

## Encode presets

- **Codec:** **VMX** only on the primary path until another profile is standardized.
- **Presets (suggested defaults):**

  | Preset | Typical use | Resolution / FPS |
  | ------ | ----------- | ---------------- |
  | **Balanced** | General desktop | 1080p or native capped to 1080p, ≤60 FPS |
  | **Low latency** | Cursor / UI heavy | 720p, ≤60 FPS, favor low buffer |
  | **High detail** | Text / spreadsheets | 1440p cap if GPU allows, document CPU cost |

- **Bitrate / QP:** Delegate to VMX encoder settings exposed by `ngmt-codec`; document “auto” vs manual.

---

## QUIC connection modes

Mirror **Generator** (see [ngmt-studio README](../../ngmt-studio/README.md)):

- **Incoming:** listen for Monitors / OBS; advertise on mDNS when enabled.
- **Outgoing:** dial a fixed host:port (e.g. Monitor waiting in incoming mode).

---

## MVP (v0.1) — shipped scope (2026-04)

Implemented in the [`ngmt-capture`](https://github.com/NextGenMediaTransport/ngmt-capture) repository:

- **macOS only (functional):** **ScreenCaptureKit** → **BGRA** sample buffers → CPU copy to tight **BGRX** (`ngmt_common::bgra_rows_to_bgrx`) → **VMX** → QUIC datagrams (**incoming** / broadcast listener; multi-subscriber fan-out like Generator).
- **Display selection (v0.2+):** After **Check permission**, the app lists **`SCShareableContent`** displays (CGDirectDisplay ID + pixel size); each **session** picks a display before **Start**. (Previously: first display only.)
- **Multi-session (v0.2+):** Up to **four** parallel sessions in one process — each has its own **listen port**, **mDNS instance name** (must stay unique on the LAN), **display**, encode knobs, **Start/Stop**, and **privacy pause**. Mirrors **multiple Generator instances** without inventing multi-track QUIC yet.
- **Operator UI:** **Generator-aligned** egui layout — themed top bar (**ON AIR** / **IDLE**), left settings scroll, **central wire preview** (BGRX → downsampled RGBA texture), resizable bottom **log**; **encode presets** (720p / 1080p / 1440p / Native from selected display).
- **mDNS:** `_ngmt._udp` with TXT **`role=capture`**, **`proto`**, **`ver`**, optional **`vw`/`vh`/`vfps`** from encode resolution + target FPS; instance name via **`validate_mdns_instance_label`** (default `ngmt-capture`, `ngmt-capture-2`, … per session row).
- **Privacy:** “Privacy pause” substitutes **SMPTE** BGRX bars while keeping QUIC + capture session alive (operator slate), per session.
- **Permissions UX:** in-app **Check permission** (`SCShareableContent::get`) and **Open Screen Recording settings** (`x-apple.systempreferences:…`).
- **Output scale:** operator sets encode **width × height** (presets or drag values) before starting (maps to SCK output size and VMX instance dimensions).
- **Linux / Windows:** stub **`eframe`** binary so **`cargo check`** passes in CI (no capture APIs).

**Display picker acceptance:** **Start** is disabled until permission is **OK**, the display list is non-empty, and no **running** peer session already uses the same **listen port** (refresh permissions after hot-plugging monitors).

**Deferred from v0.1:** HDR / cursor metadata / per-window picker / outgoing dial UI / WAN presets — see open questions below.

---

## Open questions (track before implementation)

1. **HDR** capture and tone mapping when peers expect SDR VMX profile.
2. **Cursor** inclusion toggle and metadata for receivers.
3. **Per-monitor** vs **virtual combined desktop** on Windows/macOS (macOS: per-display SCK sessions are implemented; combined-desktop semantics remain a product choice for other platforms).
4. **Installer** strategy (signed PKG/MSI) vs zip — out of scope for first technical milestone but affects permissions docs.
5. **Alpha** — transparent windows / layered UI: capture APIs often deliver **BGRA**; VMX supports **`VMX_EncodeBGRA`**, but NGMT **media payload v1** assumes opaque **BGRX** on the wire unless extended (see [pixel format and alpha](../protocol/ngmt-wire-format.md#pixel-format-and-alpha-channel-additional-feature)).

---

## Audio roadmap (Phase B: outbound system audio)

**Non-goal for initial capture releases** (see **Non-goals (initial release)** above): **audio loopback** ships only after **wire-format** and **receiver** work.

**Directions (macOS research first):** **ScreenCaptureKit** audio sample path (if exposed for the chosen content filter) vs **CoreAudio** / virtual loopback device vs a **second** `_ngmt._udp` instance carrying a future **audio payload** (simpler than muxing if v1 stays one primary video track per sender). **TCC** (screen recording vs microphone) and **DRM / mute** behavior must be documented before shipping a toggle.

**Coordination:** Extend [ngmt-wire-format](../protocol/ngmt-wire-format.md) for **track IDs**, codec (PCM vs compressed), sample rate, and **Monitor** decode/mix rules in lockstep with [Phase 5 — virtual audio](./05-Phase-5-Integrations-and-Ecosystem.md#virtual-camera-and-virtual-audio) (system devices). **Do not** invent ad hoc side channels.

**UX (when protocol exists):** Settings **Audio**: Off / System (or device); optional meter; **privacy pause** policy for audio (mute vs continue) is a product decision.

---

## Related documents

- [Studio next steps](./studio-next-steps.md)
- [Studio ecosystem matrix](./studio-ecosystem-matrix.md)
- [Phase 5 — Integrations](./05-Phase-5-Integrations-and-Ecosystem.md)
- [Phase 4 — Developer UI](./04-Phase-4-Developer-UI-and-Visibility.md)
