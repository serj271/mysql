DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;
CREATE TABLE t1(
    id CHAR(16) NOT NULL,
    data INT
);
CREATE TABLE t2(
    i INT
);
CREATE TABLE t3(
    id CHAR(16) NOT NULL,
    data INT
);

CREATE TABLE t4(
    id int(11) NOT NULL,
    value VARCHAR(32)
);
CREATE TABLE account_balance(
	account_id INT(11),
	balance NUMERIC(8,2)
);

CREATE TABLE employees(
    employee_id int(11) NOT NULL,
    department_id int(11) NOT NULL,
    surname VARCHAR(32),
    firstname VARCHAR(32),
	date_of_birth datetime default null,
	salary NUMERIC(8,2),
    status VARCHAR(32),
	PRIMARY KEY(employee_id)
) ENGINE=INNODB;
CREATE TABLE customers(
    customer_id int(11) NOT NULL,
    customer_name VARCHAR(32),
	contact_surname VARCHAR(32),
	sales_rep_id int(11)
) ENGINE=INNODB;

CREATE TABLE sales(
	id int(11),
    customer_id int(11) NOT NULL,
	sale_value decimal(10,2) unsigned DEFAULT '0.00'
) ENGINE=INNODB;

CREATE TABLE departments(
	department_id int(11) NOT NULL AUTO_INCREMENT,
    department_name varchar(32),
	location varchar(32) default null,
	manager_id INT(32) NOT NULL,
	PRIMARY KEY(`department_id`),
	UNIQUE (department_name),
	FOREIGN KEY (manager_id)
      REFERENCES employees(employee_id)
) ENGINE=INNODB;

CREATE TABLE product_codes(
	product_code VARCHAR(2),
    product_name varchar(32) NOT NULL,
	UNIQUE (product_code)
) ENGINE=INNODB;

CREATE TABLE locations(
	location VARCHAR(32),
	address1 VARCHAR(32),
	address2 VARCHAR(32),
	zipcode CHAR(8),
	UNIQUE (location)
) ENGINE=INNODB;
CREATE TABLE customer_sales_totals(
	customer_id INT(32),
	sale_value decimal(10,2) unsigned DEFAULT '0.00'
);

CREATE TABLE AUDIT_LOG(
	audit_message varchar(64)
);

DROP PROCEDURE IF EXISTS test.customers_for_rep;
delimiter //
CREATE PROCEDURE customers_for_rep(in_sales_rep_id INT)
	READS SQL DATA
		SELECT customer_id,customer_name
			FROM customers
				WHERE sales_rep_id=in_sales_rep_id;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.customers_for_rep TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_rep_customer_count;
delimiter //
CREATE PROCEDURE sp_rep_customer_count(in_emp_id DECIMAL(8,0),OUT out_cust_count INT)
	NOT DETERMINISTIC READS SQL DATA
	BEGIN
		SELECT count(*)
		INTO out_cust_count
		FROM customers
		WHERE sales_rep_id=in_emp_id;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_rep_customer_count TO 'user_db'@'localhost';


DROP PROCEDURE IF EXISTS test.stored_proc_with_2_results;
delimiter //
CREATE PROCEDURE stored_proc_with_2_results(in_sales_rep_id INT)
	DETERMINISTIC READS SQL DATA
	BEGIN
		SELECT employee_id,surname,firstname
		FROM employees
		WHERE employee_id=in_sales_rep_id;
		
		SELECT customer_id,customer_name
		FROM customers
		WHERE sales_rep_id=in_sales_rep_id;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.stored_proc_with_2_results TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_employee_report;
