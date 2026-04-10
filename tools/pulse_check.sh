#!/usr/bin/env bash
# Baseline RTT/jitter sample between this host and a peer (default 60s).
# Usage: ./pulse_check.sh [host]
set -euo pipefail

PEER="${1:-192.168.1.1}"
DURATION_SEC="${DURATION_SEC:-60}"

if ! command -v ping >/dev/null 2>&1; then
  echo "ping not found" >&2
  exit 1
fi

echo "Pinging ${PEER} for ${DURATION_SEC}s — record min/avg/max/stddev from summary."
ping -c "${DURATION_SEC}" "${PEER}" || true
