# Monitor preview: decode path and hardware decode outlook

This note captures how **ngmt-monitor** turns VMX datagrams into **egui** textures today, why **display FPS** can lag **send FPS**, and where **hardware decode** is realistic for NGMT.

## Current CPU path (VMX)

1. QUIC **recv** reassembles NGMT objects (`FragmentReassembler`).
2. Completed objects are pushed into a **bounded queue** (capacity **4**) toward the decode thread. If the queue is full, the **oldest** job is dropped and **`frames_dropped_pending`** increments (shown in the stats overlay and trace heartbeats / `metrics` lines).
3. The decode thread runs **`VMX_LoadFrom` → `VMX_DecodeBGRX`**, reuses **BGRX** and **RGBA** scratch buffers per resolution, builds an **`egui::ColorImage`**, and stores the latest `(image, object_id)` for the UI.
4. The UI thread **`take()`**s the pending image once per new `object_id` and calls **`TextureHandle::set`** with **ownership** (no per-frame `ColorImage` clone on the hot path). When a new `object_id` is uploaded, **`last_displayed_object_id`** in **`SlotStats`** updates so the **Buf x/15** HUD can show pipeline backlog vs **`last_received_object_id`** (highest `object_id` enqueued to decode after reassembly). **`15`** is **`BACKLOG_DISPLAY_MAX`** (operator scale; decode FIFO capacity remains **4**).

## Telemetry on the operator HUD

| Field | Meaning |
|--------|--------|
| **Bitrate (Mb/s)** | QUIC **`udp_rx_bytes`** delta over a **sliding ~1 s** window (spike-visible; not EMA-only). |
| **Loss %** | Approximate **path** loss from **1 s** deltas of QUIC **`lost_packets`** vs **`datagram_frames_rx`**. |
| **Buf x/y** | `min(last_received_object_id − last_displayed_object_id, y)` with **`y = 15`**. |
| **Q a/b** | Current **`decode_queue.len()`** / capacity **`b`** (`4`). |

## Phase A audio / VU

Vertical **VU** meters (−60…0 dBFS bands) are **visual only** until an **audio `track_id`** exists on the wire; levels stay **pinned low**. **Solo** is **exclusive** (one slot) and prepares for future **cpal** system output. The meter column splits **VU** vs **solo** into separate layout bands so the **🔈** control stays inside the slot frame (it used to sit below the stroked rect when the VU helper allocated the full column height).

## Operator wall (canvas) — resize handles

**egui** hit-tests the **previous frame’s** widget rectangles when deciding what is under the pointer. **Corner resize** interactors must therefore be **registered every frame** (with stable widget ids), not only on `primary_pressed`, or grips never win hover/click while the pointer sits on them.

**1080p50 budget (rule of thumb):** sustained **≤ ~20 ms** per frame for decode + swizzle + GPU upload is required for parity with a 50 fps sender. VMX is **CPU**-bound here; actual ms depends on machine, **Release** vs **Debug**, and resolution.

## VMX and platform “hardware decode”

| Topic | Notes |
|--------|--------|
| **Wire format** | Primary Studio path is **VMX** in the sense of [`ngmt-wire-format.md`](../protocol/ngmt-wire-format.md) — payload is **`VMX_SaveTo` / `VMX_LoadFrom`** bitstream data, not a generic **Annex-B H.264/H.265** elementary stream. |
| **VideoToolbox (macOS), VA-API (Linux), D3D12 Video (Windows)** | These APIs decode **standard** codecs (H.264, HEVC, AV1, …). They do **not** decode arbitrary **VMX** payloads unless **ngmt-codec** exposes a wrapped standard stream or a vendor-specific path. **Assume VMX preview stays CPU** until the codec project documents otherwise. |
| **Confirmation** | Check [`ngmt-codec`](https://github.com/NextGenMediaTransport/ngmt-codec) / **VMX** release notes for any HW offload or future bridge. |

## Where hardware decode *is* feasible

| Direction | Feasibility |
|-----------|-------------|
| **AV1 (NGMT pillar)** | When the transport carries **AV1** (or another standard codec), preview can use **VideoToolbox** / **Vulkan Video** / **VA-API** / **D3D12 Video** where the OS and GPU support the profile, then upload **NV12/P010**-style planes if **egui/wgpu** gains a matching texture path. |
| **Sidecar preview stream** | Product option: a **second** low-latency **H.264** or **AV1** stream for **Monitor preview only**, while the primary VMX path stays on the wire for lab fidelity. Requires format and security decisions. |

## Operational tips

- **Multiview UX:** select a slot by **clicking** it (selection ring); **templates** only change **layout**; **Size presets** (menu) save or apply **window size** (W×H) for the **selected** slot. **View → Log** opens the rolling log in a **separate** window. **Corner resize** uses **per-frame** grip widgets so egui’s **prev-pass** hit testing can resolve them while the pointer rests on a handle.
- Run **Generator and Monitor** with the same **`--release`** profile when comparing FPS. **`cargo run` without `--release` uses Debug**, where VMX and texture work are much slower — it is common to see **~15–22 fps** preview regardless of 720p vs 1080p while the same machine reaches **30–50+ fps** in Release.
- **Generator “VMX quality”** changes encoder **bitrate / quality**, not Monitor **decode** speed. It will not raise **`fps_dec`** / **`fps_disp`** if the bottleneck is CPU decode or GPU upload.
- After each decoded frame, the decode thread calls **`egui::Context::request_repaint()`** so the UI is not throttled waiting for the next scheduled repaint (important on macOS when repaints would otherwise batch).
- Use **Generator → Output (VMX)** to pick **720p / 1080p / 4K** before **Start stream**; 4K is CPU-heavy.
- If **Decode queue drops** rises under load, the decode + UI path is still slower than the arrival rate; reduce resolution, target FPS, or profile CPU.