delimiter //
CREATE PROCEDURE sp_employee_report(in_emp_id decimal(8,0))
	READS SQL DATA
	BEGIN
		DECLARE customer_count INT;
		SELECT surname,firstname
			FROM employees
			WHERE employee_id=in_emp_id;
		SELECT department_id,department_name
			FROM departments
			WHERE department_id IN (select department_id FROM employees WHERE employee_id=in_emp_id);
		SELECT COUNT(*)
			FROM customers
			WHERE sales_rep_id=in_emp_id
			INTO customer_count;
		
		IF customer_count=0 THEN
			SELECT 'Employee is not a current sales rep';
		ELSE
			SELECT customer_name
				FROM customers
				WHERE sales_rep_id=in_emp_id;
			SELECT customer_name,sum(sale_value)
				FROM sales JOIN customers USING (customer_id)
				WHERE customers.sales_rep_id=in_emp_id
			GROUP BY customer_name;
		END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_employee_report TO 'user_db'@'localhost';


DROP PROCEDURE IF EXISTS test.sp_employee_report_out;
delimiter //
CREATE PROCEDURE sp_employee_report_out
	(in_emp_id INTEGER,
		OUT out_customer_count INTEGER)
	BEGIN
		SELECT employee_id,surname,firstname
			FROM employees
		 	WHERE employee_id=in_emp_id;
		SELECT department_id,department_name
			FROM departments
			WHERE department_id=
				(select department_id
					FROM employees
					WHERE employee_id=in_emp_id limit 1);
		SELECT COUNT(*)
			INTO out_customer_count
			FROM customers
			WHERE sales_rep_id=in_emp_id;
		IF out_customer_count=0 THEN
			SELECT 'Employee is not a current sales rep';
				ELSE
			SELECT customer_name
				FROM customers
				WHERE sales_rep_id=in_emp_id;
			SELECT customer_name,SUM(sale_value) as "TOTAL SALES",
				MAX(sale_value) as "MAX SALE"
				FROM sales JOIN customers USING (customer_id)
				WHERE customers.sales_rep_id=in_emp_id
				GROUP BY customer_name;
		END IF;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_employee_report_out TO 'user_db'@'localhost';


DROP PROCEDURE IF EXISTS test.department_list;
delimiter //
	CREATE PROCEDURE department_list()
		SELECT department_name,department_id from departments;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.department_list TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.customer_list;
delimiter //
	CREATE PROCEDURE customer_list(in_sales_rep_id INTEGER)
			SELECT customer_id,customer_name
	FROM customers
	WHERE sales_rep_id=in_sales_rep_id;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.customer_list TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_rep_report;
delimiter //
	CREATE PROCEDURE sp_rep_report(in_sales_rep_id INTEGER)
	BEGIN
		SELECT employee_id,surname,firstname
			FROM employees
			WHERE employee_id=in_sales_rep_id;
		SELECT customer_id,customer_name
			FROM customers
			WHERE sales_rep_id=in_sales_rep_id;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_rep_report TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.randomizer;
delimiter //
	CREATE PROCEDURE randomizer(INOUT a_number FLOAT)
	NOT DETERMINISTIC NO SQL
	SET a_number=RAND( )*a_number;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.randomizer TO 'user_db'@'localhost';

DROP FUNCTION IF EXISTS test.f_age;
delimiter //
	CREATE FUNCTION f_age(in_dob datetime) returns int
	NO SQL
	BEGIN
		DECLARE l_age INT;
		IF DATE_FORMAT(NOW( ),'00-%m-%d') >= DATE_FORMAT(in_dob,'00-%m-%d') THEN
			-- This person has had a birthday this year
			SET l_age=DATE_FORMAT(NOW( ),'%Y')-DATE_FORMAT(in_dob,'%Y');
		ELSE
			-- Yet to have a birthday this year
			SET l_age=DATE_FORMAT(NOW( ),'%Y')-DATE_FORMAT(in_dob,'%Y')-1;
		END IF;
		RETURN(l_age);
	END
//
delimiter ;
GRANT EXECUTE ON FUNCTION test.f_age TO 'user_db'@'localhost';

DROP FUNCTION IF EXISTS test.f_discount_price;
delimiter //
	CREATE FUNCTION f_discount_price(
	normal_price NUMERIC(8,2))
	RETURNS NUMERIC(8,2)
	DETERMINISTIC
	BEGIN
		DECLARE discount_price NUMERIC(8,2);
		
		IF(normal_price>500) THEN
			SET discount_price=normal_price*.8;
		ELSEIF(normal_price>100) THEN
			SET discount_price=normal_price*.9;
		ELSE
			SET discount_price=normal_price;
		END IF;
		RETURN(discount_price);
	END
