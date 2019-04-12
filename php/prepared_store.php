<?php
	$mysqli = new mysqli("localhost", "user_db", "123456s", "test");
	if (mysqli_connect_errno( )) {
		printf("Connect failed: %s\n", mysqli_connect_error( ));
		exit ( );
	} else {
		printf("Connect succeeded\n");
	}
	$sql = "CALL customers_for_rep(?)";
	$stmt = $mysqli->prepare($sql);
	if ($mysqli->errno<>0) {die($mysqli->errno.": ".$mysqli->error);}
	$stmt->bind_param("i", $in_sales_rep_id); #i=integer s - string
	$in_sales_rep_id = 1;
	$stmt->execute( );
	if ($mysqli->errno) {die($mysqli->errno.": ".$mysqli->error);}	
	
	$stmt->bind_result($customer_id,$customer_name);
	while ($stmt->fetch( )) {
		printf("%d %s \n", $customer_id,$customer_name);
	}
	
	
 ?>