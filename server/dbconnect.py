import mysql.connector

def create_database_connection(p, db, h="127.0.0.1", u="root", auth='mysql_native_password'):
	mydb = mysql.connector.connect(
		host=h,
		user=u,
		passwd=p,
		database=db,
		auth_plugin=auth
	)
	
	return mydb
	
class MyConnection:
	def __init__(self, password, database_name):
		self.connection = create_database_connection(password, database_name)
		self.cursor = self.connection.cursor()

	
	def custom_query(self, query):
		self.cursor.execute(query)
		
		return [x for x in self.connection.cursor()]
	
	def select_query(self, table, value_names, value_name, value):
		if value_names == None and value_name == None and value == None:
			self.cursor.execute("SELECT * FROM {};".format(table))
		elif value_name == None and value == None:
			value_str = ",".join(value_names.split(",")) # make sure all elements in value_names are in quotation marks (i.e. "\"apple\"")
			self.cursor.execute("SELECT {0} FROM {1};".format(value_str, table))
		elif value_names == None:
			self.cursor.execute("SELECT * FROM {0} WHERE {1} = {2};".format(table, value_name, value))
		else:
			value_str = ",".join(value_names.split(",")) # make sure all elements in value_names are in quotation marks (i.e. "\"apple\"")
			self.cursor.execute("SELECT {0} FROM {1} WHERE {2} = {3};".format(value_str, table, value_name, value))
			with open("some shit.txt", "a") as f:
				f.write("SELECT {0} FROM {1} WHERE {2} = {3};\n".format(value_str, table, value_name, value))
			
			
		return [x for x in self.cursor]


if __name__ == "__main__":
	my_connection = MyConnection(password="password", database_name="SnapTrack")
	
	q_result = my_connection.select_query("food", None, None, None)
	
	for x in q_result:
		t = "; "
		t = t.join([x[0],x[1],str(x[2])])
		print(t)