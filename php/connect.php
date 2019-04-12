<?php
	$mysqli = new mysqli("localhost", "user_db", "123456s", "test");
	if (mysqli_connect_errno( )) {
		printf("Connect failed: %s\n", mysqli_connect_error( ));
		exit ( );
	} else {
		printf("Connect succeeded\n");
	}
 ?>