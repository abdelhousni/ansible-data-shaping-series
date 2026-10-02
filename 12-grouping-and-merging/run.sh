#!/usr/bin/env bash
# Groups and merges part 4's recorded Proxmox guests and prints what each
# filter returned. CI compares this output with expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
ansible-playbook group.yml >/dev/null
ansible-playbook merge.yml >/dev/null
echo "group.yml:"
sed 's/^/  /' out/group.txt
echo "merge.yml:"
sed 's/^/  /' out/merge.txt
