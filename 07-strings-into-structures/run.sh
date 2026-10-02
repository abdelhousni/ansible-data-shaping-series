#!/usr/bin/env bash
# Runs the playbook and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

ansible-playbook parse.yml >/dev/null
cat out/parse.txt
