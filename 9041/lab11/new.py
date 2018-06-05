#!/usr/bin/python3
import collections, glob, os,re
ASSESSMENTS_DIRECTORY = 'assessments'



grades=[]
for root, dirs, filenames in os.walk(ASSESSMENTS_DIRECTORY):
	for f in filenames:
		if f.split('.')[0] == "5077990":
			with open(os.path.join(root, f), 'r') as ff:
				zid_mark = f.split('.')[1]
				zid_mark = zid_mark.strip()
				grade = ff.read()
				grade = grade.strip()
				grades.append(grade)
				
				
grades = sorted(grades)
median = ''

if len(grades) % 2 == 0:
	median += str(grades[int(len(grades)/2 - 1)])
	median += '/'
	median += str(grades[int(len(grades)/2)])
else:
	median += str(grades[int(len(grades)/2)])
print(median)
print(grades)
