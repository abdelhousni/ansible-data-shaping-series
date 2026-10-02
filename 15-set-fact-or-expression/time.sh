#!/usr/bin/env bash
# Times the set_fact loop and the expression on generated inventories of
# 100, 500 and 2000 app hosts. Not run by CI: the times depend on the
# machine. Usage: ./time.sh [counts...]
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p out
counts=("$@")
[ ${#counts[@]} -gt 0 ] || counts=(100 500 2000)
for count in "${counts[@]}"; do
  python3 make-inventory.py "$count" >"out/inventory-$count.yml"
  for way in loop expression; do
    start=$(date +%s.%N)
    ansible-playbook -i "out/inventory-$count.yml" "time-$way.yml" >/dev/null
    end=$(date +%s.%N)
    printf '%5s app hosts, %-10s %6.1f s\n' "$count" "$way:" "$(echo "$end - $start" | bc)"
  done
done
