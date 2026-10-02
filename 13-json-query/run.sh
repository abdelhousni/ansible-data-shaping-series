#!/usr/bin/env bash
# Runs part 4's selections with native filters and with json_query, and
# prints both. CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
ansible-playbook query.yml >/dev/null
cat out/query.txt
