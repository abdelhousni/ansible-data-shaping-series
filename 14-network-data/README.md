# 14: network data with ansible.utils

Example for [part 14](https://til.housni.eu/ansible/ansible-utils-ipaddr-pg-hba-subnets-proxmox.html).

The `ansible.utils` collection's network filters need the `netaddr` Python
library on the controller, so `requirements.in` lists it and
`requirements.yml` installs the collection.

`net.yml` checks part 5's client subnets, as typed into a form in
`vars/network.yml`, with `ipaddr`, `ipaddr('net')`, `ipaddr('subnet')` and
the `ip` test, and names the ones that aren't networks with an `assert`. It
then carves one /24 per Proxmox node out of `10.10.0.0/16` with `ipsubnet`
and gives each of part 4's recorded guests the address at its VMID, with
`ipaddr(n)`, and shows what `ipaddr` and `ipmath` do past the end of a /24.

```sh
./run.sh
```

Compare with [`expected.txt`](expected.txt).
