#!/usr/bin/python3

import os, random, re 
from flask import Flask, request, render_template, session

MAX_NUMBER_TO_GUESS = 99

app = Flask(__name__, template_folder='.')

# display initial page 

@app.route('/', methods=['GET','POST'])
@app.route('/start', methods=['GET','POST'])
def start():
	session['number_to_guess'] = random.randint(1, MAX_NUMBER_TO_GUESS)
	return render_template('game_start.html', max_number_to_guess=MAX_NUMBER_TO_GUESS)

# return a page allowing a the user to make a guess

@app.route('/guess', methods=['POST'])
def guess():
	if 'number_to_guess' not in session:
		return start()
	guess = request.form.get('guess', '')
	guess = re.sub('\D', '', guess)
	if not guess:
		return render_template('game_guess.html', message="Invalid guess")
	guess = int(guess)
	number_to_guess = session['number_to_guess']
	if guess < number_to_guess:
		return render_template('game_guess.html', message="Higher than " + str(guess))
	elif guess == number_to_guess:
		return render_template('game_success.html', message= str(guess))
	else:
		return render_template('game_guess.html', message="Lower than " + str(guess))

# start flask as webserver

if __name__ == '__main__':
	app.secret_key = os.urandom(12)
	app.run(debug=True)
