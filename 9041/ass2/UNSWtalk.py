#!/web/cs2041/bin/python3.6.3

# written by Jiongtian Li October 2017
# for COMP[29]041 assignment 2
# https://cgi.cse.unsw.edu.au/~cs2041/assignments/UNSWtalk/

import os
from flask import Flask, render_template, session, url_for, request, redirect
import re

students_dir = "static/dataset-medium";


app = Flask(__name__)

#read student detail store information in dictionary
#key is zid
def read_student_detail():
    students = sorted(os.listdir(students_dir))
    students_detail = {}
    for student in students:
        stu_file = os.path.join(students_dir, student, "student.txt")
        img_file = os.path.join(students_dir, student, "img.jpg")
        with open(stu_file) as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                content = line.split(':')
                if content[0] == 'full_name':
                    name = content[1]
                if content[0] == "zid":
                    zid = content[1]
                if content[0] == "friends":
                    friends = content[1]
                    friends = friends.replace("(","")
                    friends = friends.replace(')', "")
                    friends = friends.split(",")
                if content[0] == "program":
                    program = content[1]
                if content[0] == "birthday":
                    birthday = content[1]
                if content[0] == "password":
                    password = content[1].strip()
        students_detail[student] = { 'name': name, 'zid': zid, 'friends': friends,
                                     'program' : program, 'birthday': birthday,
                                     'pic' : img_file , 'password' : password}
    return students_detail

# global varible
students_detail = read_student_detail()


# show login page
# back to main page if already login
@app.route('/', methods=['GET','POST'])
def show_login():
    try:
        if session['login'] == 1:
            return profile(session['zid'])
        else:
            return render_template('login_page.html',
                                   message = "Please login to contine!")
    except:
        return render_template('login_page.html',
                               message = "Please login to contine!")


# login gage get zid and password
# authenticate password
@app.route('/login', methods=['GET','POST'])
def login():
    zid = request.form.get('zid', '')
    password = request.form.get('password', '')
    global students_detail
   
    try:
        if students_detail[zid]['password'] != password:
                return render_template('login_page.html',
                                       message = 'Password or zid not correct')
    except KeyError:
        return render_template('login_page.html',
                                       message = 'Password or zid not correct')
    # store zid in session cookie and set login flag to 1
    else:
        session['zid'] = zid
        session['login'] = 1
    
    return profile(session['zid'])
    

# general logout and clear the session cookie
@app.route('/logout', methods=['POST'])
def logout():
    session['zid'] = 0
    session['login'] = 0
    return render_template('login_page.html',
                           message = 'Successfully logout')

# logout while viewing other user profile page
# clear the session cookie
@app.route('/user/logout', methods=['GET','POST'])
def logout2():
    session['zid'] = 0
    session['login'] = 0
    return redirect(url_for('login'))
	
# show user page
# inclue personal profile, friend list and posts
@app.route('/user/<zid>')
def profile(zid):
    if 'login' not in session or session['login'] != 1:
        return render_template('login_page.html',
                               message = "Please login to contine!")
    global students_detail
    name = students_detail[zid]['name']
    birthday = students_detail[zid]['birthday']
    program = students_detail[zid]['program']
    friends = students_detail[zid]['friends']
    if os.path.isfile(students_detail[zid]['pic']):
        image_filename = url_for('static', filename = 'dataset-medium/'+str(zid)+
                             '/img.jpg')
    else:
        image_filename = url_for('static', filename = 'pic.jpg')
    friends_dict = {}
    for fr in friends:
        fr = fr.strip()
        if os.path.isfile(students_detail[fr]['pic']):
            pic_path = url_for('static', filename = 'dataset-medium/'
                                            + str(fr) + '/img.jpg')
        else:
            pic_path = url_for('static', filename = 'pic.jpg')
        friends_dict[fr] = {'name': students_detail[fr]['name'],
                            'pic' : pic_path}

    posts = all_post()
    student_post = posts[zid]
    keys = list(student_post.keys())
    keys.sort(reverse = True)
            
    
    return render_template('user.html', name = name, friends = friends_dict,
                           birthday = birthday, zid = zid,
                           program = program, image = image_filename,
                           times = keys, post = student_post)


# search page
@app.route('/search')
def search_page():
    if 'login' not in session or session['login'] != 1:
        return render_template('login_page.html', 
                               message = "Please login to contine!")
    return render_template('search_page.html')

# search post page
@app.route('/searchpost')
def search_post_page():
    if 'login' not in session or session['login'] != 1:
        return render_template('login_page.html', 
                               message = "Please login to contine!")
    return render_template('search_post.html')

# display search post result
@app.route('/search_post', methods=['POST'])
def search_post():
    if 'login' not in session or session['login'] != 1:
        return render_template('login_page.html', 
                               message = "Please login to contine!")
    search_content = request.form.get('post_to_search', '').lower()
    result_post = []
    posts = all_post()
    for student in posts:
        for time in posts[student]:
            if posts[student][time].lower().find(search_content) != -1:
                result_post.append(posts[student][time])
    return render_template('search_post_result.html', posts = result_post) 
                
    
# display search name result
@app.route('/search_name', methods=['POST'])
def search_name():
    if 'login' not in session or session['login'] != 1:
        return render_template('login_page.html', 
                               message = "Please login to contine!")
    search_name = request.form.get('name_to_search', '').lower()
    global students_detail
    search_result = {}
    for zid in students_detail:
        str1 = students_detail[zid]['name'].lower()
        if str1.find(search_name) != -1:
            if os.path.isfile(students_detail[zid]['pic']):
                pic_path = url_for('static', filename = 'dataset-medium/'
                                            + str(zid) + '/img.jpg')
            else:
                pic_path = url_for('static', filename = 'pic.jpg')
            search_result[zid] = {'name': students_detail[zid]['name'],
                                  'pic' : pic_path }
    
            
    return render_template('search_result.html', result = search_result)



# store all post in dictionary two dimension
# first key is zid
# second key is date 
def all_post():
    students = sorted(os.listdir(students_dir))
    post = {}
    for student in students:
        post[student] = {}
        files_path = os.path.join(students_dir, student)
        files = os.listdir(files_path)
        for f in files:
            if f == "student.txt" or f == "img.jpg":
                continue
            f_path = os.path.join(students_dir, student, f)
            with open(f_path) as ff:
                cc = ""
                lines = ff.readlines()
                for line in lines:
                    line = line.strip()
                    line = re.sub('(?P<zid>z\d{7})', dictionary, line)
                    cc += line
                    cc += '\n'
                    content = line.split(':', 1)
                    if content[0] == 'time':
                        content[1] = content[1].split('+')[0]
                        content[1] = content[1].replace(' ', '')
                        content[1] = content[1].replace('T', ' ')
                        content[1] = content[1].strip()
                        time = content[1]
            post[student][time] = cc
    return post


# function replace the match into dictionary and href link(key:matched zid and name)
# transfer zid in posts to full name with href link
def dictionary(matched):
    global students_detail
    zid = matched.group('zid')
    out = '<a href="https://cgi.cse.unsw.edu.au/~z5099187/ass2/UNSWtalk.cgi/user/'
    out += str(zid)
    out += '\">'
    out += students_detail[zid]['name']
    out += '</a>'
    return out
	    
            
if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(debug=True, use_reloader=True, port=2082)
