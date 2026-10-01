#!/usr/bin/env bash
# Usage: check-sudoers.sh FILE...
# Checks sudoers files before they are installed: visudo for the syntax, then
# sudoers-policy.jq on what cvtsudoers makes of them. Prints every finding and
# exits 1 if any file has a FAIL. Needs visudo and cvtsudoers (both ship with
# sudo) and jq.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
status=0

for f in "$@"; do
  if ! visudo -cqf "$f"; then
    echo "$f: FAIL visudo rejected it"
    status=1
    continue
  fi
  findings=$(cvtsudoers -e -f json "$f" \
    | jq -r --rawfile escapes "$here/shell-escape-commands.txt" \
         -f "$here/sudoers-policy.jq")
  if [ -z "$findings" ]; then
    echo "$f: OK"
  else
    sed "s|^|$f: |" <<<"$findings"
    grep -q '^FAIL' <<<"$findings" && status=1
  fi
done

exit "$status"
