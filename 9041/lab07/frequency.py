#!/usr/bin/python3

import sys
import re
import glob


target = sys.argv[1]
names = []
occur_time = {}
total_words = {}


for file in glob.glob("lyrics/*.txt"):
    occur = 0
    total = 0
    file_name_1 = re.split('.txt', file)
    file_name_2 = re.split('/', file_name_1[0])
    name = file_name_2[1]
    name = re.sub('_', ' ', name)
    names.append(name)
    with open(file) as F:
        for line in F:
            for char in re.split('[^a-zA-Z]', line):
                if (char.lower() == target.lower()):
                    occur += 1
                if (char != ""):
                    total += 1
    occur_time[name] = occur
    total_words[name] = total

for key in sorted(occur_time):
   print("%4d/%6d = %.9f %s" % (occur_time[key], total_words[key],
           occur_time[key]/total_words[key],  key))
    
    
            

    
    



##total = 0
##target = sys.argv[1]
##for line in sys.stdin:
##    for char in re.split('[^a-zA-Z]', line):
##        if (char.lower() == target.lower()):
##            total += 1
##            
##print(target, "occurred", total, "times")