//
delimiter ;
GRANT EXECUTE ON FUNCTION test.f_discount_price TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_product_code;
delimiter //
	CREATE PROCEDURE sp_product_code(in_product_code VARCHAR(2),
		in_product_name VARCHAR(30))
	BEGIN
		DECLARE l_dupkey_indicator INT DEFAULT 0;
		DECLARE duplicate_key CONDITION FOR 1062;
		DECLARE CONTINUE HANDLER FOR duplicate_key SET l_dupkey_indicator =1;

		INSERT INTO product_codes (product_code, product_name)
		VALUES (in_product_code, in_product_name);

		IF l_dupkey_indicator THEN
			UPDATE product_codes
				SET product_name=in_product_name
				WHERE product_code=in_product_code;
		END IF;
END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_product_code TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.simple_loop;
delimiter //
	CREATE PROCEDURE simple_loop()
	BEGIN
		DECLARE counter INT DEFAULT 0;
		
		simple_loop: LOOP
			SET counter=counter+1;
			/* select counter; */
			IF counter=10 THEN
				LEAVE simple_loop;
			END IF;
		END LOOP simple_loop;
		select 'I count to 10';
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.simple_loop TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.customer_sales;
delimiter //
	CREATE PROCEDURE customer_sales(in_customer_id INT)
	READS SQL DATA
	BEGIN
		DECLARE total_sales NUMERIC(8,2);
		SELECT SUM(sale_value)
			INTO total_sales
			FROM sales
			WHERE customer_id=in_customer_id;
		
		select CONCAT('Total sales for ',in_customer_id,' is ', total_sales);
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.customer_sales TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.cursor_example;
delimiter //
	CREATE PROCEDURE cursor_example(in_customer_id INT)
	READS SQL DATA
	BEGIN
		DECLARE i_employee_id INT;		
		DECLARE i_salary NUMERIC(8,2);
		DECLARE i_department_id INT;
		DECLARE done INT DEFAULT 0;
		DECLARE curl CURSOR FOR
			SELECT employee_id,salary,department_id
			FROM employees;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
		OPEN curl;
		empl_loop: LOOP
			FETCH curl INTO i_employee_id,i_salary,i_department_id;
			IF done=1 THEN
				LEAVE empl_loop;
			END IF;
		END LOOP empl_loop;
		CLOSE curl;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.cursor_example TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_enums;
delimiter //
	CREATE PROCEDURE sp_enums(in_option ENUM('Yes','No','Maybe'))
	BEGIN
		DECLARE position INTEGER;
		SET position=in_option;
		SELECT in_option,position;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_enums TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.nested_blocks5;
delimiter //
	CREATE PROCEDURE nested_blocks5()
	outer_block: BEGIN
	DECLARE l_status int;
	SET l_status=1;
	inner_block: BEGIN
		IF (l_status=1) THEN
			LEAVE inner_block;
		END IF;
		SELECT 'This statement will never be executed';
	END inner_block;
	SELECT 'End of program';
	END outer_block
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.nested_blocks5 TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.repeat_until;
delimiter //
	CREATE PROCEDURE repeat_until()
	READS SQL DATA
	BEGIN
		DECLARE no_more_departments INT DEFAULT 0;
		DECLARE i_department_id int(11);
		DECLARE i_department_name VARCHAR(32);
		DECLARE l_department_count INT(11);
		
		DECLARE dept_csr CURSOR FOR
			SELECT department_id,department_name
				FROM departments;
				
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_departments=1;
		
		SET no_more_departments=0;
		
		OPEN dept_csr;
		dept_loop:REPEAT
			FETCH dept_csr INTO i_department_id,i_department_name;
			IF no_more_departments=0 THEN
				SET l_department_count=l_department_count+1;
			END IF;
			UNTIL no_more_departments
		END REPEAT dept_loop;
		CLOSE dept_csr;
		SET no_more_departments=0;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.repeat_until TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.repeat_while;
