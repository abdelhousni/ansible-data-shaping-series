#!/usr/bin/env bash
# Runs switches.yml with each kind of extra var, and convert.yml, and prints
# what the entry says about each result. CI compares this output with
# expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

run() {
  local label=$1; shift
  ansible-playbook switches.yml -e "run_label=$label" "$@" >/dev/null 2>&1
  echo "$label:"
  sed 's/^/  /' "out/$label.txt"
}

run defaults
run key-value -e restart=false -e max_connections=200
run json -e '{"restart": false, "max_connections": 200}'
run typo -e restart=fasle
ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true run allow-broken -e restart=false

ansible-playbook convert.yml >/dev/null
echo "conversions:"
sed 's/^/  /' out/convert.txt

# The warnings the typo and ALLOW_BROKEN_CONDITIONALS give, without
# line numbers or paths
echo "deprecation warnings:"
{ ansible-playbook switches.yml -e run_label=typo -e restart=fasle 2>&1
  ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true ansible-playbook switches.yml -e run_label=allow-broken -e restart=false 2>&1
} | grep -o 'DEPRECATION WARNING\]: .*removed from ansible-core version [0-9.]*' | sort -u | sed 's/^/  /'
