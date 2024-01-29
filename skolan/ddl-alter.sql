USE skolan;

-- Drom column to table
ALTER table larare DROP COLUMN kompetens ;
-- Add column to table
ALTER TABLE larare ADD COLUMN kompetens INT default 1;
