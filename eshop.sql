DROP DATABASE IF EXISTS eshop;
CREATE DATABASE eshop;
USE eshop;
SET NAMES utf8;
DROP TABLE IF EXISTS msgs ;
CREATE TABLE catalog(
    id INT(11) NOT NULL  auto_increment,
    author VARCHAR(50) NOT NULL default '',
    title VARCHAR(50) NOT NULL default '',
    pubyear INT,
    price INT(10),
    PRIMARY KEY(id)
);
CREATE TABLE orders(
    id INT(11) NOT NULL,
    author VARCHAR(50) NOT NULL default '',
    title VARCHAR(50) NOT NULL default '',
    pubyear INT,
    price INT(10),
    customer VARCHAR(50),
    quantity INT(10),
    datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);
CREATE TABLE basket(
    id INT(11) NOT NULL AUTO_INCREMENT,
    goodsid INT(11) NOT NULL,
    customer VARCHAR(50),
    quantity INT(10),
    datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);

INSERT INTO catalog (author, title, pubyear, price) 
    VALUES ('John', 'Our home', '2010',55),
    ('Oyly', 'Then word', '2012',100);

GRANT select, update, insert, delete ON eshop.* TO 'serj'@'localhost';

