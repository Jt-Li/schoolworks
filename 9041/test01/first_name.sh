#!/bin/sh


name=`egrep 'COMP[29]041' "$1" | cut -d '|' -f3 | cut -d ',' -f2 |cut -d ' ' -f2 |  sort  | uniq -c | sort -n -r |head -1 | tr '[0-9]' ' '`



echo $name

