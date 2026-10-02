#!/usr/bin/env bash
# Runs both playbooks and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

ansible-playbook volumes.yml >/dev/null
cat out/volumes.txt
echo "directories created under out/: $(cd out && find srv -type d | sort | paste -sd ' ')"

ansible-playbook pg_hba.yml >/dev/null
cat out/pg_hba.txt
for way in product subelements; do
  echo "pg_hba.conf, $way:"
  grep -v '^#' "out/pg_hba-$way.conf" | grep . | sed 's/ *$//; s/^/  /'
done
