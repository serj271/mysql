/* LEAVE cancel LOOP REPEAT WHILE*/
delimiter //
CREATE PROCEDURE dowhile(p1 INT)
BEGIN
    DECLARE v1 INT DEFAULT 5;
    
    WHILE v1 > 0 DO

    
    SET v1 = v1 -1;
    END WHILE;
END
//
delimiter ;


