DROP PROCEDURE IF EXISTS displayShelvesProcedure;
DELIMITER ;;
CREATE PROCEDURE displayShelvesProcedure()
BEGIN
    SELECT * FROM Warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayProductsOnShelvesProcedure;
DELIMITER ;;
CREATE PROCEDURE displayProductsOnShelvesProcedure()
BEGIN
    SELECT p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addProductProcedure;
DELIMITER ;;
CREATE PROCEDURE addProductProcedure(
    IN productId INT,
    IN description VARCHAR(255),
    IN productName VARCHAR(255),
    IN price DECIMAL(10, 2),
    IN stockQuantity INT
)
BEGIN
    INSERT INTO Product (ProduktID, Description, Product_name, Price, Stock)
    VALUES (productId, description, productName, price, stockQuantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addProductToShelfProcedure;
DELIMITER ;;
CREATE PROCEDURE addProductToShelfProcedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN stockQuantity INT
)
BEGIN
    INSERT INTO Warehouse (Warehouse_id, Product_id, Shelf_location, Stock_quantity)
    VALUES (1,productId, shelfLocation, stockQuantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS removeProductFromShelfProcedure;
DELIMITER ;;
CREATE PROCEDURE removeProductFromShelfProcedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - quantity, 0)
    WHERE Product_id = productId AND Shelf_location = shelfLocation;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayLogProcedure;
DELIMITER ;;
CREATE PROCEDURE displayLogProcedure(
    IN logNumber INT
)
BEGIN
    SELECT * FROM Inventory_Log ORDER BY Event_date DESC LIMIT logNumber;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayProductsProcedure;
DELIMITER ;;
CREATE PROCEDURE displayProductsProcedure()
BEGIN
    SELECT ProduktID, Product_name FROM Product;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayShelfLocationsProcedure;
DELIMITER ;;
CREATE PROCEDURE displayShelfLocationsProcedure()
BEGIN
    SELECT DISTINCT Shelf_location FROM Warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayInventoryProcedure;
DELIMITER ;;
CREATE PROCEDURE displayInventoryProcedure()
BEGIN
    SELECT p.ProduktID, p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS filterInventoryProcedure;
DELIMITER ;;
CREATE PROCEDURE filterInventoryProcedure(
    IN filterString VARCHAR(255)
)
BEGIN
    SELECT p.ProduktID, p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id
    WHERE p.ProduktID LIKE CONCAT('%', filterString, '%')
    OR p.Product_name LIKE CONCAT('%', filterString, '%')
    OR w.Shelf_location LIKE CONCAT('%', filterString, '%');
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addProductToInventoryProcedure;
DELIMITER ;;
CREATE PROCEDURE addProductToInventoryProcedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    INSERT INTO Warehouse (Warehouse_id, Product_id, Shelf_location, Stock_quantity)
    VALUES (1, productId, shelf, quantity)
    ON DUPLICATE KEY UPDATE Stock_quantity = Stock_quantity + quantity;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS removeProductFromInventoryProcedure;
DELIMITER ;;
CREATE PROCEDURE removeProductFromInventoryProcedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - quantity, 0)
    WHERE Product_id = productId AND Shelf_location = shelf;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addInventoryLogProcedure;
DELIMITER ;;
CREATE PROCEDURE addInventoryLogProcedure(
    IN p_logId INT,
    IN p_eventInstanceId VARCHAR(36),
    IN p_eventDescription VARCHAR(255),
    IN p_eventDate DATETIME
)
BEGIN
    INSERT INTO Inventory_Log (Log_id, Event_instance_id, Event_description, Event_date)
    VALUES (p_logId, p_eventInstanceId, p_eventDescription, p_eventDate);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS show_customer;
DELIMITER ;;
CREATE PROCEDURE show_customer(IN p_customer_id INT)
BEGIN
    SELECT * FROM Customer WHERE Customer_id = p_customer_id;
END;;
DELIMITER ;




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
    SET @productId = LAST_INSERT_ID();
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
