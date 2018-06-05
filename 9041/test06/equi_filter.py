#!/usr/bin/python3
import sys

for line in sys.stdin:
    line = line.strip()
    for word in line.split(' '):
        sts = True
        d = {}
        word2 = word.lower()
        for char in word2:
            if char in d:
                d[char] += 1
            else:
                d[char] = 1
        a = word2[0]
        value = d[a]
        for key in d:
            if d[key] != value:
                sts = False
                break
        if sts:
            print(word, end=" ")
    print()
    
    
    
        
            
