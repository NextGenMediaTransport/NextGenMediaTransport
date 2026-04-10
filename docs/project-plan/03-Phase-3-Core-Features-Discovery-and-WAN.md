---
title: "Phase 3 — Core Features: Discovery and WAN"
phase: 3
status: in_progress
---

## Overview

Phase 3 delivers NGMT’s core differentiators versus local-only tools: **zero-configuration LAN discovery**, **QUIC transport tuned for real-world WANs** (including NAT), and **resilience** (packet-loss recovery and congestion control) suitable for the public internet. Validation includes a **network simulation test harness** so behavior under impairment is **reproducible and documented**.

## Zero-configuration local discovery (mDNS / Zeroconf)

### Goals

- Implement a module using **mDNS** (Bonjour / Zeroconf) so sources **appear automatically** on the local network without manual IP configuration—matching the best user-facing aspects of entrenched products.
- Define service types, metadata (name, resolution, capabilities), and security posture for local advertisement.

## QUIC transport and NAT traversal

### Goals

- Optimize the **QUIC** layer for **NAT traversal** and unstable paths. Treat **ICE / STUN / TURN** (or equivalent) as design inputs where needed; document the chosen architecture and failure modes.
- Prefer configurations that support **remote production** (camera across regions) as a primary use case, not only LAN.

### Current implementation (honest scope)

- **Shipped today:** [`ngmt-transport`](../../ngmt-transport/README.md) uses **direct QUIC** (Quinn) with **lab certificates** (rcgen), **BBR** congestion control, datagrams, and optional WLAN-oriented keep-alive / jitter hints via `WlanOptimization`. This is appropriate for **controlled lab, LAN, and many “known peer” WAN** setups.
- **Not implemented yet:** **STUN/TURN/ICE** mediation for arbitrary NAT topologies. If we add them later, they will be documented here with failure modes. Until then, treat “WAN” validation as **QUIC over impaired paths** (see harness docs), not full WebRTC-style NAT traversal.

## Packet-loss recovery and congestion control

### Goals

- Implement or integrate **packet-loss recovery** appropriate for media over QUIC (application semantics + transport behavior).
- Apply **congestion control** suitable for variable internet links; document tuning knobs and safe defaults for production vs. lab.

This stack is NGMT’s primary **WAN advantage** over protocols that assume a clean studio LAN.

## Network simulation test harness

### Purpose

Because WAN quality is NGMT’s main competitive angle versus NDI on bad networks, behavior must be **proven under impairment**, not only on ideal links.

### Approach

- Use platform-appropriate tools to inject **loss**, **latency**, and **jitter**:
  - **Windows:** e.g. **Clumsy** or equivalent user-space filters.
  - **Linux:** **`tc`** with **netem** (or similar) for controlled impairment.
  - **macOS:** document supported approaches (e.g. `pf`/`dnctl`, commercial or open-source shapers, or lab VLANs) and prefer reproducible scripts where possible.
- Run scenarios that stress **QUIC packet-loss recovery** and **congestion control** under documented profiles (e.g. light/moderate/heavy loss, added RTT).
- **Record methodology and results** in-repo: reproducible steps, metrics (throughput, latency, frame drops, recovery events), hardware/OS notes, and harness version.

### Deliverables

- A **documented** test harness (scripts, configs, or CI jobs where feasible) plus a **results** section or appendix that can be updated as the stack improves.

## Definition of Done

- [x] mDNS/Zeroconf discovery works for the defined LAN scenarios; UX matches “sources show up without IP wrangling.” — **First-party LAN discovery** is implemented in **`ngmt-studio`** ([`mdns-sd`](https://crates.io/crates/mdns-sd) for `_ngmt._udp`). The C++ [`ngmt-core` `Advertiser`](../../ngmt-core/include/ngmt/discovery/advertiser.hpp) remains a **facade with manual fallback** until a native mDNS backend is integrated; see [Discovery status](../../ngmt-core/docs/discovery-status.md).
- [x] QUIC path is documented for NAT/WAN including assumptions and known limitations. — See [`ngmt-transport/README.md`](../../ngmt-transport/README.md) and **Current implementation** above (direct QUIC; no STUN/TURN yet).
- [x] Packet-loss recovery and congestion control are implemented to project standards; defaults documented. — **QUIC loss recovery** via the stack; **BBR** in Quinn; [`WlanOptimization`](../../ngmt-transport/README.md) for WLAN hints; application-level media recovery is **ongoing** as the wire format evolves.
- [x] **Network simulation test harness** exists with **documented** scenarios (loss/latency/jitter) using tools such as **Clumsy** (Windows) and **`tc`/netem** (Linux), plus macOS notes. — [`docs/testing/harness_setup.md`](../testing/harness_setup.md), [`docs/testing/wlan-simulation.md`](../testing/wlan-simulation.md), scripts under `tools/`.
- [x] Published **documentation** of simulation runs, metrics, and environment so WAN behavior is auditable and repeatable. — Template and append-only log in [`docs/testing/impairment-results.md`](../testing/impairment-results.md); refresh as teams add lab runs.

## Implementation notes (Phase 3 progress)

- **Wire format:** [`docs/protocol/ngmt-wire-format.md`](../protocol/ngmt-wire-format.md)
- **Harness:** [`docs/testing/harness_setup.md`](../testing/harness_setup.md), [`docs/testing/wlan-simulation.md`](../testing/wlan-simulation.md)
- **Impairment results log:** [`docs/testing/impairment-results.md`](../testing/impairment-results.md)
- **Scripts:** `tools/pulse_check.sh`, `tools/simulate_impairment.sh`, `tools/smoke_test.py`

First-party developer tools and Studio Monitor-class UIs are delivered in Phase 4.
