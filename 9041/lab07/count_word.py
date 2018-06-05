#!/usr/bin/python3

import sys
import re
total = 0
target = sys.argv[1]
for line in sys.stdin:
    for char in re.split('[^a-zA-Z]', line):
        if (char.lower() == target.lower()):
            total += 1
            
print(target, "occurred", total, "times")
