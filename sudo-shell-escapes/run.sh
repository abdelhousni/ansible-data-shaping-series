#!/usr/bin/env bash
# Renders the unsafe and the safer rules from the entry through the sudo
# role's template, then runs the CI check on both. CI compares this output
# with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

for v in unsafe safer; do
  ansible-playbook render.yml -e "variant=$v" >/dev/null
done
echo "visudo accepted both files"

for v in unsafe safer; do
  if ./check-sudoers.sh "out/$v-40-postgresql" >out/$v.log; then
    echo "$v: check passed"
  else
    echo "$v: check failed"
  fi
  sed 's|^out/[^:]*: |  |' "out/$v.log"
done
