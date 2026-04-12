# NGMT wire format (Phase 3)

## Endianness

All multi-byte integers are **little-endian** on the wire. Use explicit encode/decode (C++ `NgmtObjectHeader::write_le` / Rust `ngmt_object_header_*_le`) — do not cast structs blindly across FFI.

## NGMT object header (32 bytes)

MoQ-style mapping:

- **Track** ≈ `track_id` (e.g. control vs video vs audio).
- **Group** ≈ `group_id` (e.g. GOP or session group).
- **Object** ≈ `object_id` + payload; large payloads use **fragments** (`fragment_index` / `fragment_total`).

| Field | Size | Notes |
|-------|------|--------|
| `version` | 1 | `1` for Phase 3 |
| `flags` | 1 | Bitfield (TBD) |
| `reserved` | 2 | Align / future use |
| `track_id` | 4 | LE |
| `group_id` | 8 | LE |
| `object_id` | 8 | LE |
| `fragment_index` | 2 | 0-based |
| `fragment_total` | 2 | Number of fragments |
| `payload_length` | 4 | Bytes following header for this fragment |

## OMT 1.0 frame compatibility

OMT **per-frame** layout (16-byte header + extended headers + payload) remains as documented in [`../../ngmt-core/PROTOCOL.md`](../../ngmt-core/PROTOCOL.md). The packetizer may wrap OMT-encoded bytes as **payload** inside NGMT fragments.

## QUIC mapping

- **Reliable control / metadata:** QUIC **streams** (ordered).
- **Unreliable media:** QUIC **datagrams** with fragmentation via NGMT object headers.

## Media payload v1 (VMX video — Studio primary path)

Applies to **`track_id`** video (e.g. `1`) when the payload is a **VMX** bitstream from `ngmt-codec`. The 32-byte [`NgmtObjectHeader`](#ngmt-object-header-32-bytes) is unchanged; **timestamp and width/height** live in the **per-datagram body** after the header.

### Per-fragment body (bytes after the 32-byte header)

- **All fragments:** bytes `0..8` = `origination_timestamp_us` (**u64 LE**), **microseconds since Unix epoch** — **same value** on every fragment of one logical object (`object_id`).
- **Fragment `fragment_index == 0`:** bytes `8..12` = `width` (**u16 LE**), `height` (**u16 LE**); bytes `12..` = first slice of the **VMX** bitstream (from `VMX_SaveTo`).
- **Fragment `fragment_index > 0`:** bytes `8..` = continuation of the VMX bitstream (no repeated width/height).

`payload_length` in the header is the length of this **body** (including the 8-byte timestamp and any WH/VMX bytes in that fragment).

### Reassembled logical object

Concatenate VMX data in **fragment order** into a single buffer:

`[u16 width LE][u16 height LE] || vmx_bytes`

- Take width/height **only** from fragment 0 (after the 8-byte timestamp).
- Append VMX octets: fragment 0 contributes `body[12..]`; each later fragment contributes `body[8..]` (skip the 8-byte timestamp on each fragment).

Pass that buffer to **`VMX_LoadFrom`** (the first four bytes are **not** part of the VMX bitstream; they are metadata consumed before the codec buffer).

### Pixel format and alpha channel (additional feature)

**Today (media payload v1):** The Studio and documentation **primary path** treats frames as **opaque**: encode with **`VMX_EncodeBGRX`** and decode with **`VMX_DecodeBGRX`** (32 bpp, **X** unused / fully opaque). Receivers should assume **no** alpha unless a future capability says otherwise.

**Codec library capability:** `ngmt-codec` (VMX) already supports **alpha** at the API level — **`VMX_EncodeBGRA`** / **`VMX_DecodeBGRA`** (and related preview paths); see [`ngmt-codec` `vmxcodec.h`](../../ngmt-codec/src/vmxcodec.h) (`VMX_IMAGE_BGRA` / `VMX_IMAGE_BGRX`). **Transporting** alpha end-to-end is **not** specified in v1 above: the VMX bitstream may carry alpha only when the encoder was fed **BGRA**, but peers must **agree** on interpretation (compositors, OBS, and engines care about **premultiplied vs straight** alpha).

**Future NGMT work (when promoted):**

1. **Signal** on the wire that a stream/object uses **alpha** (e.g. a bit in [`flags`](#ngmt-object-header-32-bytes), a **`pixel_format`** byte in fragment 0 after width/height, or a **media payload v2** section) so receivers select **`VMX_DecodeBGRA`** and upload textures with correct blending.
2. **Discovery / session:** advertise **alpha-capable** senders in **`_ngmt._udp`** TXT or a small control stream so receivers do not assume BGRX-only.
3. **Documentation:** define **default alpha convention** (e.g. straight alpha in BGRA unless flagged) and **HDR + alpha** interaction for capture and game-engine plugins.

Until those pieces exist, treat **alpha** as an **optional product extension** layered on the same VMX object layout, not part of the v1 interoperability baseline.

### One-way delay (OWD)

`origination_timestamp_us` is stamped **once per logical object** (video frame) and **replicated on every fragment** of that object. Receivers must **not** treat `recv_time − origination_timestamp` on arbitrary fragments as path one-way delay: inter-arrival spread across many datagrams dominates.

**Recommended (Studio):** Compare the sender timestamp to the receiver’s wall time when the **first** fragment of that `object_id` is seen. `FragmentReassembler` records `first_recv_unix_us` per partial object and returns it with the completed assembly — use `first_recv_unix_us − origination_timestamp_us` for lab OWD. Using only the **last** fragment’s receive time inflates the metric when the recv task is delayed (e.g. by decode backlog on a single-threaded path).

For a coarser signal, you may still sample when reassembly completes, but prefer **first-fragment** receive time for path delay.

**Cross-host clocks (no PTP):** Both values are **Unix epoch microseconds** from each host’s `SystemTime`. If the receiver’s clock is **behind** the sender’s by more than the true one-way delay, the raw difference goes **negative**; Studio clamps to **0 ms**, so OWD can look “missing” or stuck at zero even when the path is fine. **NTP / chrony** (or PTP in a broadcast plant) improves raw `recv − send` without extra logic. A future option is **in-app skew calibration** (estimate a constant offset from warm-up samples); until then, treat asymmetric **Mac ↔ Linux** OWD as a **clock sanity** check, not a substitute for synchronized time.

**Fair FPS / load comparisons:** run Generator and Monitor with the **same** build profile (**`--release`** on both); mixing **Debug** on one host and **Release** on the other invalidates decode-rate comparisons (VMX + native code are much slower in Debug).

### Reassembly under loss

If a fragment is missing, the receiver **must not** retain partial state **indefinitely**. Implementations should **evict** incomplete objects after a timeout (e.g. **100 ms** without any new fragment for that `object_id`) and surface **incomplete frame** counters for observability.

## DNS-SD

Service type: **`_ngmt._udp`** (TXT includes port and capabilities; subject to final registry naming).

## WlanOptimization (FFI)

`WlanOptimization` toggles aggressive **keep-alive** (~20 ms optional) and **jitter buffer depth** hints for Wi-Fi PSM / loss. See `ngmt_transport.h`.
