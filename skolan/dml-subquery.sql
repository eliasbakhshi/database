use skolan;

-- Visa detaljer om den lärare som är äldst. Ta fram max ålder med en subquery och använd dess resultat i WHERE-satsen.

SELECT
    akronym,
    fornamn,
    efternamn,
    TIMESTAMPDIFF(YEAR, fodd, CURDATE()) as 'alder'
FROM larare
WHERE
    TIMESTAMPDIFF(YEAR, fodd, CURDATE()) = (
    select
		max(TIMESTAMPDIFF(YEAR, fodd, CURDATE())) as 'alder'
	FROM larare
    );
