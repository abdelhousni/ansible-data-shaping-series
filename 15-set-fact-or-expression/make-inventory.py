"""Writes an inventory of N application servers and one PostgreSQL server.

Each app host's address is an inventory variable, app_ipv4, so that timing
the two ways doesn't include gathering facts. Every third host from the
fourth on has none, like part 11's app3.
"""
import sys

count = int(sys.argv[1])
print("all:")
print("  vars:")
print("    ansible_connection: local")
print('    ansible_python_interpreter: "{{ ansible_playbook_python }}"')
print("  children:")
print("    app:")
print("      hosts:")
for n in range(1, count + 1):
    print(f"        app{n}:")
    if n <= 3 or n % 3:
        print(f"          app_ipv4: 10.10.{n // 250}.{n % 250 + 1}")
print("    db:")
print("      hosts:")
print("        db1:")
