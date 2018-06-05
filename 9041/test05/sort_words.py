#!/usr/bin/python3

import sys

for line in sys.stdin:
    line = line.strip()
    word = line.split(' ')
    for w in word:
        w.strip('\n')
    out = sorted(word)
    for w in out:
        print(w, end=' ')
    print()
