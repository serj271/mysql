DROP DATABASE IF EXISTS guestbook;
CREATE DATABASE guestbook;
USE guestbook;
SET NAMES utf8;
DROP TABLE IF EXISTS msgs ;
CREATE TABLE msgs(
    id int(11) NOT NULL  auto_increment,
    name varchar(50) NOT NULL default '',
    email varchar(50) NOT NULL default '',
    message TEXT,
    PRIMARY KEY(id)
);
/*CREATE TEMPORARY TABLE rooms  select room from listing where room IN(400,210);*/





