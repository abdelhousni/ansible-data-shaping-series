#!/usr/bin/env bash
# Runs both units under systemd and prints the arguments each ExecStart=
# passed to the program, or why the unit didn't start. Needs root and a
# running systemd, as on GitHub's ubuntu runners; run.sh doesn't call it.
# Usage: sudo -E PATH="$PATH" ci/systemd-check.sh
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf out
ansible-playbook build.yml -e pg_backup_command=/usr/local/bin/show-argv >/dev/null
install -m 0755 ci/show-argv /usr/local/bin/show-argv
for way in naive escaped; do
  install -m 0644 "out/pg-backup-$way@.service" /etc/systemd/system/
done
systemctl daemon-reload
for way in naive escaped; do
  unit="pg-backup-$way@app.service"
  rm -f /run/show-argv.txt
  echo "$unit:"
  if systemctl start "$unit" 2>/dev/null; then
    sed 's/^/  /' /run/show-argv.txt
  else
    echo "  did not start: $(systemctl show -p Result --value "$unit")"
    journalctl -u "$unit" -o cat --no-pager | grep -v '^Starting\|^Failed to start' | sed 's/^/  /' | head -5
  fi
done
