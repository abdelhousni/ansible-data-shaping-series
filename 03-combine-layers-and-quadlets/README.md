# 03: Merging dicts with combine

Example for [part 3](https://til.housni.eu/ansible/combine-recursive-list-merge-postgresql-quadlets.html).

- `render-postgresql.yml` renders the `linux-system-roles.postgresql`
  role's own `postgresql.conf.j2` for two hosts, `pg-test-1` and
  `pg-prod-1`, with the `postgresql_server_conf` each inventory gives them:
  - `inventory-same-name/` defines `postgresql_server_conf` in
    `group_vars/all.yml`, `group_vars/pg_prod.yml` and
    `host_vars/pg-prod-1.yml`;
  - `inventory-layers/` names the three layers `_all`, `_group` and `_host`,
    and builds `postgresql_server_conf` from them with `combine`;
  - `run.sh` also renders the first inventory with
    `ANSIBLE_HASH_BEHAVIOUR=merge`.
- `render-quadlets.yml` builds `podman_quadlet_specs` from a base container
  spec and three containers (`vars/quadlets.yml`), in five ways: with
  `map('combine', base)`, and with the base on the left, flat, recursive,
  recursive with `list_merge='append'` and with `list_merge='append_rp'`.
  It renders every unit with the `linux-system-roles.podman` role's own
  `systemd.j2`, after the role's own key filter. It also merges the
  environment variables as dicts and writes them as `NAME=value`.

Nothing is installed or started: everything is written under `out/`.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
