--
-- Create procedure for getting all producers.
--
DROP PROCEDURE IF EXISTS get_categories;
DELIMITER ;;
CREATE PROCEDURE get_categories()
BEGIN
    SELECT * FROM category;
END;;
DELIMITER ;

--
-- Create procedure for getting all producers.
--
DROP PROCEDURE IF EXISTS get_products;
DELIMITER ;;
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM product;
END;;
DELIMITER ;

--
-- Create procedure for getting a product.
--
DROP PROCEDURE IF EXISTS get_product;
DELIMITER ;;
CREATE PROCEDURE get_product(
    IN id INT
)
BEGIN
    SELECT * FROM product WHERE product_id = id;
END;;
DELIMITER ;

--
-- Create procedure for getting a product.
--
DROP PROCEDURE IF EXISTS edit_product;
DELIMITER ;;
CREATE PROCEDURE edit_product(
    IN id INT,
    IN name VARCHAR(100),
    IN description TEXT,
    IN price DECIMAL(10,2),
    IN stock INT
)
BEGIN
    UPDATE product SET product_name = name, description = description, price = price, stock = stock WHERE product_id = id;
END;;
DELIMITER ;

--
-- Create procedure for deleting a product.
--
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER ;;
CREATE PROCEDURE delete_product(
    IN id INT
)
BEGIN
    DELETE FROM product WHERE product_id = id;
END;;
DELIMITER ;

--
-- Create procedure for creating a product.
--
DROP PROCEDURE IF EXISTS create_product;
DELIMITER ;;
CREATE PROCEDURE create_product(
    IN name VARCHAR(100),
    IN description TEXT,
    IN price DECIMAL(10,2),
    IN stock INT
)
BEGIN
    INSERT INTO product (product_name, description, price, stock) VALUES (name, description, price, stock);
END;;
DELIMITER ;




/* --- Triggers --- */


--
-- Create a Trigger for deleting a product and rows that product is connected to.
--
DROP TRIGGER IF EXISTS delete_product_trigger;
DELIMITER ;;
CREATE TRIGGER delete_product_trigger
BEFORE DELETE ON product
FOR EACH ROW
BEGIN
    DELETE FROM product_category WHERE product_id = OLD.product_id;
    DELETE FROM order_item WHERE product_id = OLD.product_id;
    DELETE FROM warehouse WHERE product_id = OLD.product_id;
END;;
DELIMITER ;



