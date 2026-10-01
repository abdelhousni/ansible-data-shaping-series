# 04: Picking from a list of dicts

Example for [part 4](https://til.housni.eu/ansible/selectattr-rejectattr-map-proxmox-guests-and-facts.html).

`picking.yml` writes `out/picking.txt`, one result per line:
- on Proxmox VE guests: `selectattr`, `rejectattr` and `map(attribute=…)`,
  `select` with no test, `match` against `search`, and what fails when some
  guests have no `pool` key;
- on the facts of a PostgreSQL host: interfaces up and down with
  `map('extract', …)` and a nested attribute, mounts low on space, `in` with a
  list and with a string, and the mount point of a path found the way
  Ansible's *Data manipulation* guide does it and with `relpath`.

The data in `fixtures/`:
- `proxmox_vms.json` is `EXPECTED_VMS_OUTPUT` from community.proxmox 2.0.0's
  `tests/unit/plugins/modules/test_proxmox_vm_info.py`, the output the
  `proxmox_vm_info` unit test expects, trimmed to nine fields. Two guests
  have no `pool`, one has an empty name and two share a name.
- `pg-prod-1_facts.json` holds the `mounts` and interface facts gathered on
  2026-10-01 with ansible-core 2.21.4 from a Rocky Linux 9.8 container,
  `pg-prod-1`. `/var/lib/pgsql` and `/srv/backups` are small ext4 images,
  filled to 94 % and 32 %, `eth1` was set down, and `/etc/resolv.conf`,
  `/etc/hostname` and `/etc/hosts` are Docker's own bind mounts.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
