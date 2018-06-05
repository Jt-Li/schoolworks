#!/bin/sh


for filename in *.htm
do 
  newfile=`echo "$filename"| cut -d "." -f1`
  newfile="$newfile.html"
  if test -e "$newfile"
  then
      echo "$newfile" exists
      exit 1
  else
      `mv "$filename" "$newfile"`
  fi        
 done


