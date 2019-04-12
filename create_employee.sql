DROP TABLE  IF EXISTS `employee_departments`;
DROP TABLE  IF EXISTS `employee_enterprises`;
DROP TABLE  IF EXISTS `employees`;

CREATE TABLE IF NOT EXISTS `employee_enterprises`
(
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`title` varchar(512),
	`uri` varchar(128),
    PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;


CREATE TABLE IF NOT EXISTS `employee_departments`
(
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`title` varchar(512),
	`uri` varchar(128),
    `enterprise_id` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id`),
    INDEX `par_ind` (`enterprise_id`),
    FOREIGN KEY (`enterprise_id`) REFERENCES  `employee_enterprises` (`id`) ON DELETE CASCADE    

) ENGINE=INNODB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;


CREATE TABLE IF NOT EXISTS `employees` (
  `id` char(7) NOT NULL DEFAULT '' COMMENT 'Tab number',
  `room` char(6) NOT NULL DEFAULT '',
  `enterprise_id` char(10) NOT NULL,
  `department_id` char(10) NOT NULL,
  `office` varchar(256) NOT NULL DEFAULT '',
  `party` varchar(256) NOT NULL DEFAULT '',
  `position` varchar(256) NOT NULL DEFAULT '',
  `first_name` varchar(32) NOT NULL,
  `name_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `phone` char(24) NOT NULL DEFAULT '',
  `phone1` char(24) NOT NULL DEFAULT '',
  `email_zimbra` varchar(256) NOT NULL,
  `status` enum('Y','N') NOT NULL DEFAULT 'Y',
  `ind` int(10) NOT NULL DEFAULT '4',
  `gender` enum('Male','Female') NOT NULL DEFAULT 'Male',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cat` char(5) NOT NULL DEFAULT '',
  `email` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ixFirts_name` (`first_name`),
  KEY `xroom` (`room`),
  KEY `xfirst_name` (`first_name`),
  FULLTEXT KEY `ixFulltext` (`first_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Employees';
