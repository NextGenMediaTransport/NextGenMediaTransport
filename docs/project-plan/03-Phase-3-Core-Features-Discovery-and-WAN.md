---
title: "Phase 3 — Core Features: Discovery and WAN"
phase: 3
status: in_progress
---

## Overview

Phase 3 delivers NGMT’s core differentiators versus local-only tools: **zero-configuration LAN discovery**, **QUIC transport tuned for real-world WANs** (including NAT), and **resilience** (packet-loss recovery and congestion control) suitable for the public internet. Validation includes a **network simulation test harness** so behavior under impairment is **reproducible and documented**.

The **[v1.0 production bar](./version-1-release-status.md#the-v10-production-bar--four-pillars)** (Four Pillars) includes **Security Baseline**, **Audit of Honesty**, and a consistent **LAN discovery** story. Several Phase 3 items are explicit **[v1.0 BLOCKER]**s below.

## v1.0 blockers (Phase 3 scope)

These must be satisfied (or explicitly superseded by a **documented** product decision in release notes) before a **1.0.0** production-oriented release. Full program status: [version-1-release-status.md](./version-1-release-status.md).

- **[v1.0 BLOCKER] C++ mDNS parity** — **`ngmt-core`** must offer **real mDNS** aligned with Studio’s **`_ngmt._udp`** story, or a **shipped** migration plan with timeline. Today the C++ [`Advertiser`](../../ngmt-core/include/ngmt/discovery/advertiser.hpp) is a **facade + manual** fallback; see [discovery-status.md](../../ngmt-core/docs/discovery-status.md). **Escape hatch:** if a native C++ mDNS library integration **stalls**, **Rust-side discovery** (e.g. `ngmt-studio` / transport) may **resolve peers and feed addresses into `ngmt-core` via FFI** — document that path; it is a valid, often faster-to-ship v1.0 approach.

- **[v1.0 BLOCKER] Production TLS / PKI policy** — Shipped, production-oriented binaries must not rely on **lab-only** certificate generation (e.g. rcgen defaults) without an **operator-facing** policy. v1.0 does **not** require building a **Certificate Authority**; a documented approach (**self-signed with pinning**, **user-provided PEM**, rotation notes) satisfies the **Security Baseline**. See [v1.0 realities](./version-1-release-status.md#v10-realities) in the audit doc. **Implemented in `ngmt-transport` (2026-04):** environment-driven PEM trust and server identity — [`NGMT_TLS_TRUST_ANCHOR_PEM`](../../ngmt-transport/README.md#tls-modes-lab-vs-operator-pem), **`NGMT_TLS_SERVER_CERT_PEM`** / **`NGMT_TLS_SERVER_KEY_PEM`**; default lab behavior unchanged. Apps (Studio, OBS) should expose or document these for production deployments.

- **[v1.0 BLOCKER] Audit of Honesty** — [impairment-results.md](../testing/impairment-results.md) must contain **documented** runs at **2%, 5%, and 10%** packet loss (plus methodology). **Expect different results** on different **OS + NIC** combinations (e.g. **Fedora x86** vs **Apple M2**); **log both** where practical — NIC jitter behavior differs, and broadcast engineers expect that transparency.

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

### v1.0 remaining (blockers)

Phase 3 **harness and QUIC documentation** above remain **done** for phase engineering history. For **v1.0**, the **[v1.0 blockers](#v10-blockers-phase-3-scope)** section must still be closed: **C++ mDNS / FFI discovery**, **production TLS policy**, and **2/5/10% impairment** rows in the results log. Cross-pillar work (**ngmt-codec** real path, **OBS** plugin) lives in other phases; see [version-1-release-status.md](./version-1-release-status.md).

**Stub / synthetic payloads:** Lab tools may use minimal payloads for transport testing; the **v1.0 Real Media Path** requires the **ngmt-codec** pipeline on the **primary** product path — see the audit doc [documentation touchpoints](./version-1-release-status.md#documentation-touchpoints--stubs-and-synthetic-payloads).

## Implementation notes (Phase 3 progress)

- **Wire format:** [`docs/protocol/ngmt-wire-format.md`](../protocol/ngmt-wire-format.md)
- **Harness:** [`docs/testing/harness_setup.md`](../testing/harness_setup.md), [`docs/testing/wlan-simulation.md`](../testing/wlan-simulation.md)
- **Impairment results log:** [`docs/testing/impairment-results.md`](../testing/impairment-results.md)
- **Scripts:** `tools/pulse_check.sh`, `tools/simulate_impairment.sh`, `tools/smoke_test.py`

First-party developer tools and Studio Monitor-class UIs are delivered in Phase 4.
