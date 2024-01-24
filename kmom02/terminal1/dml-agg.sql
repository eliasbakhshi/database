use skolan;

SELECT SUM(lon) FROM larare;

SELECT AVG(kompetens) FROM larare;

SELECT
    avdelning,
    AVG(kompetens)
FROM larare
GROUP BY avdelning
;

SELECT avdelning, kompetens, SUM(lon) as Summa
FROM larare
GROUP BY avdelning, kompetens
ORDER BY Summa DESC
;


-- MIN och MAX --

-- Hur mycket är den högsta lönen som en lärare har?
SELECT MAX(lon) from larare;

-- Hur mycket är den lägsta lönen som en lärare har?
SELECT MIN(lon) from larare;



-- Om GROUP BY --

-- Hur många lärare jobbar på de respektive avdelning?
select count(*) as 'amount', avdelning from larare GROUP BY avdelning;

-- Hur mycket betalar respektive avdelning ut i lön varje månad?
select sum(lon) as 'Samtliga lön', avdelning from larare GROUP BY avdelning;

-- Hur mycket är medellönen för de olika avdelningarna?
select avg(lon) as 'medellönen', avdelning from larare GROUP BY avdelning;

-- Hur mycket är medellönen för kvinnor kontra män?
select avg(lon) as 'medellönen', kon from larare GROUP BY kon;

-- Visa snittet på kompetensen för alla avdelningar, sortera på kompetens i sjunkande ordning och visa enbart den avdelning som har högst kompetens.
select avg(kompetens) 'Kompotens', avdelning from larare GROUP BY avdelning ORDER BY Kompotens DESC LIMIT 1;

-- Visa den avrundade snittlönen (ROUND()) grupperad per avdelning och per kompetens, sortera enligt avdelning och snittlön. Visa även hur många som matchar i respektive gruppering. Ditt svar skall se ut så här.
SELECT avdelning, kompetens,ROUND(avg(lon)) as 'Snittlon', count(*) as 'Antal' from larare GROUP BY kompetens, avdelning ORDER BY avdelning, Snittlon;


-- Having --

-- Visa per avdelning hur många anställda det finns, gruppens snittlön, sortera per avdelning och snittlön.
select avdelning, round(avg(lon)) as 'Snittlon', count(fornamn) as 'Antal' from larare GROUP BY avdelning order by avdelning, Snittlon;

-- Visa samma sak som i 1), men visa nu även de kompetenser som finns. Du behöver gruppera på avdelning och per kompetens, sortera per avdelning och per kompetens.
select avdelning, kompetens, round(avg(lon)) as 'Snittlon', count(fornamn) as 'Antal' from larare GROUP BY avdelning, kompetens order by avdelning, kompetens DESC;

-- Visa samma sak som i 2), men ignorera de kompetenser som är större än 3.
select avdelning, kompetens, round(avg(lon)) as 'Snittlon', count(fornamn) as 'Antal' from larare GROUP BY avdelning, kompetens HAVING kompetens <= 3 order by avdelning, kompetens DESC;

-- Visa samma sak som i 3), men exkludera de grupper som har fler än 1 deltagare och inkludera de som har snittlön mellan 30 000 - 45 000. Sortera per snittlön.
select avdelning, kompetens, round(avg(lon)) as 'Snittlon', count(fornamn) as 'Antal' from larare where GROUP BY avdelning, kompetens HAVING Antal <= 1 and Snittlon >= 30000 and Snittlon <= 45000 order by Snittlon DESC;

