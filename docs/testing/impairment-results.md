# Impairment lab results (append-only log)

This file is the **in-repo appendix** for [Phase 3 — WAN validation](../project-plan/03-Phase-3-Core-Features-Discovery-and-WAN.md): reproducible **methodology** lives in [`harness_setup.md`](harness_setup.md) and [`wlan-simulation.md`](wlan-simulation.md); **recorded runs** are logged here so behavior stays auditable over time.

## How to add an entry

1. Run a scenario from the harness docs (note exact `tc` line, Clumsy settings, or macOS tool).
2. Prefer **`NGMT_LOG_FILE`** on each Studio process (see [`harness_setup.md`](harness_setup.md); command templates in [`lab-log-capture.md`](lab-log-capture.md)) so trace lines are **append-only to disk** for post-mortems. **Same machine, both apps:** **two paths** (e.g. under `target/release/logs/` or `/tmp/…`) — not one shared file.
3. Record **date**, **NGMT revision** (git SHA of `ngmt-transport` / meta-repo), **OS**, **roles** (Generator, Monitor, or other).
4. Note **metrics** you care about (RTT, drops, throughput, subjective stability) and **where logs live** (paths or artifact links).
5. Append a new row or subsection below — **do not rewrite history**; add follow-up rows if you re-run the same profile after a stack change.

---

## Template row

| Date (UTC) | Transport SHA | OS | Profile (loss/delay/jitter) | Tool | Metrics / notes |
|------------|---------------|----|-----------------------------|------|-----------------|
| YYYY-MM-DD | `abcdef1` | e.g. Fedora 43 | e.g. netem 5% loss, 100 ms delay | `tc` | e.g. stable RTT ~X ms; `NGMT_LOG_FILE` paths; no UI freeze on Stop |

---

## Log

Program **methodology** for **2% / 5% / 10%** loss is in [`harness_setup.md`](harness_setup.md) (Linux **`tc` netem**). The rows below record **committed** profile definitions and **transparent** measurement status for the **Audit of Honesty** pillar — append metrics when a lab pass completes (do not invent numbers).

| Date (UTC) | Transport SHA | OS | Profile (loss/delay/jitter) | Tool | Metrics / notes |
|------------|-----------------|----|-----------------------------|------|-----------------|
| 2026-04-12 | `0238b47` | _TBD (run on Fedora x86 or similar)_ | **2%** random loss, baseline delay per harness | `tc` netem | **Pending:** run **Generator → Monitor** (or OBS input) with **`NGMT_LOG_FILE`** per [`lab-log-capture.md`](lab-log-capture.md); record RTT, drops, subjective stability, log paths. |
| 2026-04-12 | `0238b47` | _TBD_ | **5%** random loss | `tc` netem | **Pending:** same harness revision as row above; prefer second **OS + NIC class** (e.g. Apple Silicon) for cross-ecosystem comparison per [version-1-release-status.md](../project-plan/version-1-release-status.md). |
| 2026-04-12 | `0238b47` | _TBD_ | **10%** random loss | `tc` netem | **Pending:** heavy-loss sanity; document if session fails to sustain target FPS. |

_Example `tc` root qdisc (Linux; replace **`eth0`**):_ `sudo tc qdisc add dev eth0 root netem loss 2%`
