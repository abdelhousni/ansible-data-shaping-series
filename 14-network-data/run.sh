#!/usr/bin/env bash
# Validates the client subnets and computes the guests' addresses with
# ansible.utils, and prints the results. CI compares this output with
# expected.txt.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
ansible-playbook net.yml >/dev/null
cat out/net.txt
