
delimiter //
DROP FUNCTION IF EXISTS sp_room_number//
CREATE FUNCTION sp_room_number(room VARCHAR(5)) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN LEFT(room, 3) *1;
END;
//
delimiter ;


