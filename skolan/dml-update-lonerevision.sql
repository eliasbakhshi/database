USE skolan;

-- Skriv en SELECT-sats som räknar ut hur mycket pengar som ligger i lönepotten och skall fördelas ut.
SELECT
	sum(lon) as "Lonesumma",
    round(sum(lon) * 0.064) as "Lonepott"
FROM larare;


-- Albus kompetens är nu 7 och lönen har ökat till 85 000.
UPDATE larare SET kompetens = 7 , lon = 85000 where fornamn = "Albus";
-- Minervas lön har ökat med 4 000.
UPDATE larare l set l.lon = l.lon + 400 where l.fornamn = "Minervas";
-- Argus har fått ett risktillägg om 2 000 och kompetensen är satt till 3.
UPDATE larare l set l.lon = l.lon + 2000, l.kompetens = 3 where l.fornamn = "Argus";

-- Gyllenroy och Alastor har hög frånvaro och har fått ett löneavdrag med 3 000.
UPDATE larare l set l.lon = l.lon - 3000 where l.fornamn in("Gyllenroy","Alastor");

-- Alla lärare på avdelningen DIDD fick en extra lönebonus om 2%.
UPDATE larare l set l.lon = round(l.lon * 1.02) where l.avdelning = "DIDD";

-- Alla låglönade kvinnliga lärare, de som tjänar färre än 40 000, fick en lönejustering om extra 3%.
UPDATE larare l set l.lon = round(l.lon * 1.03) where l.lon < 40000 and l.kon = "K";

-- Ge Severus, Minerva och Hagrid ett extra lönetillägg om 5 000 för extra arbete de utför åt Albus och öka deras kompetens med +1.
UPDATE larare l set l.lon = l.lon + 5000, l.kompetens = l.kompetens + 1 where l.fornamn in ("Severus", "Minerva", "Hagrid");

-- Ge alla lärare en ökning om 2.2% men exkludera Albus, Severus, Minerva och Hagrid som redan fått tillräckligt.
UPDATE larare l set l.lon = round(l.lon * 1.022) where l.fornamn not in ("Albus", "Severus", "Minerva", "Hagrid");
