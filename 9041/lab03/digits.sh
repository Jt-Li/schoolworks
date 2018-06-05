#!/bin/sh

while read LINE
do 
    echo $LINE | tr '[0-4]' '<' | tr '[6-9]' '>' 
done
