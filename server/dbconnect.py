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
		#value_name is in quotation marks (i.e. "\"apple\"")
		self.cursor.execute("SELECT {0} FROM {1} WHERE {2} = {3};".format(value_names, table, value_name, value))
			
			
		return [x for x in self.cursor]

	def insert_query(self, query):
		self.cursor.execute(query)
		self.connection.commit()
		return [x for x in self.cursor]

if __name__ == "__main__":
	my_connection = MyConnection(password="jasper", database_name="SnapTrack")
	
	q_result = my_connection.select_query("food")
	
	for x in q_result:
		t = "; "
		t = t.join([x[0],x[1],str(x[2])])
		print(t)