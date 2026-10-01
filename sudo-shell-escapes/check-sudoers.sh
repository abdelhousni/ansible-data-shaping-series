#!/usr/bin/env bash
# Usage: check-sudoers.sh FILE...
# Checks sudoers files before they are installed: visudo for the syntax, then
# sudoers-policy.jq on what cvtsudoers makes of them. Prints every finding and
# exits 1 if any file has a FAIL. Needs visudo and cvtsudoers (both ship with
# sudo), jq and curl.
#
# The policy asks GTFOBins (https://gtfobins.org/) which programs work
# through sudo. It downloads https://gtfobins.org/api.json, or reads the
# file named by GTFOBINS_API to pin a saved copy.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

api=${GTFOBINS_API:-}
if [ -z "$api" ]; then
  api=$tmp/api.json
  curl -fsSL https://gtfobins.org/api.json -o "$api"
fi
jq -f "$here/gtfobins-sudo.jq" "$api" >"$tmp/gtfobins-sudo.json"

status=0
for f in "$@"; do
  if ! visudo -cqf "$f"; then
    echo "$f: FAIL visudo rejected it"
    status=1
    continue
  fi
  findings=$(cvtsudoers -e -f json "$f" \
    | jq -r --rawfile interactive "$here/interactive-commands.txt" \
         --slurpfile gtfo "$tmp/gtfobins-sudo.json" \
         -f "$here/sudoers-policy.jq")
  if [ -z "$findings" ]; then
    echo "$f: OK"
  else
    sed "s|^|$f: |" <<<"$findings"
    grep -q '^FAIL' <<<"$findings" && status=1
  fi
done

exit "$status"
