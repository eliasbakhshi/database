--
-- Create procedure for getting all producers.

DROP PROCEDURE IF EXISTS get_categories;
DELIMITER;;
CREATE PROCEDURE get_categories()
BEGIN
    SELECT * FROM category;
END;;
DELIMITER;

--
-- Create procedure for getting all producers.

DROP PROCEDURE IF EXISTS get_products;
DELIMITER;;
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM products;
END;;
DELIMITER;

--
-- Create procedure for getting a product.

DROP PROCEDURE IF EXISTS get_product;
DELIMITER;;
CREATE PROCEDURE get_product(
    IN product_id INT
)
BEGIN
    SELECT * FROM products WHERE id = product_id;
END;;
DELIMITER;

--
-- Create procedure for deleting a product.

DROP PROCEDURE IF EXISTS delete_product;
DELIMITER;;
CREATE PROCEDURE delete_product(
    IN product_id INT
)
BEGIN
    DELETE FROM products WHERE id = product_id;
END;;
DELIMITER;


