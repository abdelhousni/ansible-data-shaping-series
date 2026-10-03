#!/usr/bin/env bash
# Reports what the examples need and whether this machine has it. Run it from
# the repository root, before the first run.sh. It changes nothing.
set -uo pipefail
cd "$(dirname "$0")/.."
missing=0
ok() { printf '  ok       %s\n' "$1"; }
ko() { printf '  MISSING  %s: %s\n' "$1" "$2"; missing=1; }

echo "Needed by every example:"
if [ -x .venv/bin/python ] && .venv/bin/python -c 'import sys; sys.exit(sys.version_info < (3, 12))'; then
  ok ".venv with Python $(.venv/bin/python -c 'import platform; print(platform.python_version())')"
else
  ko ".venv with Python 3.12 or newer" "python3.12 -m venv .venv (ansible-core 2.21 needs 3.12)"
fi
if [ -x .venv/bin/ansible-playbook ] && .venv/bin/ansible --version 2>/dev/null | grep -q 'core 2.21.4' \
   && .venv/bin/python -c 'import netaddr, jmespath' 2>/dev/null; then
  ok "ansible-core 2.21.4, netaddr and jmespath in .venv"
else
  ko "ansible-core 2.21.4, netaddr and jmespath in .venv" ".venv/bin/pip install --require-hashes -r requirements.txt"
fi
if [ -d collections/ansible_collections/community/general ] && [ -d collections/ansible_collections/ansible/utils ]; then
  ok "community.general and ansible.utils in collections/"
else
  ko "community.general and ansible.utils in collections/" \
    ".venv/bin/ansible-galaxy collection install -r requirements.yml -p collections"
fi
roles_ok=1
for r in sudo kernel_settings postgresql podman; do [ -d "roles/linux-system-roles.$r" ] || roles_ok=0; done
if [ "$roles_ok" = 1 ]; then
  ok "the four Linux System Roles in roles/"
else
  command -v git >/dev/null || ko "git" "install git: ansible-galaxy fetches the roles with it"
  ko "the four Linux System Roles in roles/" ".venv/bin/ansible-galaxy role install -r requirements.yml -p roles"
fi

echo "Needed by some examples:"
command -v visudo >/dev/null && ok "visudo (01, 08, sudo-shell-escapes)" \
  || ko "visudo (01, 08, sudo-shell-escapes)" "install sudo 1.9 or newer"
command -v cvtsudoers >/dev/null && ok "cvtsudoers (sudo-shell-escapes)" \
  || ko "cvtsudoers (sudo-shell-escapes)" "install sudo 1.9 or newer, which ships it"
command -v jq >/dev/null && ok "jq (sudo-shell-escapes)" || ko "jq (sudo-shell-escapes)" "install your distribution's jq package"
exit "$missing"
