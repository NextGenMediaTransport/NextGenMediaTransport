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

## DNS-SD

Service type: **`_ngmt._udp`** (TXT includes port and capabilities; subject to final registry naming).

## WlanOptimization (FFI)

`WlanOptimization` toggles aggressive **keep-alive** (~20 ms optional) and **jitter buffer depth** hints for Wi-Fi PSM / loss. See `ngmt_transport.h`.
