#!/usr/bin/env bash
# Runs both playbooks and prints what the entry says about each result. CI
# compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

for shape in as_dict dict2items name_value; do
  if log=$(ansible-playbook sysctl.yml -e "shape=$shape" 2>&1); then
    echo "kernel_settings, $shape: the role's checks passed"
  else
    echo "kernel_settings, $shape: the role's checks failed"
    grep -o "Action failed: .*" <<<"$log" | sort -u | sed 's/^Action failed: /  /'
  fi
done

missing=$(ansible localhost -m debug \
  -a "msg={{ [{'name': 'a', 'value': 1}, {'name': 'b'}] | items2dict(key_name='name', value_name='value') }}" 2>&1 || true)
echo "items2dict, an item without 'value':"
grep -o "items2dict requires [^.]*" <<<"$missing" | head -1 | sed 's/^/  /'

ansible-playbook lists-to-dicts.yml >/dev/null
cat out/lists-to-dicts.txt
