--
-- Create a Trigger for deleting a product and rows that product is connected to.
--
use  eshop;

DROP TRIGGER IF EXISTS delete_product_trigger;
DELIMITER ;;
CREATE TRIGGER delete_product_trigger
BEFORE DELETE ON product
FOR EACH ROW
BEGIN
    UPDATE product_category SET deleted = NOW() WHERE product_id = OLD.product_id;
    UPDATE order_item SET deleted = NOW() WHERE product_id = OLD.product_id;
    UPDATE warehouse SET deleted = NOW() WHERE product_id = OLD.product_id;
END;;
DELIMITER ;

-- --
-- -- Create a Trigger for before updating a category and rows that category is connected to.
-- --
-- DROP TRIGGER IF EXISTS before_update_category_trigger;
-- DELIMITER ;;
-- CREATE TRIGGER before_update_category_trigger
-- BEFORE UPDATE ON category
-- FOR EACH ROW
-- BEGIN
-- SET GLOBAL FOREIGN_KEY_CHECKS=0;
-- END;;
-- DELIMITER ;

-- --
-- -- Create a Trigger for after updating a category and rows that category is connected to.
-- --
-- DROP TRIGGER IF EXISTS after_update_category_trigger;
-- DELIMITER ;;
-- CREATE TRIGGER after_update_category_trigger
-- BEFORE UPDATE ON category
-- FOR EACH ROW
-- BEGIN
-- SET GLOBAL FOREIGN_KEY_CHECKS=1;
-- END;;
-- DELIMITER ;
