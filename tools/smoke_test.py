#!/usr/bin/env python3
"""
Optional Phase 3 orchestration stub: run smoke binaries and collect timestamps.

When `ngmt_smoke` / full sender-receiver exist on PATH, extend this script to:
  - spawn source (e.g. Mac) and receiver (e.g. Fedora),
  - parse logs for throughput, frame late vs dropped, inter-arrival jitter.
"""

from __future__ import annotations

import subprocess
import sys
import time


def main() -> int:
    print("smoke_test.py: stub — run ngmt_smoke from ngmt-transport manually for now.")
    t0 = time.perf_counter()
    try:
        subprocess.run(["ngmt_smoke"], check=False)
    except FileNotFoundError:
        print("ngmt_smoke not on PATH; build: cargo build -p ngmt-transport --bin ngmt_smoke", file=sys.stderr)
        return 1
    print(f"elapsed_s={time.perf_counter() - t0:.3f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
