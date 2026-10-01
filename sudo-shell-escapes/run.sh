#!/usr/bin/env bash
# Renders the unsafe and the safer rules from the entry through the sudo
# role's template, then runs the CI check on both and on more-rules.sudoers.
# CI compares this output with expected.txt. GTFOBins' function lists are
# left out of the output, so that a GTFOBins update doesn't change it.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

for v in unsafe safer; do
  ansible-playbook render.yml -e "variant=$v" >/dev/null
done
echo "visudo accepted both rendered files"

for f in out/unsafe-40-postgresql out/safer-40-postgresql more-rules.sudoers; do
  if ./check-sudoers.sh "$f" >out/check.log; then
    echo "$(basename "$f"): check passed"
  else
    echo "$(basename "$f"): check failed"
  fi
  sed -E -e 's|^[^:]*: ||' \
    -e 's/(sudo functions for [^:]+): [a-z, -]+: /\1: /' out/check.log \
    | sed 's/^/  /'
done
