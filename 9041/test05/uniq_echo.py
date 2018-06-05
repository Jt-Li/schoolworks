#!/usr/bin/python3
import sys

out = []
for i in range(1, len(sys.argv)):
    if sys.argv[i] in out:
        continue
    else:
        out.append(sys.argv[i])

for i in range(0, len(out) - 1):
    print(out[i], end=" ")
print(out[len(out) - 1])
        
    
    

    
    
