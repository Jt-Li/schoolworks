#!/usr/bin/python3

import sys

nums = []

for i in range(1, len(sys.argv)):
    nums.append(int(sys.argv[i]))


nums.sort()

print(nums[int(len(nums)/2)])
