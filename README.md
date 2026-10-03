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
| [`06-set-operations/`](06-set-operations/) | [Part 6: Set operations on lists](https://til.housni.eu/ansible/set-operations-union-difference-proxmox-drift.html) |
| [`07-strings-into-structures/`](07-strings-into-structures/) | [Part 7: Strings into structures](https://til.housni.eu/ansible/strings-into-structures-df-findmnt-from-json.html) |
| [`08-default-omit-mandatory-ternary/`](08-default-omit-mandatory-ternary/) | [Part 8: default, omit, mandatory and ternary](https://til.housni.eu/ansible/default-omit-mandatory-ternary-sudo-rules.html) |
| [`09-forcing-types/`](09-forcing-types/) | [Part 9: Forcing types and stricter conditionals](https://til.housni.eu/ansible/forcing-types-extra-vars-conditionals.html) |
| [`10-writing-data-out/`](10-writing-data-out/) | [Part 10: Writing data out with to_nice_json and to_nice_yaml](https://til.housni.eu/ansible/writing-data-out-to-nice-json-caddy.html) |
| [`11-data-from-other-hosts/`](11-data-from-other-hosts/) | [Part 11: Data from other hosts with extract and hostvars](https://til.housni.eu/ansible/data-from-other-hosts-extract-hostvars-pg-hba.html) |
| [`12-grouping-and-merging/`](12-grouping-and-merging/) | [Part 12: Grouping and merging lists of dicts](https://til.housni.eu/ansible/groupby-lists-mergeby-proxmox-guests.html) |
| [`13-json-query/`](13-json-query/) | [Part 13: json_query compared with native filters](https://til.housni.eu/ansible/json-query-jmespath-versus-native-filters.html) |
| [`14-network-data/`](14-network-data/) | [Part 14: Network data with ansible.utils](https://til.housni.eu/ansible/ansible-utils-ipaddr-pg-hba-subnets-proxmox.html) |
| [`15-set-fact-or-expression/`](15-set-fact-or-expression/) | [Part 15: set_fact in a loop or one expression](https://til.housni.eu/ansible/set-fact-loop-or-one-expression-pg-hba.html) |
| [`16-text-on-lists/`](16-text-on-lists/) | [Part 16: Text on lists, building ExecStart lines](https://til.housni.eu/ansible/execstart-lines-regex-replace-join-systemd.html) |

Looking for a technique rather than an entry? [INDEX.md](INDEX.md) maps
each problem ("turn a list of dicts into a lookup dict", "find drift between
two lists") to the filter that solves it and the file that runs it, with the
pitfalls each example records.

Related entry, outside the series:

| Directory | Entry |
|---|---|
| [`sudo-shell-escapes/`](sudo-shell-escapes/) | [Sudo rules that hand out a root shell, and a CI check that refuses them](https://til.housni.eu/linux/sudo-rules-that-hand-out-a-root-shell.html) |

## Running them

From the repository root, once the lab below is in place:

```sh
./lab/check.sh                                 # reports anything missing
PATH="$PWD/.venv/bin:$PATH" 01-readable-sudoers-with-dict-kv/run.sh
```

Everything runs on the local machine and changes nothing outside the
example's `out/` directory. Each `run.sh` prints what its entry says about
the result; its `expected.txt` holds the output it gave when the entry was
written.

The [`examples`](.github/workflows/examples.yml) workflow runs every
`run.sh` on each push and compares the output with `expected.txt`. It also
checks that `requirements.txt` still matches `requirements.in`, and its
`sudoers-policy` job runs `sudo-shell-escapes/check-sudoers.sh` as a gate
on the sudoers files rendered from the safer rules.

## Local lab

What the examples need, and how to set it up on your own machine. This is
the setup the entries were tested with, on Ubuntu 24.04; GitHub's
`ubuntu-24.04` runner, where CI runs, provides the same.

| What | Version tested | Needed by | How |
|---|---|---|---|
| Python | 3.12 | every example | your distribution's `python3.12`; ansible-core 2.21 needs 3.12 or newer |
| ansible-core, netaddr, jmespath | 2.21.4, 1.3.0, 1.1.0 | every example; netaddr for 14, jmespath for 13 | in a virtualenv, from the locked `requirements.txt` (below) |
| community.general, ansible.utils | 13.4.0, 6.1.1 | most examples; ansible.utils for 14 | `requirements.yml`, installed into `collections/` |
| Linux System Roles | `sudo` 1.5.0, `kernel_settings` 1.6.0, `postgresql` 1.9.0, `podman` 1.14.3 | 01, 02, 03, 05, 08, 11, sudo-shell-escapes | `requirements.yml`, installed into `roles/`; needs git |
| git | 2.43 | installing the roles | your distribution's `git` package |
| sudo (`visudo`, `cvtsudoers`) | 1.9.15 | 01, 08, sudo-shell-escapes | your distribution's `sudo` package, 1.9 or newer |
| jq | 1.7 | sudo-shell-escapes | your distribution's `jq` package |

```sh
python3.12 -m venv .venv
.venv/bin/pip install --require-hashes -r requirements.txt
.venv/bin/ansible-galaxy role install -r requirements.yml -p roles
.venv/bin/ansible-galaxy collection install -r requirements.yml -p collections
./lab/check.sh
```

- **The virtualenv** holds exactly the packages in `requirements.txt`, with
  their hashes. It's compiled from `requirements.in` with uv; CI's `lock`
  job fails if the two drift apart.
- **`roles/` and `collections/`** are next to the examples, and each
  example's `ansible.cfg` points at them, so nothing is installed in your
  home directory.
- **No server is needed.** Every example connects to its hosts locally, and
  works on recorded command and API output in `fixtures/` where the entry
  used a real system (Proxmox, Foreman, `df`, `findmnt`). The roles are
  used for their templates and input checks, rendered into `out/`; nothing
  is installed on the machine.
- **No container runtime either: no Docker, Podman or Kubernetes.** Part 3's
  quadlets and the `podman` system role are data: the examples render them
  into `out/` and never start a container. An example that starts target
  hosts would follow the companion inventory series, whose
  [`lab/runtime.sh`](https://github.com/abdelhousni/ansible-inventory-series/blob/main/lab/runtime.sh)
  runs them on Docker, Podman or a kind cluster, chosen with `LAB_RUNTIME`
  ([setup of each runtime](https://github.com/abdelhousni/ansible-inventory-series/blob/main/lab/RUNTIMES.md)).
- **`visudo` runs as your user**, to check the rendered sudoers files with
  `visudo -cf`; it needs no root.
- **`lab/check.sh`** checks each line of the table and prints the command
  for whatever is missing. It changes nothing.

Two things to know:

- **Part 16's systemd check runs only in CI.** `16-text-on-lists/ci/systemd-check.sh`
  installs two units and starts them, so it needs root and a machine booted
  with systemd: a VM or a disposable host, not a container. `16-text-on-lists/run.sh`
  itself runs anywhere.
- **"Ansible requires blocking IO on stdin/stdout/stderr"**: some terminals
  and sandboxes hand Ansible non-blocking output, and it refuses to run.
  The `run.sh` scripts send Ansible's output to files, which avoids it.
  To run a playbook by hand in such an environment, redirect its output to
  a file too.
