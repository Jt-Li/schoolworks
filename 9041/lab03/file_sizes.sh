#!/bin/sh
small=""
mid=""
large=""
for f in *
do
  size=`wc -l < $f`
  if [ $size -lt 10 ]
  then 
     small="$small $f"
  elif [ $size -lt 100 ]
  then 
     mid="$mid $f"
  else
     large="$large $f"
  fi
done
small=`echo $small | tr " " "\n"|sort|tr "\n" " "`
mid=`echo $mid | tr " " "\n"|sort|tr "\n" " "`
large=`echo $large | tr " " "\n"|sort|tr "\n" " "`
echo "Small files:" $small
echo "Medium-sized files:" $mid
echo "Large files:" $large

