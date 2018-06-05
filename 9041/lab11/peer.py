#!/usr/bin/python3

#
# Allow COMP[29]041 students  to enter peer assessments of each other's work
# And see what peer assessment have been entered of them.
#

import collections, glob, os,re
from flask import Flask, session, render_template, request

# peer assessments are stored in this directory

ASSESSMENTS_DIRECTORY = 'assessments'

# this file contain one line for each COMP[29]041 student
# each line contains zid:name:password

STUDENT_DETAILS_FILE = 'students.txt'



app = Flask(__name__, template_folder='.')

# display initial page request zid/password

@app.route('/', methods=['GET'])
def start():
	return render_template('peer_login.html')

# if zid/password authenticates
# return a page which allows a student to peer assess another student
# or see other students assessment of them

@app.route('/login', methods=['POST'])
def login():
	zid = request.form.get('zid', '')
	password = request.form.get('password', '')
	zid = re.sub(r'\D', '', zid)
	student_details = read_student_details()
	if student_details[zid]['password'] != password:
		return render_template('peer_login.html')

	# store zid in session cookie
	else:
		session['zid'] = zid
	
	
	
	return render_template('peer_select_student.html', students=student_details)


# return a page allowing a peer assessment of the selected student
# to be entered

@app.route('/enter_grade', methods=['POST'])
def enter_grade():

	# check we have previous autheticated zid in session cookie
	if 'zid' not in session:
		return render_template('peer_login.html')
	
	student_assessed_zid = request.form.get('student_assessed', '')
	
	student_details = read_student_details()
	
	session['student_assessed_zid'] = student_assessed_zid
	student_assessed_name = student_details[student_assessed_zid]['name']
	
	assessment_file = os.path.join(ASSESSMENTS_DIRECTORY, student_assessed_zid + '.' + session['zid'])
	try:
		with open(assessment_file) as f:
			current_grade = f.read()
	except OSError:
		current_grade = ''
		
	return render_template('peer_enter_grade.html',
							name=student_assessed_name,
							number=student_assessed_zid,
							grade_descriptions=possible_grades,
							existing_grade=current_grade)


# save a peer assessment of the selected student

@app.route('/save_grade', methods=['POST'])
def save_grade():
	# check we have a previous authenticated zid in session cookie
	if 'zid' not in session:
		return render_template('peer_login.html')
	
	student_assessed_zid = session.get('student_assessed_zid', '')
	student_details = read_student_details()
	student_assessed_name = student_details[student_assessed_zid]['name']

	assessment_file = os.path.join(ASSESSMENTS_DIRECTORY, student_assessed_zid + '.' + session['zid'])
	grade = request.form.get('grade', '')
	with open(assessment_file,"w") as f:
			f.write(grade)

	return render_template('peer_select_student.html',
							students=student_details,
							message='A peer assessment of ' + grade + ' has been saved for ' + student_assessed_name)
							


@app.route('/assessments', methods=['POST'])
def assessments():
	# check we have a previous authenticated zid in session cookie
	if 'zid' not in session:
		return render_template('peer_login.html')
	grade_dict = {}
	student_details = read_student_details()
	grades = []
	for root, dirs, filenames in os.walk(ASSESSMENTS_DIRECTORY):
		for f in filenames:
			if f.split('.')[0] == session['zid']:
				with open(os.path.join(root, f), 'r') as ff:
					zid_mark = f.split('.')[1]
					zid_mark = zid_mark.strip()
					grade = ff.read()
					grade = grade.strip()
					grades.append(grade)
					grade_dict[zid_mark] = {'name': student_details[zid_mark]['name'], 'grade' : grade}
	grades = sorted(grades)
	median = ''
	if not grades:
		return render_template('peer_assessments.html', grade_dict = grade_dict, median = "not available")
	if len(grades) % 2 == 0:
		if str(grades[int(len(grades)/2 - 1)]) != str(grades[int(len(grades)/2)]):
			median += str(grades[int(len(grades)/2 - 1)])
			median += '/'
			median += str(grades[int(len(grades)/2)])
		else:
			median += str(grades[int(len(grades)/2)])
	else:
		median += str(grades[int(len(grades)/2)])
		
	return render_template('peer_assessments.html', grade_dict = grade_dict, median = median)
	
					
					
				
		
	
	



# read the student details file
# return it as a dict (an OrderedDict sorted on name)

def read_student_details():
	with open(STUDENT_DETAILS_FILE) as f:
		students = [line.strip().split(':') for line in f]
	sorted_students = sorted(students, key=lambda student: student[1]) 
	student_details = collections.OrderedDict()
	for (zid, name, password) in sorted_students:
		student_details[zid] = {'name': name, 'password' : password}
	return student_details
	

# read the student details file
# return it as a dict (an OrderedDict sorted on name)

possible_grades = collections.OrderedDict([
	('A', 'working correctly'),
	('B', 'minor problems'),
	('C', 'major problems but significant part works'),
	('D', 'any part works'),
	('E', 'attempted but not working')
	])

# start flask as webserver

if __name__ == '__main__':
	app.secret_key = os.urandom(12)
	app.run(debug=True)
