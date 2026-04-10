# Impairment lab results (append-only log)

This file is the **in-repo appendix** for [Phase 3 — WAN validation](../project-plan/03-Phase-3-Core-Features-Discovery-and-WAN.md): reproducible **methodology** lives in [`harness_setup.md`](harness_setup.md) and [`wlan-simulation.md`](wlan-simulation.md); **recorded runs** are logged here so behavior stays auditable over time.

## How to add an entry

1. Run a scenario from the harness docs (note exact `tc` line, Clumsy settings, or macOS tool).
2. Record **date**, **NGMT revision** (git SHA of `ngmt-transport` / meta-repo), **OS**, **roles** (Generator, Monitor, or other).
3. Note **metrics** you care about (RTT, drops, throughput, subjective stability).
4. Append a new row or subsection below — **do not rewrite history**; add follow-up rows if you re-run the same profile after a stack change.

---

## Template row

| Date (UTC) | Transport SHA | OS | Profile (loss/delay/jitter) | Tool | Metrics / notes |
|------------|---------------|----|-----------------------------|------|-----------------|
| YYYY-MM-DD | `abcdef1` | e.g. Fedora 43 | e.g. netem 5% loss, 100 ms delay | `tc` | e.g. stable RTT ~X ms; no UI freeze on Stop |

---

## Log

_No published runs yet — add the first row when you complete a documented impairment pass._
