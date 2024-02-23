--
-- Create procedure for creating a category.
--
DROP PROCEDURE IF EXISTS create_category;
DELIMITER ;;
CREATE PROCEDURE create_category(
    IN the_name VARCHAR(100)
)
BEGIN
    INSERT INTO category (name) VALUES (the_name);
END;;
DELIMITER ;

--
-- Create procedure for getting all categories.
--
DROP PROCEDURE IF EXISTS get_categories;
DELIMITER ;;
CREATE PROCEDURE get_categories()
BEGIN
    SELECT * FROM category WHERE deleted IS NULL;
END;;
DELIMITER ;

--
-- Create procedure for getting a category.
--
DROP PROCEDURE IF EXISTS get_category;
DELIMITER ;;
CREATE PROCEDURE get_category(
    IN id INT
)
BEGIN
    SELECT * FROM category where category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

--
-- Create procedure for editing a category.
--
DROP PROCEDURE IF EXISTS edit_category;
DELIMITER ;;
CREATE PROCEDURE edit_category(
    IN id INT,
    IN the_name VARCHAR(100)
)
BEGIN
    UPDATE category SET name = the_name WHERE category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

--
-- Create procedure for deleting a category.
--
DROP PROCEDURE IF EXISTS delete_category;
DELIMITER ;;
CREATE PROCEDURE delete_category(
    IN id INT
)
BEGIN
    UPDATE category SET deleted = NOW() WHERE category_id = id AND deleted IS NULL;
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

--
-- Create procedure for getting all producers.
--
DROP PROCEDURE IF EXISTS get_products;
DELIMITER ;;
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM product WHERE deleted IS NULL;
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
    SELECT * FROM product WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;

--
-- Create procedure for editing a product.
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
    UPDATE product SET product_name = name, description = description, price = price, stock = stock WHERE product_id = id AND deleted IS NULL;
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
    UPDATE product SET deleted = NOW() WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;
