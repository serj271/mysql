DROP PROCEDURE IF EXISTS curdemo;
delimiter //
CREATE PROCEDURE curdemo ()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE a CHAR(16);
    DECLARE b, c INT;
    DECLARE cur1 CURSOR for SELECT id,data FROM test.t1;
    DECLARE cur2 CURSOR for SELECT i FROM test.t2;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done  = 1;
    
    OPEN cur1;
    OPEN cur2;
    
    REPEAT
	FETCH cur1 INTO a, b;
	FETCH cur2 INTO c;    
	IF NOT done THEN 
	    IF b < c THEN
		INSERT INTO test.t3 VALUES (a,b);
	    ELSE 
		INSERT INTO test.t3 VALUES (a,c);
	    END IF;
	END IF;
    UNTIL done END REPEAT;
    
    CLOSE cur1;
    CLOSE cur2;
END
//
delimiter ;

