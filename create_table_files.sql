DROP TABLE  IF EXISTS files;

CREATE TABLE files
(
    id INT(11) NOT NULL AUTO_INCREMENT COMMENT 'File number',
    file text NOT NULL,
    type VARCHAR(4) NOT NULL,
    size bigint(20) UNSIGNED NOT NULL,
    description text,
    PRIMARY KEY (id)
) COMMENT 'Files for uploads';





