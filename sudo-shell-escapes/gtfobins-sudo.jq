# Reads GTFOBins' api.json and prints {"program": ["function", ...]}: the
# functions GTFOBins lists as working through sudo, with aliases and
# "inherit" entries (vim from vi, systemctl from less) resolved.
.executables as $e
| def entry($n): ($e[$n] // {}) as $x
    | if $x.alias then $e[$x.alias] // {} else $x end;
  def sudo_functions($n; $depth):
    if $depth > 5 then [] else
      [ (entry($n).functions // {}) | to_entries[]
        | .key as $f | .value[] | select(.contexts | has("sudo"))
        | if $f == "inherit" then sudo_functions(.from; $depth + 1)[] else $f end ]
      | unique
    end;
  $e | keys | map({key: ., value: sudo_functions(.; 0)})
  | map(select(.value | length > 0)) | from_entries
