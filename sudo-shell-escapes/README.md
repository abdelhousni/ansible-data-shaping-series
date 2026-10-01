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
  sudoers files. It runs `visudo -cf`, converts each file to JSON with
  `cvtsudoers -e -f json` (aliases expanded), and applies
  `sudoers-policy.jq`, with `shell-escape-commands.txt` as the list of
  programs to refuse. It prints a `FAIL` or `WARN` line per finding and
  exits 1 on any `FAIL`. It needs visudo, cvtsudoers (both ship with sudo)
  and jq.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt). The repository's
`sudoers-policy` workflow job runs the same check as a gate on the safer
rules.
