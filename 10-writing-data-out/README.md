# 10: writing data out with to_nice_json and to_nice_yaml

Example for [part 10](https://til.housni.eu/ansible/writing-data-out-to-nice-json-caddy.html).

- `vars/caddy.yml` holds part 3's Caddy site as Caddy's native JSON
  configuration, in two layers: what every server has, and what this site
  adds.
- `write.yml` merges the layers and writes `out/caddy.json` with
  `to_nice_json`, the way a deployment would. `layer_order`, `json_indent`
  and `json_sort_keys` change how.
- `variants.yml` writes the same configuration with `to_json`,
  `to_nice_json`, Jinja's `tojson`, `to_nice_yaml`, and without a filter,
  into `out/variants/`.

`run.sh` runs `write.yml` seven times and reports whether Ansible saw a
change to `caddy.json` and how many lines its diff had, then runs
`variants.yml` and checks which outputs are JSON.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt). Caddy itself isn't needed: the
JSON files were also checked with `caddy validate` from Caddy 2.10.2, which
accepted every one that `run.sh` reports as valid JSON and refused
`no-filter-template`.
