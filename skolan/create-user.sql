DROP USER IF EXISTS 'dbadm'@'localhost';

CREATE USER 'dbadm'@'localhost' IDENTIFIED BY 'P@ssw0rd';

-- Ge användaren fullständiga rättigheter på alla databaser *.*, det blir i princip samma rättigheter som en root-användare som har tillgång till allt.

GRANT ALL PRIVILEGES ON *.* TO 'dbadm'@'localhost' WITH GRANT OPTION;


FLUSH PRIVILEGES;


SHOW GRANTS;


SHOW GRANTS FOR 'dbadm'@'localhost';
