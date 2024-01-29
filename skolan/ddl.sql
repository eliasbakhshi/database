use skolan;


-- source ddl-larare.sql --
DROP TABLE IF EXISTS larare;

CREATE TABLE larare
(
    akronym CHAR(3),
    avdelning CHAR(4),
    fornamn VARCHAR(20),
    efternamn VARCHAR(20),
    kon CHAR(1),
    lon INT,
    fodd DATE,

    PRIMARY KEY (akronym)
);



-- source ddl-alter.sql --
-- Add column to table
ALTER table larare DROP COLUMN IF EXISTS  kompetens;
ALTER TABLE larare ADD COLUMN kompetens INT;
-- Drom column to table
ALTER table larare DROP COLUMN kompetens ;
ALTER TABLE larare ADD COLUMN kompetens INT default 1;



-- source ddl-copy.sql --
--
-- Make copy of table
--
DROP TABLE IF EXISTS larare_pre;
CREATE TABLE larare_pre LIKE larare;
INSERT INTO larare_pre SELECT * FROM larare;

-- Check the content of the tables, for sanity checking
SELECT SUM(lon) AS 'Lönesumma', SUM(kompetens) AS Kompetens FROM larare;
SELECT SUM(lon) AS 'Lönesumma', SUM(kompetens) AS Kompetens FROM larare_pre;


-- source dml-view.sql --
-- View --

-- Skapa en vy “v_larare” som innehåller samtliga kolumner från tabellen Lärare inklusive en ny kolumn med lärarens ålder.
create view v_all_with_age as select *, TIMESTAMPDIFF(YEAR, fodd, CURDATE()) as 'Ålder' from larare;

-- Gör en SELECT-sats mot vyn som beräknar medelåldern på respektive avdelning. Visa avdelningens namn och medelålder sorterad på medelåldern.
select avdelning, avg(TIMESTAMPDIFF(YEAR, fodd, CURDATE())) as 'Snittalder' from v_all_with_age group by avdelning order by Snittalder desc;


-- source dml-join.sql --
-- Visa de lärare som inte har fått en löneökning om minst 3%.
SELECT
    l.akronym,
    l.fornamn,
    l.efternamn,
    p.lon AS 'pre',
    l.lon AS 'nu',
    round(((l.lon - p.lon) / (p.lon / 100)),2) AS 'proc'
FROM
    larare AS l
JOIN
    larare_pre AS p ON l.akronym = p.akronym
WHERE
    ((l.lon - p.lon) / (p.lon / 100)) <= 3;

-- Gör en rapport som visar hur många % respektive lärare fick i löneökning.
SELECT
    l.akronym,
    l.fornamn,
    l.efternamn,
    p.lon AS 'pre',
    l.lon AS 'nu',
    round(((l.lon - p.lon) / (p.lon / 100)),2) AS 'proc'
FROM
    larare AS l
JOIN
    larare_pre AS p ON l.akronym = p.akronym;


DROP view IF EXISTS v_lonerevision;

-- Create the view
CREATE View v_lonerevision AS
SELECT
    l.akronym,
    l.fornamn,
    l.efternamn,
    p.lon AS 'pre',
    l.lon AS 'nu',
    (l.lon - p.lon) AS 'diff',
    round(((l.lon - p.lon) / (p.lon / 100)),2) AS 'proc',
    p.kompetens as 'prekomp',
    l.kompetens as 'nukomp',
    (l.kompetens - p.kompetens) as 'diffkomp',
    CASE WHEN ((l.lon - p.lon) / (p.lon / 100)) > 3 THEN 'ok' ELSE 'nok' END AS 'mini'
FROM
    larare AS l
JOIN
    larare_pre AS p ON l.akronym = p.akronym;


SELECT
 akronym, fornamn, efternamn, pre, nu, diff, proc, mini
 FROM v_lonerevision
 ORDER BY proc DESC ;

SELECT akronym, fornamn, efternamn, prekomp, nukomp, diffkomp
 FROM v_lonerevision
  ORDER BY nukomp DESC, diffkomp DESC;


-- Table for kurs --
DROP TABLE IF EXISTS kurs;
CREATE TABLE kurs (
    kod	CHAR(6) PRIMARY KEY NOT NULL,
    namn	VARCHAR(40),
    poang	FLOAT,
    niva	CHAR(3)
);


-- Table for kurstillfalle --
DROP Table IF EXISTS kurstillfalle;

CREATE TABLE kurstillfalle (
    id	INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    kurskod	CHAR(6) NOT NULL,
    kursansvarig	CHAR(3) NOT NULL,
    lasperiod	INT NOT NULL,

    FOREIGN KEY (kurskod) REFERENCES kurs(kod),
    FOREIGN KEY (kursansvarig) REFERENCES larare(akronym)
);



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

