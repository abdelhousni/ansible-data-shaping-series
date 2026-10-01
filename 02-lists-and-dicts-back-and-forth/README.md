# 02: Lists and dicts back and forth

Example for [part 2](https://til.housni.eu/ansible/lists-and-dicts-dict2items-items2dict-zip.html).

- `sysctl.yml` turns a dict of PostgreSQL-related sysctl settings into
  `kernel_settings_sysctl` for the `linux-system-roles.kernel_settings` role,
  in three shapes: as is, with `dict2items`, and with
  `dict2items(key_name='name', value_name='value')`. It runs only the role's
  input checks, `tasks/assert_role_vars.yml`, so nothing on the machine
  changes.
- `lists-to-dicts.yml` writes `out/lists-to-dicts.txt`:
  - Foreman host parameters, a list of `{name, value, …}`, into a dict with
    `items2dict`;
  - Proxmox VE VMs into name → VMID and VMID → name maps, and what happens
    when two VMs share a name;
  - the podman role's own `dict2items | rejectattr | items2dict` filter on a
    quadlet spec;
  - VM names and a range of VMIDs paired with `zip`, then `dict()`, with
    enough IDs and with one too few.

The data in `fixtures/`:
- `foreman_host.json` is the `GET /api/hosts/12` response recorded in
  theforeman.foreman 5.13.0's tests (`tests/test_playbooks/fixtures/host_info-0.yml`),
  trimmed to the name, ID and parameters.
- `proxmox_vms.json` is the sample from community.proxmox 2.0.0's
  `proxmox_vm_info` documentation, trimmed to six fields.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
