#!/bin/sh
javac Solution.java
input="$@"
out=`echo $input | java Solution`
if [ -n "$out" ]
then 
	echo "$out"
else 
	echo false
fi
