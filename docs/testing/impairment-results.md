# Impairment lab results (append-only log)

This file is the **in-repo appendix** for [Phase 3 — WAN validation](../project-plan/03-Phase-3-Core-Features-Discovery-and-WAN.md): reproducible **methodology** lives in [`harness_setup.md`](harness_setup.md) and [`wlan-simulation.md`](wlan-simulation.md); **recorded runs** are logged here so behavior stays auditable over time.

## How to add an entry

1. Run a scenario from the harness docs (note exact `tc` line, Clumsy settings, or macOS tool).
2. Prefer **`NGMT_LOG_FILE`** on each Studio process (see [`harness_setup.md`](harness_setup.md)) so trace lines are **append-only to disk** for post-mortems. **Same machine, both apps:** **two paths** (e.g. `/tmp/ngmt-generator-….log` and `/tmp/ngmt-monitor-….log`) — not one shared file.
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

_No published runs yet — add the first row when you complete a documented impairment pass._
