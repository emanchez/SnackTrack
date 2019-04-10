#!/usr/bin/env python3
from flask import Flask, render_template, redirect, url_for, session, request, jsonify
import dbconnect

app =  Flask(__name__, template_folder = "templates")
my_connection = dbconnect.MyConnection("jasper", "SnapTrack")


@app.route("/")
def home():
	return render_template("home.html")
	
@app.route("/query",methods=['GET', 'POST'])
def parse_request():
	_table=request.args.get('table') # mysql table
	_value_names=request.args.get('value_names') # table variable names
	_value_name=request.args.get('value_name') # singular variable name
	_value=request.args.get('value') # value of a variable
	
	with open("some shit.txt", "a") as f:
		f.write("{0} {1} {2} {3}\n".format(_table, _value_names, _value_name, _value))
		
	q_result = my_connection.select_query(table=_table, value_names=_value_names, value_name=_value_name, value=_value)
	output = '<h1>received information: {}</h1>'.format((_table, _value_names, _value_name, _value))
	output = output + '<h1>Results:</h1>\n'
	for x in q_result:
		m = list(x)
		output = output + '<p>\t{}<p>\n'.format(str(m))
	return output

@app.route("/test", methods=["GET","POST"])
def response_():
	input = request.args.get('input')
	return jsonify(response="HEY BITCH")

@app.route("/signup", methods=["GET", "POST"])
def signup():
	main_query = "INSERT INTO {0} VALUES (\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\", null, null);"
	_table = request.args.get("table")
	#_values = request.args.get("values")
	_email = request.args.get("email")
	_pass = request.args.get("pass")
	_fname = request.args.get("fname")
	_lname = request.args.get("lname")
	_dob = request.args.get("dob")
	try:
		my_connection.insert_query(main_query.format(_table, _email, _pass, _fname, _lname, _dob))
		return jsonify(response = "OK")
	except:
		return jsonify(response = "NOT OK")
	
@app.route("/login", methods=["GET", "POST"])
def login():
	user_ = request.args.get('user')
	pass_ = request.args.get('pass')

	q_result = my_connection.select_query(
		table = "user_profile",
		value_names="*",
		value_name="usr_password",
		value=pass_
	)
	#with open("some shit.txt", "a") as f:
	#	s = ""
	#	for x in q_result[0]:
	#		s = s + str(x) + " "
	#	f.write(s + "\n")

	if q_result == []:
		return jsonify(message='failed')
	else:
		data = q_result[0]
		return jsonify(
			message="success!",
			email=data[0],
			fname=data[2],
			lname=data[3],
			dob=data[4],
			weight=data[5],
			height=data[6]
			)

# @app.route("/ss")
# def ss():
	# if 'username' in session:
		# username=session['username']
		# return 'logged in as ' + username + '<br>' + \
		# "<b><a href = '/logout'>Click here to log out</a></b>"
	# return "Your are not logged in <br><a href = '/login'></b>" + \
		# "cick here to log in</b></a>"
		
# @app.route('/login', methods=['POST','GET'])
# def login():
	# if request.method=="POST":
		# session['username'] = request.form['username']
		# return redirect(url_for('/ss'))

# @app.route('/logout')
# def logout():
	# session.pop('username', None)
	# return redirect(url_for('/ss'))
if __name__ == "__main__":
	app.run(host="0.0.0.0", port=5000, debug=True)


	#http://127.0.0.1:5000/query?table=food&value_names=food_name,calories&value_name=food_name&value="banana"