-- Drop the procedures if they already exist
DROP PROCEDURE IF EXISTS displayShelvesProcedure;
DROP PROCEDURE IF EXISTS displayProductsOnShelvesProcedure;
DROP PROCEDURE IF EXISTS addProductProcedure;
DROP PROCEDURE IF EXISTS addProductToShelfProcedure;
DROP PROCEDURE IF EXISTS removeProductFromShelfProcedure;
DROP PROCEDURE IF EXISTS displayLogProcedure;
DROP PROCEDURE IF EXISTS displayProductsProcedure;
DROP PROCEDURE IF EXISTS displayShelfLocationsProcedure;
DROP PROCEDURE IF EXISTS displayInventoryProcedure;
DROP PROCEDURE IF EXISTS filterInventoryProcedure;
DROP PROCEDURE IF EXISTS addProductToInventoryProcedure;
DROP PROCEDURE IF EXISTS removeProductFromInventoryProcedure;
DROP PROCEDURE IF EXISTS addInventoryLogProcedure;
DROP PROCEDURE IF EXISTS show_customer;




-- show specifik customer
DELIMITER //

CREATE PROCEDURE show_customer(IN p_customer_id INT)
BEGIN
    SELECT * FROM Customer WHERE Customer_id = p_customer_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE addInventoryLogProcedure(
    IN p_logId INT,
    IN p_eventInstanceId VARCHAR(36),
    IN p_eventDescription VARCHAR(255),
    IN p_eventDate DATETIME
)
BEGIN
    INSERT INTO Inventory_Log (Log_id, Event_instance_id, Event_description, Event_date)
    VALUES (p_logId, p_eventInstanceId, p_eventDescription, p_eventDate);
END //

DELIMITER ;


-- Create procedure to display shelves
DELIMITER //
CREATE PROCEDURE displayShelvesProcedure()
BEGIN
    SELECT * FROM Warehouse;
END //
DELIMITER ;

-- Create procedure to display products on shelves
DELIMITER //
CREATE PROCEDURE displayProductsOnShelvesProcedure()
BEGIN
    SELECT p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END //
DELIMITER ;

-- Create procedure to add a product
DELIMITER //
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
END //
DELIMITER ;

-- Create procedure to add a product to a shelf
DELIMITER //
CREATE PROCEDURE addProductToShelfProcedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN stockQuantity INT
)
BEGIN
    INSERT INTO Warehouse (Warehouse_id, Product_id, Shelf_location, Stock_quantity)
    VALUES (1,productId, shelfLocation, stockQuantity);
END //
DELIMITER ;

-- Create procedure to remove products from a shelf
DELIMITER //
CREATE PROCEDURE removeProductFromShelfProcedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - quantity, 0)
    WHERE Product_id = productId AND Shelf_location = shelfLocation;
END //
DELIMITER ;

-- Create procedure to display log
DELIMITER //
CREATE PROCEDURE displayLogProcedure(
    IN logNumber INT
)
BEGIN
    SELECT * FROM Inventory_Log ORDER BY Event_date DESC LIMIT logNumber;
END //
DELIMITER ;

-- Create procedure to display products
DELIMITER //
CREATE PROCEDURE displayProductsProcedure()
BEGIN
    SELECT ProduktID, Product_name FROM Product;
END //
DELIMITER ;

-- Create procedure to display shelf locations
DELIMITER //
CREATE PROCEDURE displayShelfLocationsProcedure()
BEGIN
    SELECT DISTINCT Shelf_location FROM Warehouse;
END //
DELIMITER ;

-- Create procedure to display inventory
DELIMITER //
CREATE PROCEDURE displayInventoryProcedure()
BEGIN
    SELECT p.ProduktID, p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END //
DELIMITER ;

-- Create procedure to filter inventory
DELIMITER //
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
END //
DELIMITER ;

-- Create procedure to add product to inventory
DELIMITER //
CREATE PROCEDURE addProductToInventoryProcedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    INSERT INTO Warehouse (Warehouse_id, Product_id, Shelf_location, Stock_quantity)
    VALUES (1, productId, shelf, quantity)
    ON DUPLICATE KEY UPDATE Stock_quantity = Stock_quantity + quantity;
END //
DELIMITER ;

-- Create procedure to remove product from inventory
DELIMITER //
CREATE PROCEDURE removeProductFromInventoryProcedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - quantity, 0)
    WHERE Product_id = productId AND Shelf_location = shelf;
END //
DELIMITER ;

-- Create procedure to close connection



-- Drop existing procedures if they exist
DROP PROCEDURE IF EXISTS displayShelvesProcedure;
DROP PROCEDURE IF EXISTS displayProductsOnShelvesProcedure;
DROP PROCEDURE IF EXISTS addProductProcedure;
DROP PROCEDURE IF EXISTS addProductToShelfProcedure;
DROP PROCEDURE IF EXISTS removeProductFromShelfProcedure;
DROP PROCEDURE IF EXISTS displayLogProcedure;
DROP PROCEDURE IF EXISTS displayProductsProcedure;
DROP PROCEDURE IF EXISTS displayShelfLocationsProcedure;
DROP PROCEDURE IF EXISTS displayInventoryProcedure;
DROP PROCEDURE IF EXISTS filterInventoryProcedure;
DROP PROCEDURE IF EXISTS addProductToInventoryProcedure;
DROP PROCEDURE IF EXISTS removeProductFromInventoryProcedure;
DROP PROCEDURE IF EXISTS addInventoryLogProcedure;


