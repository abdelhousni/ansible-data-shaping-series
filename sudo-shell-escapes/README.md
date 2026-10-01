# Sudo rules that hand out a root shell

Example for [this entry](https://til.housni.eu/linux/sudo-rules-that-hand-out-a-root-shell.html).

- `vars/unsafe.yml` holds the PostgreSQL rules first written for
  [part 1](https://til.housni.eu/ansible/readable-sudoers-with-dict-kv.html)
  of the Shaping data in Ansible series, including
  `/usr/bin/vim /var/lib/pgsql/*`. `vars/safer.yml` replaces vim with
  `sudoedit` and adds `--no-pager`.
- `render.yml` renders either one through the `linux-system-roles.sudo`
  role's template and validates it with `visudo -cf`, as the role does.
  visudo accepts both.
- `check-sudoers.sh FILE...` is the check a pipeline runs before installing
  sudoers files. For each file it runs `visudo -cf`, converts the file to
  JSON with `cvtsudoers -e -f json` (aliases expanded), and applies
  `sudoers-policy.jq`. It prints a `FAIL` or `WARN` line per finding and
  exits 1 on any `FAIL`. The policy uses:
  - `interactive-commands.txt`: shells, editors, pagers, mail and terminal
    programs, refused whatever their arguments;
  - [GTFOBins](https://gtfobins.org/): `gtfobins-sudo.jq` turns its
    `api.json` into the functions each program has through sudo. The
    script downloads `https://gtfobins.org/api.json`, or reads the file
    named by `GTFOBINS_API`. GTFOBins is GPL-3.0 and isn't copied here.
- `more-rules.sudoers` has one rule per case the check knows about.

It needs visudo, cvtsudoers (both ship with sudo), jq and curl.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt). `run.sh` leaves GTFOBins'
function lists out of its output, so that a GTFOBins update doesn't change
it. The repository's `sudoers-policy` workflow job runs the same check as a
gate on the safer rules.
