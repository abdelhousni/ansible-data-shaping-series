# 07: strings into structures

Example for [part 7](https://til.housni.eu/ansible/strings-into-structures-df-findmnt-from-json.html).

`parse.yml` reads recorded command output from `fixtures/`, as `register:`
would give it, and writes to `out/parse.txt` what each filter makes of it:
- `df -P -B1` with `split`, `split(none, 5)` and `regex_findall`, including a
  mount point with a space and the strings the regex returns;
- `findmnt -J -l` with `from_json` and `from_yaml`, and `findmnt -J` without
  `-l`, which is a tree;
- the mount facts of the same machine, and the two definitions of "full".

The data in `fixtures/` was recorded on 2026-10-02 on an Ubuntu 24.04
container (GNU coreutils 9.4, util-linux 2.39.3), trimmed to `/` and a
32 MiB ext4 loop image mounted at `/srv/app data`:
- `df-P-B1.txt`: `df -P -B1`;
- `findmnt-J-l.json`: `findmnt -J -b -l -o TARGET,SOURCE,FSTYPE,SIZE,USED,AVAIL,USE%`;
- `findmnt-J-tree.json`: `findmnt -J -b -o TARGET,SIZE -R /`;
- `mount_facts.json`: the `setup` module's mount facts, five keys.

`/`'s figures are a container disk with a per-session quota, which is why
so much of it is neither used nor available.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
