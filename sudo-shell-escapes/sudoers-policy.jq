# Reads the JSON that `cvtsudoers -e -f json` prints for a sudoers file, and
# prints one finding per problem with a command that can hand out a root
# shell. $escapes: the contents of shell-escape-commands.txt.

($escapes | split("\n") | map(sub("#.*"; "") | gsub("^\\s+|\\s+$"; ""))
  | map(select(length > 0))) as $deny

| .User_Specs[]?.Cmnd_Specs[].Commands[]
| select(.negated | not)
| .command as $cmd
| ($cmd | split(" ")) as $words
| ($words[0] | split("/") | last) as $bin
| ($words[1:] | join(" ")) as $args
| (if $cmd == "ALL" then "FAIL runs any command, a shell included"
   else empty end),
  (if any($deny[]; . == $bin) then
     "FAIL \($bin) can start a shell or write any file as root"
   else empty end),
  (if $bin != "sudoedit" and ($args | test("[*?\\[]"))
      and ($args | startswith("^") | not) then
     "FAIL a wildcard in the arguments also matches extra arguments"
   else empty end),
  (if ($bin == "journalctl"
       or ($bin == "systemctl"
           and any($words[1:][]; test("^(status|show|cat|list-.*)$"))))
      and (any($words[]; . == "--no-pager") | not) then
     "WARN starts a pager without --no-pager"
   else empty end)
| "\(.): \($cmd)"
