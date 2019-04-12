delimiter //
DROP FUNCTION IF EXISTS sp_phone_number_new//

CREATE FUNCTION sp_phone_number_new(phone VARCHAR(24)) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE str VARCHAR(24);
        
    SET str := REPLACE(phone, '-','');
    SET str := REPLACE(phone, '(','');    
    RETURN str * 1;
END;
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_test_utf8.sp_phone_number_new TO 'user_db'@'localhost';

