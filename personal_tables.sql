DROP TABLE IF EXISTS `complement`;
CREATE TABLE `complement` (
  `ComplementID` int(10) NOT NULL AUTO_INCREMENT,
  `Posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Complement` varchar(132) DEFAULT NULL,
  `UserID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ComplementID`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `currId`;
CREATE TABLE `currId` (
  `count(id)` tinyint(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdepartment`;
CREATE TABLE `extdepartment` (
  `ExtDepartment` varchar(256) DEFAULT NULL,
  `Department` varchar(256) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `listing`;
CREATE TABLE `listing` (
  `id` char(7) NOT NULL DEFAULT '' COMMENT 'Tab number',
  `room` char(6) NOT NULL,
  `enterprise` varchar(256) NOT NULL,
  `department` varchar(256) NOT NULL,
  `office` varchar(256) NOT NULL,
  `party` varchar(256) NOT NULL,
  `position` varchar(256) NOT NULL,
  `first_name` varchar(32) NOT NULL,
  `name_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `phone` char(24) NOT NULL,
  `phone1` char(24) NOT NULL,
  `email_zimbra` varchar(256) NOT NULL,
  `status` enum('Y','N') NOT NULL DEFAULT 'Y',
  `ind` int(10) NOT NULL DEFAULT '4',
  `gender` enum('Male','Female') NOT NULL DEFAULT 'Male',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cat` char(5) NOT NULL,
  `email` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ixFirts_name` (`first_name`),
  KEY `xroom` (`room`),
  KEY `xfirst_name` (`first_name`),
  FULLTEXT KEY `department` (`department`),
  FULLTEXT KEY `ixFulltext` (`first_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Employees';

DROP TABLE IF EXISTS `mrsklisting`;
CREATE TABLE `mrsklisting` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `enterprise` varchar(128) DEFAULT NULL,
  `department` varchar(128) DEFAULT NULL,
  `office` varchar(128) DEFAULT NULL,
  `position` varchar(128) DEFAULT NULL,
  `first_name` varchar(128) DEFAULT NULL,
  `name_name` varchar(128) DEFAULT NULL,
  `last_name` varchar(128) DEFAULT NULL,
  `phone1` varchar(32) DEFAULT NULL,
  `phone2` varchar(32) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `phone_globals`;
CREATE TABLE `phone_globals` (
  `global` varchar(24) DEFAULT NULL,
  `phone` char(24) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `address` varchar(32) DEFAULT NULL,
  `enterprise` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;

DROP TABLE IF EXISTS `roles_users`;
CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;

DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `session_id` varchar(24) NOT NULL,
  `last_active` int(11) unsigned NOT NULL,
  `contents` text NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `last_active` (`last_active`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `upload`;
CREATE TABLE `upload` (
  `UploadID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` varchar(32) DEFAULT NULL,
  `UploadPath` varchar(255) DEFAULT NULL,
  `UploadDescription` varchar(32) DEFAULT NULL,
  `UploadName` varchar(255) DEFAULT NULL,
  `Posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UploadSize` int(10) DEFAULT NULL,
  PRIMARY KEY (`UploadID`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user_tokens`;
CREATE TABLE `user_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(40) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`),
  KEY `expires` (`expires`),
  CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_listing` char(7) NOT NULL,
  `email` varchar(254) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL,
  `one_password` varchar(64) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` int(10) unsigned DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 STATS_PERSISTENT=0;
