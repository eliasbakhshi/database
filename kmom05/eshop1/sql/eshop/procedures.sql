DROP PROCEDURE IF EXISTS displayshelvesprocedure;
DELIMITER ;;
CREATE PROCEDURE displayshelvesprocedure()
BEGIN
    SELECT * FROM warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayproductsonshelvesprocedure;
DELIMITER ;;
CREATE PROCEDURE displayproductsonshelvesprocedure()
BEGIN
    SELECT p.product_name, w.shelf_location, w.stock_quantity
    FROM product p
    JOIN warehouse w ON p.produktid = w.product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addproductprocedure;
DELIMITER ;;
CREATE PROCEDURE addproductprocedure(
    IN productId INT,
    IN description VARCHAR(255),
    IN productName VARCHAR(255),
    IN price DECIMAL(10, 2),
    IN stockQuantity INT
)
BEGIN
    INSERT INTO product (produktid, description, product_name, price, stock)
    VALUES (productId, description, productName, price, stockQuantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addproducttoshelfprocedure;
DELIMITER ;;
CREATE PROCEDURE addproducttoshelfprocedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN stockQuantity INT
)
BEGIN
    INSERT INTO warehouse (warehouse_id, product_id, shelf_location, stock_quantity)
    VALUES (1,productId, shelfLocation, stockQuantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS removeproductfromshelfprocedure;
DELIMITER ;;
CREATE PROCEDURE removeproductfromshelfprocedure(
    IN productId INT,
    IN shelfLocation VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE warehouse
    SET stock_quantity = GREATEST(stock_quantity - quantity, 0)
    WHERE product_id = productId AND shelf_location = shelfLocation;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displaylogprocedure;
DELIMITER ;;
CREATE PROCEDURE displaylogprocedure(
    IN logNumber INT
)
BEGIN
    SELECT * FROM inventory_log ORDER BY event_date DESC LIMIT logNumber;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayproductsprocedure;
DELIMITER ;;
CREATE PROCEDURE displayproductsprocedure()
BEGIN
    SELECT product_id, product_name FROM product;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayshelflocationsprocedure;
DELIMITER ;;
CREATE PROCEDURE displayshelflocationsprocedure()
BEGIN
    SELECT DISTINCT shelf_location FROM warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS displayinventoryprocedure;
DELIMITER ;;
CREATE PROCEDURE displayinventoryprocedure()
BEGIN
    SELECT p.product_id, p.product_name, w.shelf_location, w.stock_quantity
    FROM product p
    JOIN warehouse w ON p.product_id = w.product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS filterinventoryprocedure;
DELIMITER ;;
CREATE PROCEDURE filterinventoryprocedure(
    IN filterString VARCHAR(255)
)
BEGIN
    SELECT p.product_id, p.product_name, w.shelf_location, w.stock_quantity
    FROM product p
    JOIN warehouse w ON p.product_id = w.product_id
    WHERE p.product_id LIKE CONCAT('%', filterString, '%')
    OR p.product_name LIKE CONCAT('%', filterString, '%')
    OR w.shelf_location LIKE CONCAT('%', filterString, '%');
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addproducttoinventoryprocedure;
DELIMITER ;;
CREATE PROCEDURE addproducttoinventoryprocedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    INSERT INTO warehouse ( product_id, shelf_location, stock_quantity)
    VALUES ( productId, shelf, quantity)
    ON DUPLICATE KEY UPDATE stock_quantity = stock_quantity + quantity;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS removeproductfrominventoryprocedure;
DELIMITER ;;
CREATE PROCEDURE removeproductfrominventoryprocedure(
    IN productId INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE warehouse
    SET stock_quantity = GREATEST(stock_quantity - quantity, 0)
    WHERE product_id = productId AND shelf_location = shelf;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS addinventorylogprocedure;
DELIMITER ;;
CREATE PROCEDURE addinventorylogprocedure(
    IN p_eventInstanceId VARCHAR(36),
    IN p_eventDescription VARCHAR(255),
    IN p_eventDate DATETIME
)
BEGIN
    INSERT INTO inventory_log ( event_instance_id, event_description, event_date)
    VALUES ( p_eventInstanceId, p_eventDescription, p_eventDate);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS show_customer;
DELIMITER ;;
CREATE PROCEDURE show_customer(IN p_customer_id INT)
BEGIN
    SELECT * FROM customer WHERE customer_id = p_customer_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS create_category;
DELIMITER ;;
CREATE PROCEDURE create_category(
    IN the_name VARCHAR(100)
)
BEGIN
    INSERT INTO category (name) VALUES (the_name);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_categories;
DELIMITER ;;
CREATE PROCEDURE get_categories()
BEGIN
    SELECT * FROM category WHERE deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_category;
DELIMITER ;;
CREATE PROCEDURE get_category(
    IN id INT
)
BEGIN
    SELECT * FROM category where category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

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

DROP PROCEDURE IF EXISTS delete_category;
DELIMITER ;;
CREATE PROCEDURE delete_category(
    IN id INT
)
BEGIN
    UPDATE category SET deleted = NOW() WHERE category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

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

DROP PROCEDURE IF EXISTS get_products;
DELIMITER ;;
CREATE PROCEDURE get_products()
BEGIN
    SELECT * FROM product WHERE deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS get_product;
DELIMITER ;;
CREATE PROCEDURE get_product(
    IN id INT
)
BEGIN
    SELECT * FROM product WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;

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

DROP PROCEDURE IF EXISTS delete_product;
DELIMITER ;;
CREATE PROCEDURE delete_product(
    IN id INT
)
BEGIN
    UPDATE product SET deleted = NOW() WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;
