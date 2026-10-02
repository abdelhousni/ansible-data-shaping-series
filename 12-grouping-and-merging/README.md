# 12: grouping and merging lists of dicts

Example for [part 12](https://til.housni.eu/ansible/groupby-lists-mergeby-proxmox-guests.html).

`fixtures/proxmox_vms.json` is part 4's recorded `proxmox_vm_info` output:
six guests on two nodes.

- `group.yml` groups the guests by node, status and pool with Jinja's
  `groupby`, turns its pairs into dicts, shows its `default` argument
  failing on ansible-core 2.21 (ansible/ansible#86827) and the workaround,
  and indexes the guests with `community.general.groupby_as_dict`.
- `merge.yml` joins `vars/declared.yml`, what the team declares about each
  guest, to the guests by VMID with `community.general.lists_mergeby`, with
  `recursive` and `list_merge`, and records what it drops and what makes
  it fail.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
