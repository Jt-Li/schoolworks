#!/usr/bin/python3

import sys

l = sys.argv[1]
li = []
d = 0
total = 0
for line in sys.stdin:
    line = line.strip()
    new_line=""
    for w in line.split(" "):
        new_line += w.lower()
        
    total +=1
    if new_line in li:
        continue
        
    else:
        li.append(new_line)
        d += 1
        if d == int(l):
            print(l,"distinct lines seen after", total, "lines read.")
            sys.exit()
print("End of input reached after", total, "lines read - ", l, "different lines not seen.") 
        
        
    
