#!/usr/bin/env bash
# Runs the playbook and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

ansible-playbook render.yml >/dev/null
cat out/render.txt
echo "out/40-postgresql, mode $(stat -c %a out/40-postgresql):"
grep -v '^#' out/40-postgresql | grep . | sed 's/^/  /'
echo "broken rule files written: $(cd out && ls broken-* | paste -sd ' ')"