delimiter //
	CREATE PROCEDURE repeat_while()
	READS SQL DATA
	BEGIN
		DECLARE no_more_departments INT DEFAULT 0;
		DECLARE l_department_id int(11);
		DECLARE l_department_name VARCHAR(32);
		DECLARE l_department_count INT(11);
		
		DECLARE dept_csr CURSOR FOR
			SELECT department_id,department_name
				FROM departments;
				
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_departments=1;
		
		SET no_more_departments=0;
		OPEN dept_csr;
		dept_loop:WHILE(no_more_departments=0) DO
			FETCH dept_csr INTO l_department_id,l_department_name;
			IF no_more_departments=1 THEN
				LEAVE dept_loop;
			END IF;
			SET l_department_count=l_department_count+1;
		END WHILE dept_loop;
		CLOSE dept_csr;
		SET no_more_departments=0;
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.repeat_while TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.nested_cursor;
delimiter //
	CREATE PROCEDURE nested_cursor()
	READS SQL DATA
	BEGIN
		DECLARE l_done INT DEFAULT 0;
		DECLARE l_department_id int(11);
		DECLARE l_department_name VARCHAR(32);
		DECLARE l_emp_count INT(11);
		DECLARE l_employee_id INT(11);
		
		DECLARE dept_csr cursor FOR
			SELECT department_id FROM departments;
		DECLARE emp_csr cursor FOR
			SELECT employee_id FROM employees
			WHERE department_id=l_department_id;
			
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
		
		OPEN dept_csr;
			dept_loop: LOOP -- Loop through departments
			FETCH dept_csr into l_department_id;
			IF l_done=1 THEN
				LEAVE dept_loop;
			END IF;
			OPEN emp_csr;
				SET l_emp_count=0;
				emp_loop: LOOP -- Loop through employee in dept.
					FETCH emp_csr INTO l_employee_id;
					IF l_done=1 THEN
						LEAVE emp_loop;
					END IF;
					SET l_emp_count=l_emp_count+1;
				END LOOP;
			CLOSE emp_csr;
			SET l_done=0;
			SELECT CONCAT('Department ',l_department_id,' has ',l_emp_count,' employees');
			END LOOP dept_loop;
		CLOSE dept_csr;	
		
	END
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.nested_cursor TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_add_location;
delimiter //
	CREATE PROCEDURE sp_add_location(
		in_location VARCHAR(30),
		in_address1 VARCHAR(30),
		in_address2 VARCHAR(30),
		zipcode VARCHAR(10),
		OUT out_status VARCHAR(30))
	MODIFIES SQL DATA
	BEGIN
		DECLARE CONTINUE HANDLER FOR 1062
			SET out_status='Duplicate Entry';
		SET out_status='OK';
		INSERT INTO locations
			(location,address1,address2,zipcode)
		VALUES
			(in_location,in_address1,in_address2,zipcode);
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_add_location TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_add_department;
delimiter //
	CREATE PROCEDURE sp_add_department
		(in_emp_id INT(32),
		in_dept_name VARCHAR(30),
		in_location VARCHAR(30),
		in_manager_id INT)
	MODIFIES SQL DATA
	BEGIN
		DECLARE duplicate_key INT DEFAULT 0;
			BEGIN
				DECLARE EXIT HANDLER FOR 1062 /* Duplicate key*/ SET duplicate_key=1;

				INSERT INTO departments (department_id,department_name,location,manager_id)
					VALUES(in_emp_id,in_dept_name,in_location,in_manager_id);

				SELECT CONCAT('Department ',in_dept_name,' created') as "Result";
			END;

			IF duplicate_key=1 THEN
				SELECT CONCAT('Failed to insert ',in_dept_name,': duplicate key') as "Result";
			END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_add_department TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_add_department_continue;
