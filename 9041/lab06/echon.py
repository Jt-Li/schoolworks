#!/usr/bin/python3
import sys


if (len(sys.argv) != 3):
    print ("Usage: ./echon.py <number of lines> <string>")
    sys.exit(0)
if (not(sys.argv[1].isdigit())):
    print ("./echon.py: argument 1 must be a non-negative integer")
    sys.exit(0)
if (int(sys.argv[1]) < 0):
    print ("./echon.py: argument 1 must be a non-negative integer")
    sys.exit(0)



times = sys.argv[1]
content = sys.argv[2]


for i in range (int(times)):
    print (content)
