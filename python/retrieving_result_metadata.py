#!/usr/bin/python
import pymysql

pymysql.install_as_MySQLdb();

conn = pymysql.connect (host = "localhost",
	user = "user_db",
	passwd = "123456s",
	db = "test",
	port=3306)

cursor1=conn.cursor( );
cursor1.execute("SELECT *"+
" FROM employees")
print ("%-20s %8s" % ("Name","Length"))
print ("-----------------------------")
for col_desc in cursor1.description:
	print ("%-20s %8d " % \
		(col_desc[0],col_desc[3]))
cursor1.close()
