use skolan;


-- Kan vi då göra samma sak för kurser och visa vilka kurser som inte har kurstillfällen?
-- Gör på egen hand som i föregående exempel och visa enbart de kurser som inte har kurstillfällen.

--
-- Outer join, inkludera lärare utan undervisning
--
SELECT DISTINCT
    kt.kurskod AS Kurskod,
    k.namn AS Kursnamn,
    kt.lasperiod AS Läsperiod
FROM kurstillfalle AS kt
    RIGHT OUTER JOIN kurs AS k
        ON k.kod = kt.kurskod
        where kt.lasperiod IS NULL;



