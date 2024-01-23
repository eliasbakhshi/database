USE skolan;

-- Where part --

-- Visa alla rader i tabellen där avdelningen är DIDD.
SELECT * FROM larare where avdelning = "DIDD";

-- Visa de rader som har en akronym som börjar med bokstaven ‘h’ (ledtråd LIKE).
select * from larare where akronym like 'h%';

-- Visa de rader vars lärares förnamn innehåller bokstaven ‘o’.
select * from larare where fornamn like '%o%';

-- Visa de rader där lärarna tjänar mellan 30 000 - 50 000.
select * from larare where lon >= 30000 and lon <= 50000;

-- Visa de rader där lärarens kompetens är mindre än 7 och lönen är större än 40 000.
select * from larare where kompetens < 7 and lon > 40000;

-- Visa rader som innehåller lärarna sna, dum, min (ledtråd IN).
select * from larare where akronym in ('sna', 'dum', 'min');

-- Visa de lärare som har lön över 80 000, tillsammans med de lärare som har en kompetens om 2 och jobbar på avdelningen ADM.
(select * from larare where lon > 80000)union (select * from larare where kompetens = 2 and avdelning = 'ADM');



-- Order part --

-- Skriv endast ut namnen på alla lärare och vad de tjänar.
select fornamn, lon from larare;

-- Sortera listan på efternamnet, både i stigande och sjunkande ordning.
-- Stigande
select efternamn from larare order by efternamn desc;
-- sjunkande
select efternamn from larare order by efternamn asc;

-- Sortera listan på lönen, både i stigande och sjunkande ordning. Vem tjänar mest och vem tjänar minst?
-- Stigande
select lon from larare order by lon desc;
-- sjunkande
select lon from larare order by lon asc;

-- Välj ut de tre som tjänar mest och visa dem (ledtråd LIMIT).
select lon from larare order by lon desc limit 3;
