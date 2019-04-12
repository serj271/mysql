<?php
	$mysqli = new mysqli("localhost", "user_db", "123456s", "test");
	if (mysqli_connect_errno( )) {
		printf("Connect failed: %s\n", mysqli_connect_error( ));
		exit ( );
	} else {
		printf("Connect succeeded\n");
	}
	$employee_id = 1;
	$query = "call stored_proc_with_2_results( $employee_id )";
	/* if ($mysqli->multi_query($query)) {
		$result = $mysqli->store_result();
		while ($row = $result->fetch_object()){
			printf("%d %s %s\n",$row->employee_id,$row->surname,$row->firstname);
		}
		$mysqli->next_result( );
		$result = $mysqli->store_result();
		while ($row = $result->fetch_object()){
			printf("%d %s \n",$row->customer_id,$row->customer_name);
		}
	} */
	
	if ($mysqli->multi_query($query)){
		do {
			$i = true;
			if ($result = $mysqli->store_result()) {
				while ($finfo = $result->fetch_field()){
					printf("%s\t", $finfo->name);
				}
				printf("\n");

				while ($row = $result->fetch_row( )) {
					for ($i=0;$i<$result->field_count;$i++) {
						printf("%s\t", $row[$i]);
					}
					printf("\n");
				}
				$result->free( );
			}
			if ($mysqli->more_results()) {
				$i = true;
				printf("-----------------\n");
			} else {
				$i = false;
			}
			
		} while ($i && $mysqli->next_result( ));		
	}
	$mysqli->close();
	
 ?>