DROP TABLE  IF EXISTS table6_child;
DROP TABLE  IF EXISTS table5;

CREATE TABLE table5
(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Cod goods',
    code CHAR(4) NOT NULL DEFAULT 'AAAA',
    name VARCHAR(50) NOT NULL DEFAULT '' COMMENT 'Name of goods',
    price FLOAT NOT NULL DEFAULT 0 COMMENT 'Price of goods',
    CONSTRAINT pkId PRIMARY KEY (id),
    CONSTRAINT ixCode UNIQUE KEY (code),
    INDEX ixName (name),
    INDEX ixPrice (price)
) COMMENT 'Table of goods with keys and indexes';

CREATE TABLE table6_child
(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Code of recording',
    code CHAR(4) NOT NULL DEFAULT 'AAAA' COMMENT 'Code of goods',
    quo FLOAT NOT NULL DEFAULT 0 COMMENT 'Income and expenditure of goods',
    CONSTRAINT pkId PRIMARY KEY (id),
    INDEX isCode (code),
    CONSTRAINT fkTable5Code FOREIGN KEY (code)
	REFERENCES table5 (code)
);

/* Add goods */
INSERT INTO table5 (code, name, price) VALUES ('ZZZZ','Mega test',17.8),
						('DDDD','Super',23.3);

UPDATE table5
    SET
	name = CONCAT(name, ' *'),
	price = price * 1.5
    WHERE price > 20;


/* Income goods */
INSERT INTO  table6_child (code, quo) VALUES ('ZZZZ',10);




