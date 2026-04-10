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

### One-way delay (OWD)

`origination_timestamp_us` is stamped **once per logical object** (video frame) and **replicated on every fragment** of that object. Receivers must **not** treat `recv_time − origination_timestamp` on arbitrary fragments as path one-way delay: inter-arrival spread across many datagrams dominates.

**Recommended (Studio):** Compare the sender timestamp to the receiver’s wall time when the **first** fragment of that `object_id` is seen. `FragmentReassembler` records `first_recv_unix_us` per partial object and returns it with the completed assembly — use `first_recv_unix_us − origination_timestamp_us` for lab OWD. Using only the **last** fragment’s receive time inflates the metric when the recv task is delayed (e.g. by decode backlog on a single-threaded path).

For a coarser signal, you may still sample when reassembly completes, but prefer **first-fragment** receive time for path delay.

### Reassembly under loss

If a fragment is missing, the receiver **must not** retain partial state **indefinitely**. Implementations should **evict** incomplete objects after a timeout (e.g. **100 ms** without any new fragment for that `object_id`) and surface **incomplete frame** counters for observability.

## DNS-SD

Service type: **`_ngmt._udp`** (TXT includes port and capabilities; subject to final registry naming).

## WlanOptimization (FFI)

`WlanOptimization` toggles aggressive **keep-alive** (~20 ms optional) and **jitter buffer depth** hints for Wi-Fi PSM / loss. See `ngmt_transport.h`.
