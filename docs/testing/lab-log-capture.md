# Lab log capture (Generator + Monitor)

Use this checklist to capture **Studio trace** lines for impairment runs, cross-host Mac ↔ Fedora sessions, and post-mortems. Trace format and **`NGMT_LOG_FILE`** behavior are documented in [harness_setup.md](harness_setup.md).

## Where logs go

**Recommended:** `target/<profile>/logs/` under your **`ngmt-studio`** checkout — the same directory level as **`ngmt-generator`** and **`ngmt-monitor`** (e.g. `target/release/ngmt-generator` → `target/release/logs/…`). Create the folder before the first run.

**Ways to enable file mirroring**

1. **Shell — `NGMT_LOG_FILE`** (works with `cargo run` and direct binaries). Set **before** starting the process.
2. **In-app:** **Generator** — expand **File trace** in the left panel. **Monitor** — **Sources** page or top of **Receiver** — expand **Mirror trace to disk**. Use **Save log as…** / **Open log…** for the built-in file browser, or **Default path…** / manual path, then **Apply**; **Stop file trace** closes the file (stderr only). See [ngmt-studio README](../../ngmt-studio/README.md) when using the meta-repo workspace layout. If you used the UI **before** **Apply**, the one-time `session` line may have gone to stderr only; when **Apply** opens the file, a matching `session` line is **written at the top of the file** so the log stays self-describing.

Use **two different paths** when Generator and Monitor run on the **same** host.

## Variables (both platforms)

Set the absolute path to your **`ngmt-studio`** clone:

```bash
export NGMT_ROOT="/path/to/ngmt-studio"   # e.g. ~/src/NextGenMediaTransport/ngmt-studio
export PROFILE=release                   # recommended for lab parity; use `debug` only when needed
```

Optional (see [harness_setup.md](harness_setup.md) for the full table):

```bash
# Per-process identity on every detail line (helps when merging two hosts’ logs)
export NGMT_LOG_ID=1
# Periodic compact metrics (seconds); omit or 0 = no extra `metrics |` lines (RTT/cwnd/loss/jitter).
# Default `worker` / `slot_worker` heartbeats still include send/decode/display FPS and frame ids.
export NGMT_LOG_METRICS_INTERVAL_SECS=5
```

**Default heartbeats (no env required):** Generator **`worker`** lines add **`target_fps`**, **`send_fps_ema`**, and **`last_object_id`** (correlate with Monitor’s **`last_frame_id`**). Monitor **`slot_worker`** lines add **`fps_dec`**, **`fps_disp`**, **`owd_ema_ms`**, and **`last_frame_id`**; **`datagrams=`** stays QUIC receive volume (labeled as not frame rate).

## Example: merged timeline (two hosts)

After a cross-host run, each file begins with a **`session`** line, then continues with UTC-sorted lines if you **`sort`** the combined file:

```text
2026-04-10T12:00:01.234Z [ngmt-generator] session | host=mac-studio pid=9012 profile=release
2026-04-10T12:00:01.240Z [ngmt-monitor] session | host=fedora-lab pid=4400 profile=release
2026-04-10T12:00:06.100Z [ngmt-generator] worker | dial ok (4123 ms)
2026-04-10T12:00:06.105Z [ngmt-monitor] slot_worker | slot 1 connect_to ok (4100 ms)
2026-04-10T12:00:07.000Z [ngmt-generator] worker | heartbeat frame=50 target_fps=50 send_fps_ema=49.8 last_object_id=49
2026-04-10T12:00:07.050Z [ngmt-monitor] slot_worker | slot 1 heartbeat datagrams=512 (QUIC rx; not frames) fps_dec=48.0 fps_disp=47.5 owd_ema_ms=12.3 last_frame_id=49
2026-04-10T12:00:11.000Z [ngmt-monitor] metrics | slot=1 rtt_ms=2.10 owd_ema_ms=35.0 …
```

Use **hostname or role in the filename** (e.g. `ngmt-monitor-fedora-….log`) even when `session` is present, so operators find the right attachment before opening it.

## One-time: create `logs/`

```bash
mkdir -p "${NGMT_ROOT}/target/${PROFILE}/logs"
```

## macOS (zsh/bash) — Generator

```bash
export NGMT_LOG_FILE="${NGMT_ROOT}/target/${PROFILE}/logs/ngmt-generator-$(date -u +%Y%m%dT%H%M%SZ).log"
cd "${NGMT_ROOT}" && cargo run --"${PROFILE}" --bin ngmt-generator
```

**Prebuilt binary** (from `ngmt-studio` root):

```bash
export NGMT_LOG_FILE="${NGMT_ROOT}/target/${PROFILE}/logs/ngmt-generator-$(date -u +%Y%m%dT%H%M%SZ).log"
cd "${NGMT_ROOT}" && "./target/${PROFILE}/ngmt-generator"
```

## macOS — Monitor (separate terminal)

```bash
export NGMT_LOG_FILE="${NGMT_ROOT}/target/${PROFILE}/logs/ngmt-monitor-$(date -u +%Y%m%dT%H%M%SZ).log"
cd "${NGMT_ROOT}" && cargo run --"${PROFILE}" --bin ngmt-monitor
```

## Fedora Workstation (bash) — same commands

Install build deps first: [Linux (Fedora) build guide](../build/linux-fedora.md).

Use the same **`NGMT_ROOT`**, **`PROFILE`**, **`mkdir`**, and **`cargo run`** blocks as on macOS. Paths are identical in a sibling checkout layout.

## Cross-host (Mac Generator + Fedora Monitor, etc.)

1. On **each** machine, set **`NGMT_ROOT`** to that machine’s **`ngmt-studio`** path.
2. Run **`mkdir -p …/logs`** on each.
3. Use **distinct** filenames (hostname or role in the name is fine), e.g. `ngmt-generator-mac-….log` vs `ngmt-monitor-fedora-….log`.
4. After the run, copy or reference both paths in [impairment-results.md](impairment-results.md).

## Org clones

Repositories: [github.com/orgs/NextGenMediaTransport/repositories](https://github.com/orgs/NextGenMediaTransport/repositories). Clone layout: [Linux (Fedora) build guide — §3](../build/linux-fedora.md#3-clone-the-git-repositories).

## Related

- [harness_setup.md](harness_setup.md) — `tc` / netem, **`NGMT_LOG_FILE`**, two paths on one host.
- [impairment-results.md](impairment-results.md) — append-only results log.
