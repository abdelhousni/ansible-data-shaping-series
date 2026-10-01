# 01: One sudoers line per command with community.general.dict_kv

Example for [part 1](https://til.housni.eu/ansible/readable-sudoers-with-dict-kv.html).

`render.yml` renders the `linux-system-roles.sudo` role's own template,
`templates/sudoers.j2`, with one of the files in `vars/`, and validates the
result with `visudo -cf` as the role does. The files land in `out/`;
nothing is installed.

| Vars file | What it shows |
|---|---|
| `a-one-spec.yml` | One `user_specifications` item with nine commands: one 434-character line |
| `b-anchors.yml` | Nine items built with a YAML anchor and the `<<` merge key |
| `c-dict-kv.yml` | The same nine items built with `map('community.general.dict_kv', 'commands') \| map('combine', …)` |
| `d-flat-strings.yml` | The commands as plain strings: `join` splits them into characters, and visudo rejects the file |
| `e-safer.yml` | `sudoedit` instead of `vim`, and `--no-pager` for `journalctl` and `systemctl status` |

`types.yml` writes the type of each step of the `dict_kv` chain to
`out/types.txt`.

```sh
./run.sh
```

prints the line count and longest line of each file, whether b and c are
byte-identical, visudo's error for d, and the types. Compare with
[`expected.txt`](expected.txt).

visudo here is the one on the machine running the example (sudo 1.9.15p5 on
Ubuntu 24.04 in CI). The entry's `sudo -l` checks ran against Rocky Linux 9
and aren't repeated here.
