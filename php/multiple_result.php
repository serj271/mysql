<?php
	$dsn = 'mysql:dbname=test;host=localhost;port=3306';
	$user = 'user_db';
	$password = '123456s';
	try {
		$dbh = new PDO($dsn, $user, $password);
	}
	catch (PDOException $e) {
		die('Connection failed: '.$e->getMessage( ));
	}
	print "Connected\n";
	$sql_text="SELECT surname,firstname	FROM employees;
		SELECT department_id,department_name
		FROM departments";
	$sql_text="call sp_employee_report(1)";
	$sth = $dbh->prepare($sql_text);
	$sth->execute() or die(implode(':', $sth->errorInfo( )));
	$html_text = array ( );
	do{
		
		if ($sth->columnCount() > 0){
			#Print off the column names
			for ($i = 0; $i < $sth->columnCount( ); $i ++){
				$meta = $sth->getColumnMeta($i);
				printf("%s\t", $meta["name"]);
			}
			printf("\n");
			#Loop through the rows
			while ($row = $sth->fetch()){
				for ($i = 0; $i < $sth->columnCount( ); $i ++){
					printf("%s\t", $row[$i]);
				}
			}
			/* $data = $sth->fetchAll();
			var_dump($data); */
		
			printf("-------------------\n");
		}		
	} while($sth->nextRowset( ))
	
	
	
	
	
 ?>