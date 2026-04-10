#!/usr/bin/env bash
# Apply / remove Linux netem on IFACE (Fedora 43 friendly). Requires sudo.
# Usage:
#   IFACE=wlan0 ./simulate_impairment.sh add
#   IFACE=wlan0 ./simulate_impairment.sh del
set -euo pipefail

IFACE="${IFACE:-wlan0}"
ACTION="${1:-}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run with sudo for tc." >&2
  exit 1
fi

case "${ACTION}" in
add)
  # Example: 5% loss + 100ms delay — tune for your scenario
  tc qdisc add dev "${IFACE}" root netem loss 5% delay 100ms
  echo "netem added on ${IFACE}"
  ;;
del)
  tc qdisc del dev "${IFACE}" root || true
  echo "netem removed on ${IFACE}"
  ;;
*)
  echo "Usage: IFACE=wlan0 $0 add|del" >&2
  exit 2
  ;;
esac
