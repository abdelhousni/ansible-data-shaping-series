#!/usr/bin/env bash
# Runs both playbooks and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

# The settings each rendered postgresql.conf ends up with, on one line
settings() {
  grep -v '^#' "$1" | grep . | paste -sd ',' | sed 's/,/, /g'
}

ansible-playbook -i inventory-same-name render-postgresql.yml >/dev/null
ansible-playbook -i inventory-layers render-postgresql.yml >/dev/null
ANSIBLE_HASH_BEHAVIOUR=merge ansible-playbook -i inventory-same-name \
  render-postgresql.yml -e inventory_label=hash-merge >/dev/null

for label in inventory-same-name inventory-layers hash-merge; do
  echo "postgresql.conf, $label:"
  for host in pg-test-1 pg-prod-1; do
    echo "  $host: $(settings "out/$label-$host.conf")"
  done
done

ansible-playbook render-quadlets.yml >/dev/null

# Image, Network and Environment of each rendered unit, on one line
units() {
  local f line image
  for f in "$1"/*.container; do
    image=$(grep -m1 '^Image=' "$f" | cut -d= -f2- || true)
    line="$(basename "$f" .container): image ${image:-missing}"
    line+=", network $(grep -m1 '^Network=' "$f" | cut -d= -f2- || echo missing)"
    line+=", environment $(grep '^Environment=' "$f" | cut -d= -f2- | paste -sd ' ' || true)"
    echo "  $line"
  done
}

for variant in map-combine-base flat recursive append append_rp; do
  echo "quadlets, $variant:"
  units "out/$variant"
done

echo "quadlets, environment merged as dicts:"
sed 's/^/  /' out/environment-as-dicts.txt
