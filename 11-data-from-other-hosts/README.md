# 11: data from other hosts with extract and hostvars

Example for [part 11](https://til.housni.eu/ansible/data-from-other-hosts-extract-hostvars-pg-hba.html).

The inventory has three application servers, `app1` to `app3`, and the
PostgreSQL server `db1`, all run on the local machine. `ansible.cfg` keeps
facts between runs in `out/facts`, with the `jsonfile` fact cache.

- `record-facts.yml` stands for an earlier run that gathered facts on
  `app1`, `app2` and `db1`, but not on `app3`: it stores each host's address
  from the inventory in the fact cache.
- `pg_hba.yml` runs on `db1` and builds its `pg_hba` rules from the app
  hosts' addresses, read from their facts through `hostvars`, with
  `extract`. It writes them with the postgresql role's template to
  `out/pg_hba.conf`, and records the `extract` error and the `assert` that
  names the hosts without an address.
- `gather-missing.yml` gathers, from `db1`, the facts of the app hosts that
  have none, with `delegate_to` and `delegate_facts`.

`run.sh` runs `pg_hba.yml` with the fact cache, with `--limit db1`, and with
the cache emptied, then `gather-missing.yml`, and prints the deprecation
warning for reading a fact through its top-level variable.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