delimiter //
	CREATE PROCEDURE sp_add_department_continue
		(in_emp_id INT(32),
		in_dept_name VARCHAR(30),
		in_location VARCHAR(30),
		in_manager_id INT)
	MODIFIES SQL DATA
	
	BEGIN
		DECLARE duplicate_key INT(32);
		DECLARE CONTINUE HANDLER FOR 1062 /* Duplicate key*/
		SET duplicate_key=1;
		INSERT INTO departments (department_name,location,manager_id)
			VALUES(in_dept_name,in_location,in_manager_id);
		IF duplicate_key=1 THEN
			SELECT CONCAT('Failed to insert ',in_dept_name,
			': duplicate key') as "Result";
		ELSE
			SELECT CONCAT('Department ',in_dept_name,' created') as "Result";
		END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_add_department_continue TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_update_employee_dob;
delimiter //
	CREATE PROCEDURE sp_update_employee_dob
		(p_employee_id INT, p_dob DATE, OUT p_status varchar(64))
	
	BEGIN
		/* DECLARE employee_is_too_young CONDITION FOR SQLSTATE '99001'; 
		ERROR 90001 (99001): Employee must be 16 years or older*/
		IF DATE_SUB(curdate( ), INTERVAL 16 YEAR) <p_dob THEN
			SET p_status='Employee must be 16 years or older';
		ELSE
			UPDATE employees
				SET date_of_birth=p_dob
				WHERE employee_id=p_employee_id;
		SET p_status='Ok';
		END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_update_employee_dob TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_update_employee_dob2;
delimiter //
	CREATE PROCEDURE sp_update_employee_dob2
	(p_employee_id INT, p_dob DATE)
	BEGIN
		IF datediff(curdate( ),p_dob)<(16*365) THEN
			UPDATE `Error: employee_is_too_young; Employee must be 16 years or older`
			SET x=1;
		ELSE
			UPDATE employees
			SET date_of_birth=p_dob
				WHERE employee_id=p_dob;
		END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_update_employee_dob2 TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.sp_add_department2;
