#!/bin/sh


for file in "$@"
do 
   out=`egrep '#include ".+"' "$file"| cut -d '"' -f2 `
   for f in $out 
   do
      if ! test -e "$f" 
      then 
          echo "$f" included into "$file" does not exist
      fi
   done
   
   
done
