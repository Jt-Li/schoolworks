#!/bin/sh

for filename in *
do 
  if [ ${filename: -4} == ".jpg" ]
  then 
      newfile=`echo "$filename"| cut -d "." -f1`
      newfile="$newfile.png"
      if test -e "$newfile"
      then
          echo "$newfile" already exists
          exit 1
      else
          convert "$filename" "$newfile"
          rm "$filename"
          
      fi
   fi
done


