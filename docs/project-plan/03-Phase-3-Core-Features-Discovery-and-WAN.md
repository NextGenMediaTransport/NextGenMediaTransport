---
title: "Phase 3 — Core Features: Discovery and WAN"
phase: 3
status: planned
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

- [ ] mDNS/Zeroconf discovery works for the defined LAN scenarios; UX matches “sources show up without IP wrangling.”
- [ ] QUIC path is documented for NAT/WAN including assumptions and known limitations.
- [ ] Packet-loss recovery and congestion control are implemented to project standards; defaults documented.
- [ ] **Network simulation test harness** exists with **documented** scenarios (loss/latency/jitter) using tools such as **Clumsy** (Windows) and **`tc`/netem** (Linux), plus macOS notes.
- [ ] Published **documentation** of simulation runs, metrics, and environment so WAN behavior is auditable and repeatable.

## Implementation notes (Phase 3 progress)

- **Wire format:** [`docs/protocol/ngmt-wire-format.md`](../protocol/ngmt-wire-format.md)
- **Harness:** [`docs/testing/harness_setup.md`](../testing/harness_setup.md), [`docs/testing/wlan-simulation.md`](../testing/wlan-simulation.md)
- **Scripts:** `tools/pulse_check.sh`, `tools/simulate_impairment.sh`, `tools/smoke_test.py`

First-party developer tools and Studio Monitor-class UIs are delivered in Phase 4.
