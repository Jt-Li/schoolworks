#!/usr/bin/python3

import sys
import re
import glob
import math



artist = {}



for file in glob.glob("lyrics/*.txt"):
    file_name_1 = re.split('.txt', file)
    file_name_2 = re.split('/', file_name_1[0])
    name = file_name_2[1]
    name = re.sub('_', ' ', name)
    artist[name]=[]
    with open(file) as F:
        for line in F:
            for char in re.split('[^a-zA-Z]', line):
                if (char != ""):
                    artist[name].append(char)

for i in range(1, len(sys.argv)):
    txt = []
    final={}
    with open(sys.argv[i]) as F:
        for line in F:
            for char in re.split('[^a-zA-Z]', line):
                if (char != ""):
                    txt.append(char)
    for art in artist:
        final[art] = 0
    for w in txt:
        for art in artist:
            occur = 0
            for word in artist[art]:
                if (word.lower() == w.lower()):
                    occur += 1
            final[art] += math.log((occur + 1) / len(artist[art]))

    final_artist = max(final.keys(), key=(lambda key : final[key]))
    print("%s most resembles the work of %s (log-probability=%.1f)" % (sys.argv[i],
                                                                               final_artist, final[final_artist]))
                    
    
    

    
