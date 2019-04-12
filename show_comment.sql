SELECT table_name, table_comment 
    FROM information_schema.tables
    WHERE table_schema = 'personal_utf8';
    
SELECT column_name, data_type, column_comment 
    FROM information_schema.columns
    WHERE table_schema = 'personal_utf8'
    AND table_name = 'listing';

SELECT *
    FROM information_schema.schemata \G

