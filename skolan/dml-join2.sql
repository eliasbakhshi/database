use skolan;

--
-- Join three tables and save it as a view
--
-- Create the view
CREATE OR REPLACE View v_planering AS
SELECT *
FROM kurs AS k
    JOIN kurstillfalle AS kt
        ON k.kod = kt.kurskod
    JOIN larare AS l
        ON l.akronym = kt.kursansvarig;


-- Skolan har ett arbetsmiljöansvar för lärarna och vill se över deras planering och lista de lärare som undervisar i kurser med antalet kurstillfällen de ansvarar för.
-- I rapporten visar du lärarens akronym och namn följt av antalet kurstillfällen som hen är kursanvarig för. Sortera per antal tillfällen och därefter per akronym.
select akronym as Akronym, concat(fornamn, " ", efternamn) as Namn, count(id) as 'Tillfallen' from v_planering GROUP BY akronym ORDER BY Tillfallen DESC, Akronym ;


-- Skolan är orolig för att lärarna börjar närma sig pensionen och behöver “bytas ut”. Skolans ansvariga vill se en rapport över de kurser där den ansvarige läraren är nära pensionen. Skolan begränsar sig till att hantera de tre äldsta lärarna.
-- Förslagsvis så börjar du att ta reda på vilka lärare som har högst ålder, bara för att kontrollera vilka lärare det skulle kunna handla om.
-- Kanske ser ditt resultat ut så här. Du vill bara se de äldsta lärarna. Tänk på att åldern ökar med ett för varje år och facit nedan är skapat för ett par år sedan.
select akronym, fornamn, efternamn, fodd, TIMESTAMPDIFF(YEAR, fodd, CURDATE()) as 'Ålder' from larare GROUP BY akronym ORDER BY Ålder DESC LIMIT 3;


-- Du behöver de tre äldsta lärarna som också undervisar på kurser.
-- Du har deras planering där du ser vilka kurser de är ansvariga för. Du vet hur gamla lärarna är. Slå samman informationen och finn de kurser som har någon av de tre äldsta lärarna som ansvariga.
-- Vi ska först lista ut vilka är de 3 top larare som är äldst och har kurs,
create or replace view v_last_3_larare as select l.akronym, TIMESTAMPDIFF(YEAR, l.fodd, CURDATE()) as 'Ålder'
from
larare as l
join
v_planering as vp
on vp.kursansvarig = l.akronym
GROUP BY akronym
ORDER BY Ålder DESC
LIMIT 3;


-- Now show the result
select
concat(vp.namn, " (", vp.kod, ")") as Kursnamn,
concat(vp.fornamn, " ", vp.efternamn) as "Larare",
TIMESTAMPDIFF(YEAR, vp.fodd, CURDATE()) as 'Ålder'
from v_planering as vp join v_last_3_larare as l on vp.akronym = l.akronym ORDER BY Ålder desc, kursnamn; 
