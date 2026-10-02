# 15: set_fact in a loop or one expression

Example for [part 15](https://til.housni.eu/ansible/set-fact-loop-or-one-expression-pg-hba.html).

Part 11's `pg_hba` rules, built from the app hosts' addresses, two ways.
`inventory.yml` has six app hosts, written by `make-inventory.py 6`; every
third one from the fourth on has no address. The address is an inventory
variable, `app_ipv4`, rather than a fact, so that nothing has to be
gathered.

- `build.yml` builds the rules with `tasks/rules-loop.yml`, a `set_fact`
  loop that appends one rule per host, and with one expression, as in part
  11. It then runs the loop a second time, and tries to reset its result
  with task vars and with a later play's vars, and records what happened.
- `time.sh` times both ways, with `time-loop.yml` and
  `time-expression.yml`, on generated inventories of 100, 500 and 2000 app
  hosts. CI doesn't run it, since the times depend on the machine.

```sh
./run.sh
./time.sh          # or ./time.sh 100 500
```

Compare `run.sh`'s output with [`expected.txt`](expected.txt).
