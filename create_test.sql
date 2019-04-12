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
CREATE TABLE employees(
    employee_id int(11) NOT NULL,
    department_id int(11) not NULL,
    surname VARCHAR(32),
    firstname VARCHAR(32),
    status VARCHAR(32)
);
CREATE TABLE customers(
    customer_id int(11) NOT NULL,
    customer_name VARCHAR(32),
	contact_surname VARCHAR(32),
	sales_rep_id int(11)
);

CREATE TABLE sales(
	id int(11),
    customer_id int(11) NOT NULL,
	sale_value decimal(10,2) unsigned DEFAULT '0.00'
);

CREATE TABLE departments(
	department_id int(11),
    department_name varchar(32) NOT NULL
);

DROP PROCEDURE IF EXISTS test.customers_for_rep;
delimiter //

CREATE DEFINER=`user_db`@`localhost` PROCEDURE customers_for_rep(in_sales_rep_id INT)
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
					WHERE employee_id=in_emp_id);
		SELECT COUNT(*)
			INTO out_customer_count
			FROM customers
			WHERE sales_rep_id=in_emp_id;
		IF out_customer_count=0 THEN
			SELECT 'Employee is not a current sales rep';
				ELSE
			SELECT customer_name,customer_status
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

INSERT INTO t1 VALUES('a',2);
INSERT INTO t2 VALUES(3);
INSERT INTO departments VALUES(1,'department name');
INSERT INTO employees VALUES(1,1,'Djohn','d','G');
INSERT INTO employees VALUES(1,1,'Yi','y','G');
INSERT INTO customers VALUES(1,'customer 1','SMITH',1);
INSERT INTO customers VALUES(2,'customer 2','SMITH',1);
INSERT INTO sales VALUES(1,1,'1.00');
INSERT INTO sales VALUES(2,1,'2.00');


