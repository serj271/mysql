delimiter //
DROP FUNCTION IF EXISTS sp_replace_phone//

CREATE FUNCTION sp_replace_phone(phone VARCHAR(24)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE str VARCHAR(24);
    SET str := REPLACE(phone, '-','');
    IF LENGTH(str) = 4 THEN
	SET str := CONCAT('1', str);
    
    END IF;
    
    RETURN  str * 1;
END;
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_replace_phone TO 'user_db'@'localhost';

