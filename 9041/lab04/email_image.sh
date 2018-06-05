#!/bin/sh

for image in "$@"
do
   display $image
   echo Address to e-mail this image to?
   read address
   if [[ "$address" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]
   then
       echo Message to accompany image?
       read message
       echo "$message"|mutt -s $image -e 'set copy=no' -a "$image" -- "$address"
   fi
done
