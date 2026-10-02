# 06: set operations on lists

Example for [part 6](https://til.housni.eu/ansible/set-operations-union-difference-proxmox-drift.html).

`drift.yml` compares the Proxmox guests declared in `vars/declared.yml` with
part 4's recorded `proxmox_vm_info` data
(`../04-picking-from-lists/fixtures/proxmox_vms.json`) and writes to `out/`:
- `drift.txt`: `unique`, `difference` both ways, `intersect`,
  `symmetric_difference` and `union` on the VMIDs, sorted and not; the same
  VMIDs declared as strings; `difference` on dicts;
- `names-<label>-unsorted.txt` and `names-<label>-sorted.txt`: every guest
  name, declared or found, from `union`.

`run.sh` runs the playbook twice more with `PYTHONHASHSEED=1` and `2`,
standing for two separate runs, and compares the name files.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
