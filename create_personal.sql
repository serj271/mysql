DROP DATABASE IF EXISTS personal_utf8;
CREATE DATABASE personal_utf8 default character set utf8 COLLATE utf8_general_ci;
USE personal_utf8;

DROP TABLE IF EXISTS `complement`;
CREATE TABLE `complement` (
  `ComplementID` int(10) NOT NULL AUTO_INCREMENT,
  `Posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Complement` varchar(132) DEFAULT NULL,
  `UserID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ComplementID`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `currId`;
/*!50001 DROP VIEW IF EXISTS `currId`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `currId` (
  `count(id)` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

DROP TABLE IF EXISTS `extdepartment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `extdepartment` (
  `ExtDepartment` varchar(256) DEFAULT NULL,
  `Department` varchar(256) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `listing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `listing` (
  `id` char(7) NOT NULL DEFAULT '' COMMENT 'Tab number',
  `room` char(6) DEFAULT NULL,
  `enterprise` varchar(256) DEFAULT NULL,
  `department` varchar(256) DEFAULT NULL,
  `office` varchar(256) DEFAULT NULL,
  `party` varchar(128) DEFAULT NULL,
  `position` varchar(128) DEFAULT NULL,
  `first_name` varchar(32) DEFAULT NULL,
  `name_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  `phone` char(24) DEFAULT NULL,
  `phone1` char(24) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `email_zimbra` varchar(256) DEFAULT NULL,
  `login` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `ip_number` char(16) DEFAULT NULL,
  `prim` varchar(256) DEFAULT NULL,
  `status` enum('Y','N') NOT NULL DEFAULT 'Y',
  `auth` enum('Y','N') NOT NULL DEFAULT 'N',
  `ind` int(10) NOT NULL DEFAULT '4',
  `gender` enum('Male','Female') NOT NULL DEFAULT 'Male',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ixFirts_name` (`first_name`),
  KEY `xroom` (`room`),
  KEY `xfirst_name` (`first_name`),
  FULLTEXT KEY `department` (`department`),
  FULLTEXT KEY `ixFulltext` (`first_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT 'Employees';
/*!40101 SET character_set_client = @saved_cs_client */;



DROP TABLE IF EXISTS `mrsklisting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=MyISAM AUTO_INCREMENT=3325 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `session_id` varchar(24) NOT NULL,
  `last_active` int(11) unsigned NOT NULL,
  `contents` text NOT NULL,
  PRIMARY KEY (`session_id`),
  KEY `last_active` (`last_active`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_tokens`
--

DROP TABLE IF EXISTS `user_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(40) NOT NULL,
  `type` varchar(100) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iniq_token` (`token`),
  KEY `fk_user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(127) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` int(10) unsigned DEFAULT NULL,
  `one_password` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;






