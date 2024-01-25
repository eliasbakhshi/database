USE skolan;

-- Add column to table
ALTER table larare DROP COLUMN IF EXISTS  kompetens;
ALTER TABLE larare ADD COLUMN kompetens INT;
-- Drom column to table
ALTER table larare DROP COLUMN kompetens ;
ALTER TABLE larare ADD COLUMN kompetens INT default 1;
