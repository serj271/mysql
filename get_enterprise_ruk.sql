delimiter //
DROP PROCEDURE IF EXISTS get_enterprise_ruk;
DROP TABLE IF EXISTS users_by_results;
CREATE PROCEDURE get_enterprise_ruk(IN param1 VARCHAR(255), IN param2 VARCHAR(10))
BEGIN
/*    DECLARE xname VARCHAR(5) DEFAULT 'bob';*/
    DECLARE record_count INT;    
/* ceate temp table */
    CREATE TEMPORARY TABLE users_by_results
	SELECT id,room,enterprise,department,position,ind,cat, 
	    first_name,name_name,last_name,phone, phone1, email_zimbra,
	    concat(first_name,' ',name_name,' ',last_name) as full_name
	    FROM listing
	    WHERE enterprise=param1 and ind='1';
/* count results*/

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
		
/* retunrt results */
    DROP TABLE IF EXISTS users_by_results;
END
//
delimiter ;
 
GRANT EXECUTE ON PROCEDURE personal_utf8.get_enterprise_ruk TO 'user_db'@'localhost';
