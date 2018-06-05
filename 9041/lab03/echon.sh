#!/bin/sh
i="1"
re='^[0-9]+$'


if [ $# -ne 2 ] 
then
   echo "Usage: ./echon.sh <number of lines> <string>"
   exit 1
fi

if ! [[ $1 =~ $re ]] 
then 
    echo "./echon.sh: argument 1 must be a non-negative integer"
    exit 1
fi

while [ $i -le $1 ] 
do
echo $2
i=$(( $i + 1 ))
done 

 

