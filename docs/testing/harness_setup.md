# NGMT network impairment harness setup

This document describes **reproducible** WAN/WLAN simulation for NextGenMediaTransport (NGMT) validation across **Fedora 43**, **macOS (M2)**, and **Windows 11**.

## Lab roles (reference)

| Machine | Typical role |
|---------|----------------|
| **Fedora 43** | `tc` / `netem` on `wlan0` (or bridge) |
| **M2 Pro Mac** | Source + `dnctl` / `pf` impairment on `en0` |
| **Windows 11** | Receiver + **Clumsy 0.3** on Wi-Fi adapter |

Adjust interface names (`wlan0`, `en0`, etc.) to match `ip link` / System Settings.

## Fedora 43 — `tc` / `netem`

Requires root. Replace `$IFACE` (e.g. `wlan0`).

**Add** impairment (example: 5% loss + 100 ms delay):

```bash
sudo tc qdisc add dev "$IFACE" root netem loss 5% delay 100ms
```

**Remove** (cleanup):

```bash
sudo tc qdisc del dev "$IFACE" root
```

**Transparent bridge (optional):** Mac → Fedora (bridge) → Win11 with `netem` on the bridge-facing interface. Use a small mermaid sketch in your lab notes:

```mermaid
flowchart LR
  Mac["M2_Source"] --> Fedora["Fedora_bridge_netem"]
  Fedora --> Win["Win11_Receiver"]
```

## Windows 11 — Clumsy 0.3

1. Run Clumsy as Administrator.
2. Select the **wireless** or test adapter.
3. Enable filters for **drop** (%) and **delay** / **throttle** as needed.
4. Start; measure NGMT while filter is active.

## macOS (M2) — `dnctl` / `pf`

Apple’s dummynet (`dnctl`) + `pfctl` can shape traffic on a specific interface (e.g. `en0`). Exact commands vary by OS version; prefer **Network Link Conditioner** (GUI) for quick profiles, or documented `dnctl pipe` + `pf` rules for CLI reproducibility. Record the exact command sequence in your runbook when you stabilize it.

## Related

- [`wlan-simulation.md`](wlan-simulation.md) — baseline vs impaired methodology on WLAN.
- [`impairment-results.md`](impairment-results.md) — append-only log of lab runs (metrics, SHAs, tools).
- [`../../tools/simulate_impairment.sh`](../../tools/simulate_impairment.sh) — Linux helper script (repo root `tools/`).
