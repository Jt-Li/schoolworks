#!/usr/bin/python3

import sys

vowl = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
result = []
with open(sys.argv[1], 'r') as f:
    lines = f.readlines()
    for line in lines:
        line = line.strip()
        for c in vowl:
            line = line.replace(c, '')
        result.append(line)

with open(sys.argv[1], 'w') as f:
    for line in result:
        f.write(line)
        f.write('\n')


        
        
        
        
        
