# 08: default, default(omit), mandatory and ternary

Example for [part 8](https://til.housni.eu/ansible/default-omit-mandatory-ternary-sudo-rules.html).

`render.yml` builds `user_specifications` for the
`linux-system-roles.sudo` role from the rules in `vars/rules.yml`, which
don't all set every field, renders them with the role's own
`templates/sudoers.j2`, and validates the result with `visudo`, as example
01 does. On the way it records, in `out/render.txt`:
- what `default(omit)` and `null` do inside a rule (the role's template
  fails), and what a rule without `commands` does (it disappears);
- `mandatory` on that rule;
- `default` with and without its second argument, on `''` and `null`;
- `ternary` with and without its third value;
- `default(omit)` on a module argument: a broken rule rendered with
  `validate:` and with `validate:` left out.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
