# Lab log capture (Generator + Monitor)

Use this checklist to capture **Studio trace** lines for impairment runs, cross-host Mac ↔ Fedora sessions, and post-mortems. Trace format and **`NGMT_LOG_FILE`** behavior are documented in [harness_setup.md](harness_setup.md).

## Where logs go

**Recommended:** `target/<profile>/logs/` under your **`ngmt-studio`** checkout — the same directory level as **`ngmt-generator`** and **`ngmt-monitor`** (e.g. `target/release/ngmt-generator` → `target/release/logs/…`). Create the folder before the first run.

**Ways to enable file mirroring**

1. **Shell — `NGMT_LOG_FILE`** (works with `cargo run` and direct binaries). Set **before** starting the process.
2. **In-app:** **Generator** — expand **File trace** in the left panel. **Monitor** — **Sources** page or top of **Receiver** — expand **Mirror trace to disk**. Use **Default path…**, edit the path if needed, then **Apply**; **Stop file trace** closes the file (stderr only). See [ngmt-studio README](../../ngmt-studio/README.md) when using the meta-repo workspace layout.

Use **two different paths** when Generator and Monitor run on the **same** host.

## Variables (both platforms)

Set the absolute path to your **`ngmt-studio`** clone:

```bash
export NGMT_ROOT="/path/to/ngmt-studio"   # e.g. ~/src/NextGenMediaTransport/ngmt-studio
export PROFILE=release                   # recommended for lab parity; use `debug` only when needed
```

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
