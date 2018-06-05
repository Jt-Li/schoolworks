#!/bin/sh


for music in "$@"
do
  album=`echo "$music" | cut -d '/' -f2`
  year=`echo "$album" | cut -d ',' -f2 |sed 's/ //'`
  cd "$music"
  for file in *
  do 
    title=`echo "$file" | sed 's/ - /%/g' | cut -d '%' -f2`
    track=`echo "$file" | sed 's/ - /%/g' | cut -d '%' -f1`
    artist=`echo "$file" | sed 's/ - /%/g' | cut -d '%' -f3 | sed 's/.mp3//'`
    id3 -t "$title" "$file" >/dev/null
    id3 -T "$track" "$file" >/dev/null
    id3 -a "$artist" "$file" >/dev/null
    id3 -A "$album" "$file" >/dev/null
    id3 -y "$year" "$file" >/dev/null
  done
  cd ..
  cd ..
done
