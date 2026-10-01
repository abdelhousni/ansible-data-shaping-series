#!/usr/bin/env bash
# Renders each vars file through the sudo role's template and prints what the
# entry says about the result. CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

for v in a-one-spec b-anchors c-dict-kv; do
  ansible-playbook render.yml -e "variant=$v" >/dev/null
  f="out/$v-40-postgresql"
  echo "$v: visudo accepted it, $(grep -c '^%postgres' "$f") rule line(s), the longest $(grep '^%postgres' "$f" | awk '{ print length }' | sort -n | tail -1) characters"
done

if cmp -s out/b-anchors-40-postgresql out/c-dict-kv-40-postgresql; then
  echo "b-anchors and c-dict-kv: byte-identical"
else
  echo "b-anchors and c-dict-kv: different"
fi

if log=$(ansible-playbook render.yml -e variant=d-flat-strings 2>&1); then
  echo "d-flat-strings: visudo accepted it"
else
  echo "d-flat-strings: visudo rejected it, $(grep -c 'expected a fully-qualified path name' <<<"$log") times 'expected a fully-qualified path name'"
  echo "  first rule as rendered: $(grep -m1 -o '%postgres ALL=(root) NOPASSWD: /, u, s, r, .\{0,24\}' <<<"$log")…"
fi
test ! -e out/d-flat-strings-40-postgresql && echo "  out/d-flat-strings-40-postgresql: not written"

echo "types:"
ansible-playbook types.yml >/dev/null
sed 's/^/  /' out/types.txt
