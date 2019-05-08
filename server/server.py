#!/usr/bin/env python3
from flask import Flask, render_template, redirect, url_for, session, request, jsonify, send_file, make_response
import dbconnect
import cv2
import numpy as np
import base64
import io
import mysql.connector
import reload_ml

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
	
@app.route("/login", methods=["POST"])
def login():
	user_ = request.form.get('user')
	pass_ = request.form.get('pass')

	
	q_result = my_connection.select_query(
		table = "user_profile",
		value_names="*",
		value_name="usr_password",
		value=pass_
	)
	
	with open("some shit.txt", "w") as f:
		f.write("{0} {1}\n".format(user_, pass_))
		f.write("{}\n".format(request.data))
		f.write("{}\n".format(str(q_result)))
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

@app.route("/upload", methods=["GET","POST"])
def upload():
	
	pic_ = request.files['image']
	user_ = request.form.get('user')
	pic_.save("data/%s.jpg" % user_)
	try:
		reload_ml.predict("data/%s.jpg" % user_)
	except Exception as e:
		with open("ErrorLog.txt", "a") as f:
			f.write("{}\n".format(str(e)))
		return jsonify(message="failed", status="200", details="Failed to load model")
	result_ = ""
	with open("misc/result.txt", "r") as f:
		result_ = f.read()
	
	return jsonify(message="ok", status='200', details=result_)
	
@app.route("/fetch/profile_picture", methods=["GET","POST"])
def fetch_profile_picture():
	user_ = request.form.get('user')
	if user_ == None:
		
		#with open("log", "a") as f:
		#	f.write("none found\n")
		user_ = request.args.get('user')
	#with open("log", "a") as f:
	#	f.write("{}\n".format(user_))
	query_ = "SELECT pic FROM profile_pictures WHERE email = '{}';".format(user_)
	
	#with open("log", "a") as f:
	#	f.write("{0}\n".format(query_))
	#	f.write("{0}:\n".format(user_))
	q_result = my_connection.fetch_query(query_, buff=True)
	
	
	#with open("log", "a") as f:
		#f.write("{0}\n".format(query_))
		#f.write("{0}:\n".format(user_))
	#	f.write("{0}\n\n".format(len(q_result)))
	
	if q_result == ():
		return jsonify(message = "failed")
	else:
		pic_ = q_result
		#pic__ = pic_[10:len(pic_)-1]
		with open("log.txt", "w") as f:
			f.write("{0}\n\n".format(type(pic_)))
			
		#with open("ha2.jpg", 'wb') as f:
		#	f.write(pic_)
		
		#with open("ha2.jpg", "rb") as f:
		#	x = f.read()
		
		return send_file(
			io.BytesIO(pic_),
			mimetype='image/jpeg',
			as_attachment=True,
			attachment_filename="s.jpg"
		)
		#return send_file("ha2.jpg", mimetype='image/jpeg')
@app.route("/post/profile_picture", methods=["GET","POST"])
def post_profile_pic():
	user_ = request.form.get('user')
	#pic_ = request.form.get('image')
	pic__ = request.files['image']
	
	if pic__ == None:
		with open("log3.txt", "a") as f:
			f.write("THIS SHIT DOESN'T WORK\n")
					
		return jsonify(message = "failed", details = "no image found")
	with open("log3.txt", "a") as f:
		f.write("{}\n".format(user_))
		f.write("recieved data\n\n")
	
	pic__.save("imagepost.jpg")
	
	data_ = ""
	with open("imagepost.jpg", "rb") as i:
		data_ = i.read()
	
	mydb = mysql.connector.connect(
		host="localhost",
		user="root",
		passwd="jasper",
		database="SnapTrack",
		auth_plugin="mysql_native_password"
	)

	query_ = "UPDATE profile_pictures SET pic = %s WHERE email = %s;"
	query_tuple = (data_, user_)
	cursor = mydb.cursor(True)
	cursor.execute(query_, query_tuple)
	mydb.commit()

	#return jsonify(message = "failed", details = "query failed")
	
	return jsonify(message = "ok")
		

	
if __name__ == "__main__":
	app.run(host="0.0.0.0", port=5000, debug=True)


	#http://127.0.0.1:5000/query?table=food&value_names=food_name,calories&value_name=food_name&value="banana"
