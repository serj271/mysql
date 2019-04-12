delimiter //
DROP FUNCTION IF EXISTS sp_phone_number//

CREATE FUNCTION sp_phone_number(phone VARCHAR(24)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE str INT;
    
    RETURN  REPLACE(phone, '-','') *1;
END;
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_phone_number TO 'user_db'@'localhost';

