DROP VIEW IF EXISTS currId;
CREATE VIEW currId AS SELECT count(id) FROM listing;




