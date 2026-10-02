#!/usr/bin/env bash
# Records facts for app1, app2 and db1, then builds the PostgreSQL server's
# pg_hba rules from the app hosts' facts: with the fact cache, with --limit,
# and with the cache emptied. Then gathers the missing facts from the
# PostgreSQL server. CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

pg_hba() {
  local label=$1; shift
  ansible-playbook pg_hba.yml "$@" >/dev/null 2>&1
  echo "$label:"
  sed 's/^/  /' out/pg_hba.txt
}

ansible-playbook record-facts.yml >/dev/null 2>&1
pg_hba "with the fact cache"
pg_hba "with --limit db1" --limit db1
rm -rf out/facts
pg_hba "with the fact cache emptied"

ansible-playbook record-facts.yml >/dev/null 2>&1
output=$(ansible-playbook gather-missing.yml 2>&1)
echo "gather-missing:"
sed 's/^/  /' out/gather-missing.txt
# The warning for reading a fact through its top-level variable
echo "deprecation warning:"
grep -o 'DEPRECATION WARNING\]: .*removed from ansible-core version [0-9.]*' <<<"$output" | sort -u | sed 's/^/  /'
