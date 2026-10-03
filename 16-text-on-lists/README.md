# 16: text on lists, building ExecStart lines

Example for [part 16](https://til.housni.eu/ansible/execstart-lines-regex-replace-join-systemd.html).

`build.yml` builds the `ExecStart=` line of a `pg_dump` backup unit,
`pg-backup@.service`, from the options, flags and tables to exclude in
`vars/backup.yml`, with `map('regex_replace')`, `join` and `replace`. It
writes the line twice, joined as it is and escaped for systemd, as two
template units in `out/`, and records why `map('format')` can't add a
prefix.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).

`ci/systemd-check.sh` installs both units on a machine running systemd,
with `ExecStart=` pointing at `ci/show-argv` instead of `pg_dump`, starts
`pg-backup-naive@app` and `pg-backup-escaped@app`, and prints the arguments
each one received. It needs root, so CI runs it in a job of its own and
compares its output with [`ci/expected-systemd.txt`](ci/expected-systemd.txt).
