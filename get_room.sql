
delimiter //
DROP PROCEDURE IF EXISTS get_room;
DROP TABLE IF EXISTS users_by_results;

CREATE PROCEDURE get_room (OUT param1 INT)
    BEGIN
/*    DECLARE xname VARCHAR(5) DEFAULT 'bob';*/
/*	DECLARE record_count VARCHAR(5);    */
/* ceate temp table */
	    SELECT count(room) INTO param1 from listing;

/* count results*/
		
/* returt results */
/*	DROP TABLE IF EXISTS users_by_results;*/
    END
//
delimiter ;


