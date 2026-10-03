# Technique index

The [README](README.md) lists the examples by entry. This page lists them by
the problem they solve, so you can find "how do I…" without opening each
one. Every path is relative to the repository root, and every example runs
with its `run.sh` (see [Running them](README.md#running-them)); CI compares
its output with the example's `expected.txt`.

Filters without a prefix come with ansible-core or Jinja. `community.general.`
and `ansible.utils.` filters come from collections pinned in
`requirements.yml`.

## Reshaping data

| To… | Use | Where |
|---|---|---|
| Turn a dict into a list of `{key, value}` items, with your own key names | `dict2items(key_name=…, value_name=…)` | `02-lists-and-dicts-back-and-forth/sysctl.yml` |
| Turn a list of `{name, value}` into a dict | `items2dict` | `02-lists-and-dicts-back-and-forth/lists-to-dicts.yml` |
| Build name → ID and ID → name maps, and see what duplicate names do | `items2dict`, `zip`, `dict()` | `02-lists-and-dicts-back-and-forth/lists-to-dicts.yml` |
| Turn a list of dicts into a lookup dict of whole items, by a unique key | `community.general.groupby_as_dict` (fails on a duplicate, on purpose) | `12-grouping-and-merging/group.yml` |
| Drop keys from a dict | `dict2items \| rejectattr \| items2dict` | `02-lists-and-dicts-back-and-forth/lists-to-dicts.yml` |
| Pair two lists into a dict | `zip`, then `dict()`; `zip_longest` to keep the extras | `02-lists-and-dicts-back-and-forth/lists-to-dicts.yml` |
| Wrap each item of a list in a dict, then add shared keys | `map('community.general.dict_kv', …) \| map('combine', …)` | `01-readable-sudoers-with-dict-kv/vars/c-dict-kv.yml` |
| Write repeated items once with YAML alone | anchors and the `<<` merge key | `01-readable-sudoers-with-dict-kv/vars/b-anchors.yml` |

## Merging

| To… | Use | Where |
|---|---|---|
| Layer defaults, group and host values into one dict | named layers + `combine` | `03-combine-layers-and-quadlets/inventory-layers/` |
| See why same-named vars in `group_vars`/`host_vars` don't merge | `ANSIBLE_HASH_BEHAVIOUR=merge`, compared | `03-combine-layers-and-quadlets/inventory-same-name/` |
| Apply a base spec to each item of a list | `map('combine', base)` | `03-combine-layers-and-quadlets/render-quadlets.yml` |
| Merge nested dicts and choose what happens to lists | `combine(recursive=true, list_merge='append' \| 'append_rp')` | `03-combine-layers-and-quadlets/render-quadlets.yml` |
| Join two lists of dicts on a key | `community.general.lists_mergeby` (`recursive`, `list_merge`) | `12-grouping-and-merging/merge.yml` |
| Merge layered JSON config, then write it out | `combine` + `to_nice_json` | `10-writing-data-out/write.yml`, `templates/caddy.json.j2` |

## Selecting and grouping

| To… | Use | Where |
|---|---|---|
| Keep or drop list items by attribute | `selectattr`, `rejectattr`, `map(attribute=…)` | `04-picking-from-lists/picking.yml` |
| Select or map when some items lack the key | `selectattr('pool', 'defined')` first, or `map(attribute=…, default=…)` | `04-picking-from-lists/picking.yml` |
| Match a field that starts with, or contains, a string | the `match` test is anchored, `search` isn't | `04-picking-from-lists/picking.yml` |
| Look items up by key in another structure | `map('extract', …)` | `04-picking-from-lists/picking.yml` |
| Find the mount point that holds a path | facts + `relpath` | `04-picking-from-lists/picking.yml` |
| Group a list of dicts by an attribute | Jinja `groupby`, `community.general.groupby_as_dict` | `12-grouping-and-merging/group.yml` |
| Query with JMESPath, and compare with native filters | `community.general.json_query` | `13-json-query/query.yml` |
| Put an Ansible variable into a JMESPath query safely | `to_json` between backticks, or a native filter | `13-json-query/query.yml` |

## Combining lists

| To… | Use | Where |
|---|---|---|
| Loop over each item × its own sub-list | `subelements` (`skip_missing`) | `05-subelements-and-product/volumes.yml` |
| Build every database × every subnet | `product` | `05-subelements-and-product/pg_hba.yml` |
| Find drift between declared and actual inventory, in both directions | `difference`, `intersect`, `symmetric_difference`, `union` | `06-set-operations/drift.yml` |
| Compare IDs that arrive as strings with IDs that are numbers | `map('int')` before the set operation | `06-set-operations/drift.yml` |
| Deduplicate | `unique` | `06-set-operations/drift.yml` |

## Text

| To… | Use | Where |
|---|---|---|
| Parse columns of command output | `split`, `split(none, 5)`, `regex_findall` | `07-strings-into-structures/parse.yml` |
| Parse JSON command output (flat or a tree) | `from_json`, `from_yaml` | `07-strings-into-structures/parse.yml` |
| Add a prefix to every item and join them into one line | `map('regex_replace', …)`, `join` | `16-text-on-lists/build.yml` |
| Turn a dict of options into `--key=value` arguments | `items \| map('join', '=') \| map('regex_replace', '^', '--')` | `16-text-on-lists/build.yml` |
| Escape a command line for systemd `ExecStart=` | `replace` | `16-text-on-lists/build.yml` |
| Count the backslashes in a `regex_replace` replacement | one in a block scalar or single quotes, two in double quotes | `16-text-on-lists/build.yml` |
| Write `NAME=value` lines from a dict | `combine`, then a `for name, value in ….items()` loop | `03-combine-layers-and-quadlets/render-quadlets.yml` |

## Defaults, types and output

| To… | Use | Where |
|---|---|---|
| Leave a module argument out when a value is missing | `default(omit)` | `08-default-omit-mandatory-ternary/render.yml` |
| Fail clearly when a value is missing | `mandatory` | `08-default-omit-mandatory-ternary/render.yml` |
| Treat `''` and `null` as missing | `default(…, true)` | `08-default-omit-mandatory-ternary/render.yml` |
| Pick between two or three values | `ternary` | `08-default-omit-mandatory-ternary/render.yml` |
| Make `-e` switches behave in `when:` | `bool`, `int` | `09-forcing-types/switches.yml` |
| Convert strings to numbers, strings or booleans | `int`, `float`, `string`, `bool` | `09-forcing-types/convert.yml` |
| Write JSON or YAML files that don't change on every run | `to_nice_json`, `to_nice_yaml` (`sort_keys`, `indent`) | `10-writing-data-out/templates/caddy.json.j2`, `variants.yml` |
| Keep non-ASCII text readable, and long YAML values on one line | `to_nice_json(ensure_ascii=false)`, `to_nice_yaml(width=1000)` | `10-writing-data-out/variants.yml` |

## Other hosts and loops

| To… | Use | Where |
|---|---|---|
| Build a server's rules from other hosts' facts | `hostvars` + `extract` | `11-data-from-other-hosts/pg_hba.yml` |
| Name the hosts that have no fact yet | `assert` | `11-data-from-other-hosts/pg_hba.yml` |
| Gather missing facts from another host | `delegate_to` + `delegate_facts` | `11-data-from-other-hosts/gather-missing.yml` |
| Keep facts between runs | `jsonfile` fact cache | `11-data-from-other-hosts/ansible.cfg` |
| Replace a `set_fact` loop with one expression, and time both | one Jinja expression | `15-set-fact-or-expression/build.yml`, `time.sh` |

## Networks

| To… | Use | Where |
|---|---|---|
| Check that typed subnets are real networks | `ansible.utils.ipaddr('subnet')`, the `ip` test, `assert` | `14-network-data/net.yml` |
| Carve one subnet per node out of a range | `ansible.utils.ipsubnet` | `14-network-data/net.yml` |
| Give each guest the address at its ID | `ansible.utils.ipaddr(n)`, `ipmath` | `14-network-data/net.yml` |

## Pitfalls recorded

Each of these is shown failing or misbehaving, with its output in the
example's `expected.txt`:

- `join` on a list of strings where a list of lists was expected splits the
  strings into characters (`01-readable-sudoers-with-dict-kv/vars/d-flat-strings.yml`).
- `zip` silently drops the extra items of the longer list
  (`02-lists-and-dicts-back-and-forth/lists-to-dicts.yml`).
- Same-named vars in `group_vars` and `host_vars` replace each other instead
  of merging (`03-combine-layers-and-quadlets/`).
- `selectattr` on a key some items lack (`04-picking-from-lists/`).
- `subelements` without `skip_missing`, and on a value that isn't a list
  (`05-subelements-and-product/volumes.yml`).
- Set operations don't keep order, and differ between runs without `sort`
  (`06-set-operations/`, `PYTHONHASHSEED`).
- Set operations between strings and numbers find no match, without an error
  (`06-set-operations/drift.yml`).
- `default(omit)` and `null` inside data a template reads
  (`08-default-omit-mandatory-ternary/`).
- `when: restart` on a string from `-e` (`09-forcing-types/`).
- `extract` on a host with no facts, and reading a fact through its
  top-level variable (`11-data-from-other-hosts/`).
- Jinja `groupby`'s `default` argument on ansible-core 2.21
  (ansible/ansible#86827), with the workaround (`12-grouping-and-merging/group.yml`).
- `lists_mergeby` dropping items or failing (`12-grouping-and-merging/merge.yml`).
- JMESPath quoting: the three quotes, bare numbers, a value with a quote in it
  (`13-json-query/`).
- `ipaddr` given a list drops the invalid items silently, and `ipaddr` and
  `ipmath` past the end of a /24 (`14-network-data/`).
- A `set_fact` loop's result that task vars and a later play's vars can't
  reset (`15-set-fact-or-expression/`).
- `map('format')` can't add a prefix (`16-text-on-lists/`).
- Sudo rules that visudo accepts but that hand out a root shell
  (`sudo-shell-escapes/`).

## Testing patterns worth reusing

| To… | How | Where |
|---|---|---|
| Test a role's template without running the role | render the role's own `templates/*.j2` into `out/` | `01-…`, `03-…`, `05-…`, `08-…` |
| Run only a role's input checks | include its `tasks/assert_role_vars.yml` | `02-lists-and-dicts-back-and-forth/sysctl.yml` |
| Validate a rendered file the way the role does | `validate: visudo -cf %s` | `01-readable-sudoers-with-dict-kv/render.yml` |
| Work on real API or command output without the system | recorded fixtures in `fixtures/` | `02-…`, `04-…`, `07-…`, `12-…`, `13-…`, `14-…` |
| Record an expected failure and keep going | `block`/`rescue`, write the error to `out/` | `04-…`, `05-…`, `08-…`, `09-…`, `11-…`, `12-…`, `13-…`, `14-…`, `16-…` |
| Check what a systemd unit really passed to its program | swap the binary for an argv printer | `16-text-on-lists/ci/` |
| Refuse dangerous sudoers rules in a pipeline | `cvtsudoers -f json` + a jq policy | `sudo-shell-escapes/check-sudoers.sh` |
| Generate a large inventory to time a playbook | a small Python generator | `15-set-fact-or-expression/make-inventory.py` |

## Not covered

No example here flattens nested lists (`flatten`) or handles dates.
