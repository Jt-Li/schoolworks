#!/usr/bin/python3
import sys


for line in sys.stdin:
    line = line.rstrip()
    out=""
    for c in line:
        if c.isdigit():
            if int(c) > 5:
                out +=">"
            elif int(c) < 5:
                out +="<"
            else:
                out +="5"
        else:
            out += c
    print(out)


