# Monitor preview: decode path and hardware decode outlook

This note captures how **ngmt-monitor** turns VMX datagrams into **egui** textures today, why **display FPS** can lag **send FPS**, and where **hardware decode** is realistic for NGMT.

## Current CPU path (VMX)

1. QUIC **recv** reassembles NGMT objects (`FragmentReassembler`).
2. Completed objects are pushed into a **bounded queue** (capacity **4**) toward the decode thread. If the queue is full, the **oldest** job is dropped and **`frames_dropped_pending`** increments (shown in the stats overlay and trace heartbeats / `metrics` lines).
3. The decode thread runs **`VMX_LoadFrom` → `VMX_DecodeBGRX`**, reuses **BGRX** and **RGBA** scratch buffers per resolution, builds an **`egui::ColorImage`**, and stores the latest `(image, object_id)` for the UI.
4. The UI thread **`take()`**s the pending image once per new `object_id` and calls **`TextureHandle::set`** with **ownership** (no per-frame `ColorImage` clone on the hot path).

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

- Run **Generator and Monitor** with the same **`--release`** profile when comparing FPS (Debug heavily skews VMX numbers).
- Use **Generator → Output (VMX)** to pick **720p / 1080p / 4K** before **Start stream**; 4K is CPU-heavy.
- If **Decode queue drops** rises under load, the decode + UI path is still slower than the arrival rate; reduce resolution, target FPS, or profile CPU.
