#!/bin/sh
ls -RAl |
sort -g -k 5 -r |
awk '/^-/{ if (count++ < 5) print count ,":" ,$5, $9 }
/^-/ { fileNum ++ }
/^d/ { dirNum ++ }
{totalSize += $5}
END {
  print "Dir Num:" dirNum "\n" "File Num:" fileNum "\n" "Total Size:" totalSize}'
