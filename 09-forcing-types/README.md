# 09: forcing types and stricter conditionals

Example for [part 9](https://til.housni.eu/ansible/forcing-types-extra-vars-conditionals.html).

- `switches.yml` has two switches meant to be overridden with `-e`,
  `restart` and `max_connections`, and records for one run what `when:
  restart`, `when: restart | bool` and a comparison with 150 do, with and
  without `int`.
- `convert.yml` records what `int`, `float`, `string` and `bool` make of
  values that arrive as strings.

`run.sh` runs `switches.yml` with its defaults, with `key=value` extra vars,
with JSON extra vars, with a typo, and with
`ANSIBLE_ALLOW_BROKEN_CONDITIONALS=true`, then `convert.yml`, and prints the
deprecation warnings the typo and the setting give.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
