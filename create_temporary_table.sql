DROP DATABASE IF EXISTS test;
DROP TABLE IF EXISTS rooms;
CREATE TEMPORARY TABLE rooms  select room from listing where room IN(400,210);




