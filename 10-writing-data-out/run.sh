#!/usr/bin/env bash
# Writes out/caddy.json with different settings and reports what Ansible saw,
# then writes the configuration with every filter and checks the results.
# CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

# One run of write.yml: changed or not, and how many lines its diff has
write() {
  local label=$1; shift
  local output status lines
  # Only the output of the task that writes caddy.json
  output=$(ansible-playbook write.yml --diff "$@" 2>&1 | sed -n '/^TASK \[Write out\/caddy.json\]/,/^PLAY RECAP/p')
  status=$(grep -oE '^(changed|ok):' <<<"$output" | tr -d :)
  lines=$(grep -E '^[-+]' <<<"$output" | grep -cvE '^(---|\+\+\+) ' || true)
  echo "$label: $status, $lines diff lines"
}

write "first run"
write "second run, nothing changed"
write "layers merged the other way, sort_keys=true" -e layer_order=site-first
write "back to the first order, sort_keys=false" -e json_sort_keys=false
write "layers merged the other way, sort_keys=false" -e json_sort_keys=false -e layer_order=site-first
write "back to sort_keys=true" -e layer_order=site-first
write "indent=2" -e json_indent=2

ansible-playbook variants.yml >/dev/null 2>&1
echo "variants:"
for file in out/variants/*; do
  name=${file#out/variants/}
  [[ $name == *.txt ]] && continue
  if python3 -m json.tool "$file" >/dev/null 2>&1; then json="valid JSON"; else json="not JSON"; fi
  printf '  %s: %s, %s lines\n' "$name" "$json" "$(awk 'END { print NR }' "$file")"
done
echo "  first line of no-filter-template: $(head -c 40 out/variants/no-filter-template)"
echo "  Café in to_nice_json: $(grep -o '"Caf[^"]*"' out/variants/to_nice_json)"
echo "  Café with ensure_ascii=false: $(grep -o '"Caf[^"]*"' out/variants/to_nice_json-ensure_ascii-false)"
echo "  'self' in tojson: $(grep -o '"default-src [^;]*;' out/variants/tojson)"
echo "  Content-Security-Policy value in to_nice_yaml:"
grep -A3 'Content-Security-Policy:' out/variants/to_nice_yaml | tail -n +2 | sed 's/^ */    /'
echo "  Content-Security-Policy value in to_nice_yaml(width=1000):"
grep -A1 'Content-Security-Policy:' out/variants/to_nice_yaml-width-1000 | tail -n +2 | sed 's/^ */    /'
sed 's/^/  /' out/variants/yaml-round-trip.txt
