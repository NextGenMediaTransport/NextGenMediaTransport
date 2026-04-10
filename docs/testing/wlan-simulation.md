# WLAN simulation methodology (NGMT Phase 3)

NGMT targets **Wi-Fi last-mile** behavior: bursty loss, jitter, and multicast quirks. Two harness modes:

## 1. Distributed impairment (default without Ethernet bridge)

Each endpoint applies **local** shaping so you do not need a hardware router:

- **Fedora:** `tc netem` on `wlan0` (see [`harness_setup.md`](harness_setup.md)).
- **macOS:** `dnctl` / NLC on `en0`.
- **Windows:** Clumsy on the active Wi-Fi adapter.

**Example (Fedora, Wi-Fi-like jitter):**

```bash
sudo tc qdisc add dev wlan0 root netem loss 2% delay 50ms 10ms distribution normal
```

## 2. Baseline vs impaired

1. Run [`../../tools/pulse_check.sh`](../../tools/pulse_check.sh) for **~60 s** to capture **natural** RTT/jitter on your WLAN.
2. Add **simulated** impairment on top; avoid **double-counting** (e.g. if baseline loss is ~1%, interpret combined loss accordingly).

## Metrics

| Metric | Description |
|--------|-------------|
| **Time-to-discovery** | First mDNS/manual source callback minus `t0`. |
| **Throughput @ 2% loss** | Payload bytes/sec under documented `tc` line. |
| **Recovery time** | After path change / `tc` flush, time to steady throughput or stable RTT. |
| **Frame inter-arrival jitter** | Variance of packet/object arrival gaps (compare vs TCP-based baselines). |

## Unicast fallback

If **mDNS is filtered** by the AP, use **manual IP:port** (`ngmt::discovery::Advertiser::add_manual_source`) and document the override in test logs.
