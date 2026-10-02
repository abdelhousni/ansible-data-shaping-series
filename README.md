# Shaping data in Ansible: examples

Runnable examples for the **Shaping data in Ansible** series on
[til.housni.eu](https://til.housni.eu/). Each directory belongs to one entry
of the series. The data comes from tools in use here: Linux System Roles,
PostgreSQL, Foreman, Proxmox VE and Podman.

| Directory | Entry |
|---|---|
| [`01-readable-sudoers-with-dict-kv/`](01-readable-sudoers-with-dict-kv/) | [Part 1: One sudoers line per command with community.general.dict_kv](https://til.housni.eu/ansible/readable-sudoers-with-dict-kv.html) |
| [`02-lists-and-dicts-back-and-forth/`](02-lists-and-dicts-back-and-forth/) | [Part 2: Lists and dicts back and forth with dict2items, items2dict and zip](https://til.housni.eu/ansible/lists-and-dicts-dict2items-items2dict-zip.html) |
| [`03-combine-layers-and-quadlets/`](03-combine-layers-and-quadlets/) | [Part 3: Merging dicts with combine](https://til.housni.eu/ansible/combine-recursive-list-merge-postgresql-quadlets.html) |
| [`04-picking-from-lists/`](04-picking-from-lists/) | [Part 4: Picking from a list of dicts with selectattr, rejectattr and map](https://til.housni.eu/ansible/selectattr-rejectattr-map-proxmox-guests-and-facts.html) |
| [`05-subelements-and-product/`](05-subelements-and-product/) | [Part 5: subelements versus product](https://til.housni.eu/ansible/subelements-versus-product-quadlet-volumes-pg-hba.html) |

Related entry, outside the series:

| Directory | Entry |
|---|---|
| [`sudo-shell-escapes/`](sudo-shell-escapes/) | [Sudo rules that hand out a root shell, and a CI check that refuses them](https://til.housni.eu/linux/sudo-rules-that-hand-out-a-root-shell.html) |

## Running them

Everything runs on the local machine and changes nothing outside the
example's `out/` directory. From the repository root:

```sh
python3 -m venv .venv
.venv/bin/pip install --require-hashes -r requirements.txt
.venv/bin/ansible-galaxy role install -r requirements.yml -p roles
.venv/bin/ansible-galaxy collection install -r requirements.yml -p collections
PATH="$PWD/.venv/bin:$PATH" 01-readable-sudoers-with-dict-kv/run.sh
```

- `requirements.txt` locks ansible-core 2.21.4 and its dependencies, with
  hashes. It's compiled from `requirements.in` with uv.
- `requirements.yml` pins community.general 13.4.0 and four Linux System
  Roles: `sudo` 1.5.0, `kernel_settings` 1.6.0, `postgresql` 1.9.0 and
  `podman` 1.14.3.
- Each `run.sh` prints what its entry says about the result. Its
  `expected.txt` holds the output it gave when the entry was written.

The [`examples`](.github/workflows/examples.yml) workflow runs every
`run.sh` on each push and compares the output with `expected.txt`. It also
checks that `requirements.txt` still matches `requirements.in`, and its
`sudoers-policy` job runs `sudo-shell-escapes/check-sudoers.sh` as a gate
on the sudoers files rendered from the safer rules.
