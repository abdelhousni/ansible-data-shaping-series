# Reads the JSON that `cvtsudoers -e -f json` prints for a sudoers file, and
# prints one finding per problem with a command that can hand out a root
# shell.
#   $interactive: the contents of interactive-commands.txt
#   $gtfo[0]: {"program": ["function", ...]} from gtfobins-sudo.jq

($interactive | split("\n") | map(sub("#.*"; "") | gsub("^\\s+|\\s+$"; ""))
  | map(select(length > 0))) as $deny
| $gtfo[0] as $gtfobins

| .User_Specs[]?.Cmnd_Specs[].Commands[]
| select(.negated | not)
| .command as $cmd
| ($cmd | split(" ")) as $words
| ($words[0] | split("/") | last) as $bin
| ($words[1:] | join(" ")) as $args
| ($gtfobins[$bin] // $gtfobins[$bin | sub("[0-9.]+$"; "")]) as $functions
| ($functions // [] | join(", ")) as $listed
| any($deny[]; . == $bin) as $interactive_bin
| (if $cmd == "ALL" then "FAIL runs any command, a shell included"
   else empty end),
  (if $words[0] | endswith("/") then
     "FAIL runs any program in the directory"
   else empty end),
  (if $interactive_bin then
     "FAIL \($bin) can start a shell or write any file as root, whatever its arguments"
   else empty end),
  (if $args == "" and $bin != "ALL" and ($interactive_bin | not) and $functions then
     "FAIL any arguments are allowed, and GTFOBins lists sudo functions for \($bin): \($listed)"
   else empty end),
  (if $bin != "sudoedit" and ($args | test("[*?\\[]"))
      and ($args | startswith("^") | not) then
     "FAIL a wildcard in the arguments also matches extra arguments"
     + (if $functions then "; GTFOBins lists sudo functions for \($bin): \($listed)" else "" end)
   else empty end),
  (if ($bin == "journalctl"
       or ($bin == "systemctl"
           and any($words[1:][]; test("^(status|show|cat|list-.*)$"))))
      and (any($words[]; . == "--no-pager") | not) then
     "WARN starts a pager without --no-pager"
   else empty end)
| "\(.): \($cmd)"
