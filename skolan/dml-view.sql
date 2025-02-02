-- View --

-- Skapa en vy “v_larare” som innehåller samtliga kolumner från tabellen Lärare inklusive en ny kolumn med lärarens ålder.
create view v_all_with_age as select *, TIMESTAMPDIFF(YEAR, fodd, CURDATE()) as 'Ålder' from larare;

-- Gör en SELECT-sats mot vyn som beräknar medelåldern på respektive avdelning. Visa avdelningens namn och medelålder sorterad på medelåldern.
select avdelning, avg(TIMESTAMPDIFF(YEAR, fodd, CURDATE())) as 'Snittalder' from v_all_with_age group by avdelning order by Snittalder desc;
