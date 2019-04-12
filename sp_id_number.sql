delimiter //
DROP FUNCTION IF EXISTS sp_id_number//

CREATE FUNCTION sp_id_number(id CHAR(7)) RETURNS INT DETERMINISTIC
BEGIN
    
    RETURN  id *1;
END;
//
delimiter ;
GRANT EXECUTE ON FUNCTION personal_utf8.sp_id_number TO 'user_db'@'localhost';

