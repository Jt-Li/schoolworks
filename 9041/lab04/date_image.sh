#!/bin/sh

for image in "$@"
do
   old=`date -R -r "$image"`
   convert -gravity south -pointsize 36 -draw "text 0,10 '$old'" "$image" "$image"
   touch -d "$old" "$image"
   
done
   
