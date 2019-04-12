#!/usr/bin/python
import pymysql

pymysql.install_as_MySQLdb();

conn = pymysql.connect (host = "localhost",
	user = "user_db",
	passwd = "123456s",
	db = "test",
	port=3306)

cursor=conn.cursor( );
rep_id = 1;

cursor.execute("CALL sp_rep_report(%s)",(rep_id))
print ("Employee details:")
for row in cursor:
	print ("%d %s %s" % (row[0],
		row[1],
		row[2]))
cursor.nextset( )
print ("Employees customers:")
for row in cursor:
	print ("%d %s" % (row[0],
		row[1]))
cursor.close( )
