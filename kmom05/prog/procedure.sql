--
-- Procedure move_money()
--

use skolan;

DROP PROCEDURE IF EXISTS move_money;

DELIMITER ;;

CREATE PROCEDURE move_money(
    from_account CHAR(4),
    to_account CHAR(4),
    amount NUMERIC(4, 2)
)

BEGIN

    DECLARE current_balance NUMERIC(4, 2);

    START TRANSACTION;

    SET current_balance = (SELECT balance FROM account WHERE id = from_account);
    SELECT current_balance;


    IF current_balance - amount < 0 THEN
            ROLLBACK;
        SELECT 'Amount on the account is not enough to make transaction.' AS message;
    ELSE
        UPDATE account
            SET
                balance = balance + amount
            WHERE
                id = to_account;

        UPDATE account
            SET
                balance = balance - amount
            WHERE
                id = from_account;

        COMMIT;
    END IF;

    SELECT * FROM account;
END;;

DELIMITER ;




DELIMITER ;;
DROP PROCEDURE IF EXISTS get_money;
CREATE PROCEDURE get_money(
    IN account CHAR(4),
    OUT total NUMERIC(4, 2)
)
BEGIN
    SELECT balance INTO total FROM account WHERE id = account;
END;;

DELIMITER ;






/* --- Triggers --- */

--
-- Log table
--
DROP TABLE IF EXISTS account_log;
CREATE TABLE account_log
(
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `when` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `what` VARCHAR(20),
    `account` CHAR(4),
    `balance` DECIMAL(4, 2),
    `amount` DECIMAL(4, 2)
);




--
-- Trigger for logging updating balance
--
DROP TRIGGER IF EXISTS log_balance_update;

CREATE TRIGGER log_balance_update
AFTER UPDATE
ON account FOR EACH ROW
    INSERT INTO account_log (`what`, `account`, `balance`, `amount`)
        VALUES ('updated', NEW.id, NEW.balance, NEW.balance - OLD.balance);




SELECT * FROM account_log;



-- --
-- -- Trigger with compound statement and user defined errors
-- --
-- DROP TRIGGER IF EXISTS trigger_test2;

-- DELIMITER ;;

-- CREATE TRIGGER trigger_test2
-- BEFORE UPDATE
-- ON account FOR EACH ROW
-- BEGIN
--     SIGNAL SQLSTATE '45000' SET message_text = 'My Error Message';
-- END
-- ;;

-- DELIMITER ;


-- UPDATE account SET balance = 10.0;
