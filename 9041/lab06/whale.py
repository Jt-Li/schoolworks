#!/usr/bin/python3
import sys

target = sys.argv[1]
pod = 0
indi = 0

for line in sys.stdin:
    line = line.rstrip()
    whale = line.split(' ', 1)[1]
    if (whale == target):
        pod += 1
        indi += int(line.split(' ', 1)[0])
print(target, "observations:" , pod, "pods,", indi, "individuals")
        