-- Modify the addInventoryLogProcedure to generate Event_instance_id
DELIMITER //
CREATE PROCEDURE addInventoryLogProcedure(
    IN p_Log_id INT,
    IN p_Event_description TEXT,
    IN p_Event_date DATETIME
)
BEGIN
    -- Declare a variable to hold the generated Event_instance_id
    DECLARE event_instance_id INT;

    -- Find the maximum Event_instance_id for the given Log_id
    SELECT COALESCE(MAX(Event_instance_id), 0) + 1 INTO event_instance_id
    FROM Inventory_Log
    WHERE Log_id = p_Log_id;

    -- Insert the new record
    INSERT INTO Inventory_Log (Log_id, Event_instance_id, Event_description, Event_date)
    VALUES (p_Log_id, event_instance_id, p_Event_description, p_Event_date);
END //
DELIMITER ;

-- Create procedure to display shelves
DELIMITER //
CREATE PROCEDURE displayShelvesProcedure()
BEGIN
    SELECT * FROM Warehouse;
END //
DELIMITER ;

-- Create procedure to display products on shelves
DELIMITER //
CREATE PROCEDURE displayProductsOnShelvesProcedure()
BEGIN
    SELECT p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END //
DELIMITER ;

-- Create procedure to add a product
DELIMITER //
CREATE PROCEDURE addProductProcedure(
    IN pProductId INT,
    IN pDescription VARCHAR(255),
    IN pProductName VARCHAR(255),
    IN pPrice DECIMAL(10, 2),
    IN pStockQuantity INT
)
BEGIN
    INSERT INTO Product (ProduktID, Description, Product_name, Price, Stock)
    VALUES (pProductId, pDescription, pProductName, pPrice, pStockQuantity);
END //
DELIMITER ;

-- Create procedure to add a product to a shelf
DELIMITER //
CREATE PROCEDURE addProductToShelfProcedure(
    IN pProductId INT,
    IN pShelfLocation VARCHAR(255),
    IN pStockQuantity INT
)
BEGIN
    INSERT INTO Warehouse (Product_id, Shelf_location, Stock_quantity)
    VALUES (pProductId, pShelfLocation, pStockQuantity);
END //
DELIMITER ;

-- Create procedure to remove products from a shelf
DELIMITER //
CREATE PROCEDURE removeProductFromShelfProcedure(
    IN pProductId INT,
    IN pShelfLocation VARCHAR(255),
    IN pQuantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - pQuantity, 0)
    WHERE Product_id = pProductId AND Shelf_location = pShelfLocation;
END //
DELIMITER ;

-- Create procedure to display log
DELIMITER //
CREATE PROCEDURE displayLogProcedure(
    IN pLogNumber INT
)
BEGIN
    SELECT * FROM Inventory_Log ORDER BY Event_date DESC LIMIT pLogNumber;
END //
DELIMITER ;

-- Create procedure to display products
DELIMITER //
CREATE PROCEDURE displayProductsProcedure()
BEGIN
    SELECT ProduktID, Product_name FROM Product;
END //
DELIMITER ;

-- Create procedure to display shelf locations
DELIMITER //
CREATE PROCEDURE displayShelfLocationsProcedure()
BEGIN
    SELECT DISTINCT Shelf_location FROM Warehouse;
END //
DELIMITER ;

-- Create procedure to display inventory
DELIMITER //
CREATE PROCEDURE displayInventoryProcedure()
BEGIN
    SELECT p.ProduktID, p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id;
END //
DELIMITER ;

-- Create procedure to filter inventory
DELIMITER //
CREATE PROCEDURE filterInventoryProcedure(
    IN pFilterString VARCHAR(255)
)
BEGIN
    SELECT p.ProduktID, p.Product_name, w.Shelf_location, w.Stock_quantity
    FROM Product p
    JOIN Warehouse w ON p.ProduktID = w.Product_id
    WHERE p.ProduktID LIKE CONCAT('%', pFilterString, '%')
    OR p.Product_name LIKE CONCAT('%', pFilterString, '%')
    OR w.Shelf_location LIKE CONCAT('%', pFilterString, '%');
END //
DELIMITER ;

-- Create procedure to add product to inventory
DELIMITER //
CREATE PROCEDURE addProductToInventoryProcedure(
    IN pProductId INT,
    IN pShelf VARCHAR(255),
    IN pQuantity INT
)
BEGIN
    INSERT INTO Warehouse (Product_id, Shelf_location, Stock_quantity)
    VALUES (pProductId, pShelf, pQuantity)
    ON DUPLICATE KEY UPDATE Stock_quantity = Stock_quantity + pQuantity;
END //
DELIMITER ;

-- Create procedure to remove product from inventory
DELIMITER //
CREATE PROCEDURE removeProductFromInventoryProcedure(
    IN pProductId INT,
    IN pShelf VARCHAR(255),
    IN pQuantity INT
)
BEGIN
    UPDATE Warehouse
    SET Stock_quantity = GREATEST(Stock_quantity - pQuantity, 0)
    WHERE Product_id = pProductId AND Shelf_location = pShelf;
END //
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
