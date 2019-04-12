DROP PROCEDURE IF EXISTS sp_users_by_room;
DROP TABLE IF EXISTS users_by_results;
delimiter //
CREATE PROCEDURE sp_users_by_room(IN param1 VARCHAR(5), OUT record_count INT)
BEGIN
    DECLARE xname VARCHAR(5) DEFAULT 'bob';
    
/* ceate temp table */
    CREATE TEMPORARY TABLE users_by_results
	SELECT id
	    FROM listing
	    WHERE room=param1;
/* count results*/
    SELECT COUNT(*) INTO record_count
	FROM users_by_results;

    IF record_count = 0 THEN
	SELECT 0 as id, "Not data" AS TITLE;
    ELSE
	SELECT * 
	    FROM users_by_results;
    END IF;	
		
/* retunrt results */
    DROP TABLE IF EXISTS users_by_results;
END;
//
delimiter ;


