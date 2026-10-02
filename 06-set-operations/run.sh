#!/usr/bin/env bash
# Runs the playbook and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

ansible-playbook drift.yml >/dev/null
cat out/drift.txt

# Python orders a set of strings by a hash that changes in every process,
# unless PYTHONHASHSEED fixes it. Two fixed seeds stand for two runs.
for seed in 1 2; do
  PYTHONHASHSEED=$seed ansible-playbook drift.yml -e "run_label=seed$seed" >/dev/null
done
for kind in unsorted sorted; do
  if cmp -s "out/names-seed1-$kind.txt" "out/names-seed2-$kind.txt"; then
    echo "names, $kind: same file in both runs"
  else
    echo "names, $kind: the file differs between runs"
  fi
  echo "  run 1: $(paste -sd ' ' "out/names-seed1-$kind.txt")"
  echo "  run 2: $(paste -sd ' ' "out/names-seed2-$kind.txt")"
done
