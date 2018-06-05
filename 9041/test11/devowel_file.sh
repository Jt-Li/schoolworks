#!/bin/sh

sed -i -e 's/[aeiou]//g' $1
sed -i -e 's/[AEIOU]//g' $1