delimiter //
	CREATE PROCEDURE sp_add_department2
	(p_department_name VARCHAR(30),
		p_manager_surname VARCHAR(30),
		p_manager_firstname VARCHAR(30),
		p_location VARCHAR(30),
		OUT p_sqlcode INT,
		OUT p_status_message VARCHAR(100)
	)
	BEGIN
		DECLARE duplicate_key CONDITION FOR 1062;
		DECLARE foreign_key_violated CONDITION FOR 1216;
		
		DECLARE l_manager_id INT;

		DECLARE csr_mgr_id CURSOR FOR
			SELECT employee_id
				FROM employees
				WHERE surname=UPPER(p_manager_surname)
					AND firstname=UPPER(p_manager_firstname);
		
		DECLARE CONTINUE HANDLER FOR duplicate_key
		
		BEGIN
			SET p_sqlcode=1052;
			SET p_status_message='Duplicate key error';
		END;
		
		DECLARE CONTINUE HANDLER FOR foreign_key_violated
		BEGIN
			SET p_sqlcode=1216;
			SET p_status_message='Foreign key violated';
		END;

		DECLARE CONTINUE HANDLER FOR not FOUND
		BEGIN
			SET p_sqlcode=1329;
			SET p_status_message='No record found';
		END;
		
		SET p_sqlcode=0;
		OPEN csr_mgr_id;
			FETCH csr_mgr_id INTO l_manager_id;

			IF p_sqlcode<>0 THEN /* Failed to get manager id*/
				SET p_status_message=CONCAT(p_status_message,' when fetching manager id');
			ELSE
				 /* Got manager id, we can try and insert */
				INSERT INTO departments (department_name,manager_id,location)
				VALUES(UPPER(p_department_name),l_manager_id,UPPER(p_location));
				IF p_sqlcode<>0 THEN/* Failed to insert new department */
					SET p_status_message=CONCAT(p_status_message,
				 ' when inserting new department');
				END IF;
			END IF;
		CLOSE csr_mgr_id;		
		
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.sp_add_department2 TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.savepoint_example;
delimiter //
	CREATE PROCEDURE savepoint_example
		(in_department_name VARCHAR(30),
		in_location VARCHAR(30),
		in_address1 VARCHAR(30),
		in_address2 VARCHAR(30),
		in_zipcode VARCHAR(10),
		in_manager_id INT)
	
	BEGIN
		DECLARE sp_location_exists INT DEFAULT 0;
		DECLARE duplicate_dept INT DEFAULT 0;
		DECLARE location_exists INT  DEFAULT 0;

		START TRANSACTION;

		SELECT COUNT(*)
			INTO location_exists
			FROM locations
			WHERE location=in_location;

		IF location_exists=0 THEN

			INSERT INTO AUDIT_LOG (audit_message)
			VALUES (CONCAT('Creating new location',in_location));

			INSERT INTO locations (location,address1,address2,zipcode)
			VALUES (in_location,in_address1,in_address2,in_zipcode);
		ELSE
			UPDATE locations set address1=in_address1,address2=in_address2,zipcode=in_zipcode
			WHERE location=in_location;

		END IF;

		SAVEPOINT savepoint_location_exists;
		BEGIN
		
			DECLARE DUPLICATE_KEY CONDITION FOR 1062;
			DECLARE CONTINUE HANDLER FOR DUPLICATE_KEY 
			BEGIN
				SET duplicate_dept=1;
				ROLLBACK TO SAVEPOINT savepoint_location_exists;
			END;

			INSERT INTO AUDIT_LOG (audit_message)
				VALUES (CONCAT('Creating new department',in_department_name));

			INSERT INTO departments (department_name,location,manager_id)
				VALUES (in_department_name,in_location, in_manager_id);

			IF duplicate_dept=1 THEN

				UPDATE departments
				SET location=in_location,manager_id=in_manager_id
				WHERE department_name=in_department_name;
			END IF;

		END;
		COMMIT;			
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.savepoint_example TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.nested_tfer_funds;
delimiter //
	CREATE PROCEDURE nested_tfer_funds(
		in_from_acct INTEGER,
		in_to_acct INTEGER,
		in_tfer_amount DECIMAL(8,2))
	
	BEGIN
		DECLARE txn_error INTEGER DEFAULT 0 ;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN
			SET txn_error=1;
		END;
		SAVEPOINT savepoint_tfer;
		UPDATE account_balance
			SET balance=balance-in_tfer_amount
			WHERE account_id=in_from_acct;
		IF txn_error THEN
			ROLLBACK TO savepoint_tfer;
			SELECT 'Transfer aborted ';
		ELSE
			UPDATE account_balance
				SET balance=balance+in_tfer_amount
				WHERE account_id=in_to_acct;
			IF txn_error THEN
				ROLLBACK TO savepoint_tfer;
				SELECT 'Transfer aborted ';
			END IF;
		END IF;
		
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.nested_tfer_funds TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.tfer_funds4;/* no */
delimiter //
	CREATE PROCEDURE tfer_funds4
		(from_account int, to_account int,tfer_amount numeric(10,2),
		OUT status int, OUT message VARCHAR(30))
	
	BEGIN
		DECLARE from_account_balance NUMERIC(10,2);
		SELECT balance
			INTO from_account_balance
			FROM account_balance
			WHERE account_id=from_account;
		IF from_account_balance >= tfer_amount THEN
			START TRANSACTION;
			UPDATE account_balance
			SET balance=balance-tfer_amount
			WHERE account_id=from_account;
			UPDATE account_balance
			SET balance=balance+tfer_amount
			WHERE account_id=to_account;
			COMMIT;
			SET status=0;
			SET message='OK';
			ELSE
			SET status=-1;
			SET message='Insufficient funds';
		END IF;		
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.tfer_funds4 TO 'user_db'@'localhost';

DROP PROCEDURE IF EXISTS test.tfer_funds5;/* no */
delimiter //
	CREATE PROCEDURE tfer_funds5
		(from_account INT, to_account INT,tfer_amount NUMERIC(10,2),
		OUT status INT, OUT message VARCHAR(30))
	
	BEGIN
		DECLARE from_account_balance NUMERIC(10,2);
		START TRANSACTION;
		SELECT balance
			INTO from_account_balance
			FROM account_balance
			WHERE account_id=from_account
			FOR UPDATE;
		IF from_account_balance>=tfer_amount THEN
			UPDATE account_balance
			SET balance=balance-tfer_amount
			WHERE account_id=from_account;
			UPDATE account_balance
			SET balance=balance+tfer_amount
			WHERE account_id=to_account;
			COMMIT;
			SET status=0;
			SET message='OK';
		ELSE
			ROLLBACK;
			SET status=-1;
			SET message='Insufficient funds';
		END IF;
	END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE test.tfer_funds5 TO 'user_db'@'localhost';

