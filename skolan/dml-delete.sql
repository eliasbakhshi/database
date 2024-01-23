USE skolan;

-- Delete Hagrid (1 row).
DELETE FROM larare WHERE fornamn = 'Hagrid';
-- Delete everyone who works in the DIPT department (3 rows).
DELETE FROM larare WHERE avdelning = 'DIPT';
-- Delete everyone who has a salary, but limit the number of rows that can be deleted to 2 (LIMIT) (2 "random" rows are affected).
DELETE FROM larare WHERE lon > 0 limit 2;
-- Delete all remaining teachers.
DELETE FROM larare;
