delimiter //
DROP FUNCTION IF EXISTS sp_phone_number//

CREATE FUNCTION sp_phone_number(phone VARCHAR(24)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE str INT;    
    RETURN  REPLACE(phone, '-','') *1;
END
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_phone_number TO 'user_db'@'localhost';

delimiter //
DROP FUNCTION IF EXISTS sp_room_number//
CREATE FUNCTION sp_room_number(room VARCHAR(5)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE str INT;
    RETURN LEFT(room, 3) *1;
END
//
DELIMITER ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_phone_number TO 'user_db'@'localhost';

DELIMITER //
DROP PROCEDURE IF EXISTS get_enterprise//
CREATE DEFINER=`root`@`localhost` PROCEDURE get_enterprise(IN param1 VARCHAR(255), param2 VARCHAR(10))
BEGIN

    DECLARE record_count INT;
    CREATE TEMPORARY TABLE users_by_results
	SELECT id,room,enterprise,department,position, 
	    first_name,name_name,last_name,phone, phone1, email_zimbra,
	    concat(first_name,' ',name_name,' ',last_name) as full_name
	    FROM listing
	    WHERE enterprise=param1;

    SELECT COUNT(*) INTO record_count
	FROM users_by_results;

    IF record_count = 0 THEN
	SELECT 0 as id, "Not data" AS TITLE;
    ELSE
	CASE param2
	    WHEN 'room' THEN
		SELECT * 
		FROM users_by_results order by sp_room_number(room);
	    WHEN 'id' THEN
		SELECT * 
		FROM users_by_results order by id;
	    WHEN 'email' THEN
		SELECT * 
		FROM users_by_results order by id;
	    WHEN 'phone' THEN
		SELECT * 
		FROM users_by_results order by phone;
	    WHEN 'first_name' THEN
		SELECT * 
		FROM users_by_results order by first_name;
	    WHEN 'department' THEN
		SELECT * 
		FROM users_by_results order by department;
	    ELSE
		SELECT * 
		FROM users_by_results order by first_name;
	END CASE;

    END IF;	
		

    DROP TABLE IF EXISTS users_by_results;
END
//
DELIMITER ;
GRANT EXECUTE ON PROCEDURE personal_utf8.get_enterprise TO 'user_db'@'localhost';

DELIMITER //
DROP PROCEDURE IF EXISTS get_room//
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_room`(IN param1 VARCHAR(5))
BEGIN
/*    DECLARE xname VARCHAR(5) DEFAULT 'bob';*/
    DECLARE record_count INT;    

    CREATE TEMPORARY TABLE users_by_results
	SELECT id,enterprise,department,position, 
	    first_name,name_name,last_name,phone, phone1, email_zimbra,
	    concat(first_name,' ',name_name,' ',last_name) as full_name
	    FROM listing
	    WHERE room=param1;

    SELECT COUNT(*) INTO record_count
	FROM users_by_results;

    IF record_count = 0 THEN
	SELECT 0 as id, "Not data" AS TITLE;
    ELSE
	SELECT * 
	    FROM users_by_results;
    END IF;		

    DROP TABLE IF EXISTS users_by_results;
END
//
DELIMITER ;
GRANT EXECUTE ON FUNCTION personal_utf8.get_room TO 'user_db'@'localhost';

delimiter //
DROP FUNCTION IF EXISTS sp_id_number//

CREATE FUNCTION sp_id_number(id CHAR(7)) RETURNS INT DETERMINISTIC
BEGIN
    
    RETURN  id *1;
END
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_id_number TO 'user_db'@'localhost';













