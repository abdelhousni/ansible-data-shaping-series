#!/usr/bin/env bash
# Builds the pg_hba rules both ways on the six app hosts of inventory.yml
# and prints what each did. CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
ansible-playbook build.yml >/dev/null
cat out/build.txt
