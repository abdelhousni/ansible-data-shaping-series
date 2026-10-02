# 13: json_query compared with native filters

Example for [part 13](https://til.housni.eu/ansible/json-query-jmespath-versus-native-filters.html).

`fixtures/proxmox_vms.json` is part 4's recorded `proxmox_vm_info` output.
`json_query` needs the `jmespath` Python library on the controller, so
`requirements.in` now lists it.

`query.yml` runs part 4's selections twice, with `selectattr`, `map` and
`groupby`, and with `community.general.json_query`, and records whether the
results agree. It then records the JMESPath pitfalls: the three ways of
quoting a value, a bare number, and a value with a quote put into the
query.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