DROP FUNCTION IF EXISTS test.my_replace;
delimiter //
	CREATE FUNCTION my_replace
		(in_string VARCHAR(255),
		in_find_str VARCHAR(20),
		in_repl_str VARCHAR(20))
	RETURNS VARCHAR(255)
	NO SQL
	BEGIN
		DECLARE l_new_string VARCHAR(255);
		DECLARE l_find_pos INT;
		SET l_find_pos=INSTR(in_string,in_find_str);
		IF (l_find_pos>0) THEN
			SET l_new_string=INSERT(in_string,l_find_pos,LENGTH(in_find_str),in_repl_str);
		ELSE
			SET l_new_string=in_string;
		END IF;
		RETURN(l_new_string);
	END
//
delimiter ;
GRANT EXECUTE ON FUNCTION test.my_replace TO 'user_db'@'localhost';

DROP FUNCTION IF EXISTS test.customers_for_rep;
delimiter //
	CREATE FUNCTION customers_for_rep(in_rep_id INT)
	RETURNS INT
	READS SQL DATA
	BEGIN
		DECLARE customer_count INT;
			SELECT COUNT(*)
			INTO customer_count
			FROM customers
			WHERE sales_rep_id=in_rep_id;
		RETURN(customer_count);
	END
//
delimiter ;
GRANT EXECUTE ON FUNCTION test.customers_for_rep TO 'user_db'@'localhost';

delimiter //
	CREATE TRIGGER sales_bi_trg
	BEFORE INSERT ON sales
		FOR EACH ROW
	BEGIN
		DECLARE row_count INTEGER;
		SELECT COUNT(*)
			INTO row_count
			FROM customer_sales_totals
			WHERE customer_id=NEW.customer_id;
		IF row_count > 0 THEN
			UPDATE customer_sales_totals
			SET sale_value=sale_value+NEW.sale_value
			WHERE customer_id=NEW.customer_id;
		ELSE
			INSERT INTO customer_sales_totals
			(customer_id,sale_value)
			VALUES(NEW.customer_id,NEW.sale_value);
		END IF;
	END
//
delimiter ;

 
delimiter //
CREATE TRIGGER sales_bu_trg
	BEFORE UPDATE ON sales
	FOR EACH ROW
	BEGIN
		UPDATE customer_sales_totals
		SET sale_value=sale_value+(NEW.sale_value-OLD.sale_value)
		WHERE customer_id=NEW.customer_id;
	END
//
delimiter ;


delimiter //
CREATE TRIGGER sales_bd_trg
	BEFORE DELETE ON sales
	FOR EACH ROW
	BEGIN
		UPDATE customer_sales_totals
		SET sale_value=sale_value-OLD.sale_value
		WHERE customer_id=OLD.customer_id;
	END
//
delimiter ;


INSERT INTO t1 VALUES('a',2);
INSERT INTO t2 VALUES(3);
INSERT INTO employees VALUES(1,1,'LUCAS','FERRIS','1984-04-17','01.00','G');
INSERT INTO employees VALUES(2,1,'STAFFORD','KIPP','1953-04-22','02.00','G');
INSERT INTO departments VALUES(1,'Optimizer Research','CHEL',1);
INSERT INTO customers VALUES(1,'customer 1','SMITH',1);
INSERT INTO customers VALUES(2,'customer 2','SMITH',1);
INSERT INTO sales VALUES(1,1,'1.00');
INSERT INTO sales VALUES(2,1,'2.00');
INSERT INTO account_balance VALUES(1,'10.02');
INSERT INTO account_balance VALUES(2,'20.02');

