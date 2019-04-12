<?php
	$mysqli = new mysqli("localhost", "user_db", "123456s", "test");
	if (mysqli_connect_errno( )) {
		printf("Connect failed: %s\n", mysqli_connect_error( ));
		exit ( );
	} else {
		printf("Connect succeeded\n");
	}
	$sql="CALL sp_rep_customer_count(1,@customer_count)";
	$stmt = $mysqli->prepare($sql);
	if ($mysqli->errno) {die($mysqli->errno.": ".$mysqli->error);}
	$stmt->execute( );
	if ($mysqli->errno) {die($mysqli->errno.": ".$mysqli->error);}
	$stmt->close( );
	$results = $mysqli->query("SELECT @customer_count AS customer_count");
	$row = $results->fetch_object( );
	printf("Customer count=%d\n",$row->customer_count);
	
	
 ?>