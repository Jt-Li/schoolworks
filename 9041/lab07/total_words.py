#!/usr/bin/python3

import sys
import re
total=0
for line in sys.stdin:
    for char in re.split('[^a-zA-Z]', line):
        if (char != ""):
            total += 1
            
print(total, "words")
