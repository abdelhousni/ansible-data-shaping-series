#!/usr/bin/env bash
# Builds both ExecStart lines and prints them and the steps in between. CI
# compares this output with expected.txt. ci/systemd-check.sh runs the units
# under systemd, in a separate CI job.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
ansible-playbook build.yml >/dev/null
cat out/build.txt
