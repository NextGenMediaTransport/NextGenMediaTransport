---
title: "ngmt-core discovery — FFI escape hatch (v1.0)"
status: living
---

# C++ discovery and the Rust escape hatch

**v1.0 blocker:** [`ngmt-core`](https://github.com/NextGenMediaTransport/ngmt-core) must reach **mDNS parity** with first-party tools on **`_ngmt._udp`**, or the program must ship a **documented** alternative.

## Accepted alternative (already used by OBS)

**Rust-side discovery** in [`ngmt-transport`](https://github.com/NextGenMediaTransport/ngmt-transport) exposes a stable **C ABI** (`ngmt_transport_discover_*`, DNS-SD **`_ngmt._udp`**) aligned with Studio / `ngmt-common`. Hosts that do not link C++ mDNS (e.g. **`ngmt-obs-plugin`**) browse and dial via this path today.

## Closing the pillar for `ngmt-core` C++ consumers

Pick **one** of:

1. **Native C++ mDNS** in `ngmt-core` matching [discovery-status](https://github.com/NextGenMediaTransport/ngmt-core/blob/main/docs/discovery-status.md), **or**
2. **Document + ship** the pattern: `ngmt-core` receives resolved **`host:port`** (and TXT) from a sibling **Rust** discovery worker or in-process transport FFI — same wire, single operator story.

Track implementation in [ngmt-core#1](https://github.com/NextGenMediaTransport/ngmt-core/issues/1) and the meta [version-1-release-status — gap list](version-1-release-status.md#missing-for-version-10-gap-list).
