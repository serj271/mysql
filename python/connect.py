#!/usr/bin/python
import pymysql

pymysql.install_as_MySQLdb();
conn = pymysql.connect (host = "localhost",
	user = "user_db",
	passwd = "123456s",
	db = "test",
	port=3306)

	
cursor1=conn.cursor();
cursor1.execute("SELECT department_id,department_name "+
" FROM departments")
for department_id, department_name in cursor1:
	print ("%6d %-20s" % (department_id, department_name))
cursor1.close() 
