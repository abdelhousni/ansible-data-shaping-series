# 05: subelements versus product

Example for [part 5](https://til.housni.eu/ansible/subelements-versus-product-quadlet-volumes-pg-hba.html).

- `volumes.yml` loops over part 3's Quadlet containers
  (`../03-combine-layers-and-quadlets/vars/quadlets.yml`) × each container's
  own `Volume` list with `subelements('Container.Volume')`. It records the
  errors with and without `skip_missing`, pairs the volumes once php's
  `Volume` is a list, creates a directory under `out/` for every bind source
  that isn't a file, and compares the host paths that
  `linux-system-roles.podman` computes for `podman_create_host_directories`
  in 1.14.3 and on its `main` branch.
- `pg_hba.yml` builds `postgresql_pg_hba_conf` for the
  `linux-system-roles.postgresql` role: every database × every subnet with
  `product`, and each database × its own clients with `subelements`. It
  renders both with the role's own `templates/pg_hba.conf.j2` into `out/`,
  and checks what happens with no subnet left.

`vars/pg_hba.yml` holds the databases and subnets. Nothing is installed or
started; the role's template is only rendered.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
