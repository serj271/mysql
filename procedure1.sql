DROP PROCEDURE IF EXISTS sp_users_by_room;
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
/* retunrt results */
    SELECT * 
	FROM users_by_results;
    DROP TABLE IF EXISTS users_by_results;
END;
//
delimiter ;


