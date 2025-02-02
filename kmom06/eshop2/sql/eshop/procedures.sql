DROP PROCEDURE IF EXISTS p_display_shelves_procedure;
DELIMITER ;;
CREATE PROCEDURE p_display_shelves()
BEGIN
    SELECT * FROM warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_display_products_shelves;
DELIMITER ;;
CREATE PROCEDURE p_display_products_shelves()
BEGIN
    SELECT p.product_name, w.shelf_location, w.stock_quantity
    FROM product p
    JOIN warehouse w ON p.product_id = w.product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_add_product;
DELIMITER ;;
CREATE PROCEDURE p_add_product(
    IN product_id INT,
    IN description VARCHAR(255),
    IN product_name VARCHAR(255),
    IN price DECIMAL(10, 2),
    IN stock_quantity INT
)
BEGIN
    INSERT INTO product (product_id, description, product_name, price, stock)
    VALUES (product_id, description, product_name, price, stock_quantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_add_product_Shelf;
DELIMITER ;;
CREATE PROCEDURE p_add_product_Shelf(
    IN product_id INT,
    IN shelf_location VARCHAR(255),
    IN stock_quantity INT
)
BEGIN
    INSERT INTO warehouse (warehouse_id, product_id, shelf_location, stock_quantity)
    VALUES (1,product_id, shelf_location, stock_quantity);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_remove_product_from_shelf;
DELIMITER ;;
CREATE PROCEDURE p_remove_product_from_shelf(
    IN product_id INT,
    IN shelf_location VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE warehouse
    SET stock_quantity = GREATEST(stock_quantity - quantity, 0)
    WHERE product_id = product_id AND shelf_location = shelf_location;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_display_log_procedure;
delimiter ;;
CREATE PROCEDURE p_display_log_procedure(
    in lognumber int
)
BEGIN
    SELECT * FROM inventory_log ORDER BY event_date DESC LIMIT logNumber;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_display_products;
DELIMITER ;;
CREATE PROCEDURE p_display_products()
BEGIN
    SELECT product_id, product_name FROM product;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_display_shelf_locations;
DELIMITER ;;
CREATE PROCEDURE p_display_shelf_locations()
BEGIN
    SELECT DISTINCT shelf_location FROM warehouse;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_display_inventory;
DELIMITER ;;
CREATE PROCEDURE p_display_inventory()
BEGIN
    SELECT p.product_id, p.product_name, w.shelf_location, w.stock_quantity
    FROM product p
    JOIN warehouse w ON p.product_id = w.product_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_filter_inventory_procedure;
delimiter ;;
CREATE PROCEDURE p_filter_inventory_procedure(
    in filterstring varchar(255)
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

DROP PROCEDURE IF EXISTS p_add_product_to_inventory;
DELIMITER ;;
CREATE PROCEDURE p_add_product_to_inventory(
    IN product_id INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    INSERT INTO warehouse (warehouse_id, product_id, shelf_location, stock_quantity)
    VALUES (1, product_id, shelf, quantity)
    ON DUPLICATE KEY UPDATE stock_quantity = stock_quantity + quantity;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_remove_product_inventory;
DELIMITER ;;
CREATE PROCEDURE p_remove_product_inventory(
    IN product_id INT,
    IN shelf VARCHAR(255),
    IN quantity INT
)
BEGIN
    UPDATE warehouse
    SET stock_quantity = GREATEST(stock_quantity - quantity, 0)
    WHERE product_id = product_id AND shelf_location = shelf;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_add_inventory_log_procedure;
delimiter ;;
CREATE PROCEDURE p_add_inventory_log_procedure(
    in p_eventinstanceid varchar(36),
    in p_eventdescription varchar(255),
    in p_eventdate datetime
)
BEGIN
    INSERT INTO inventory_log ( event_instance_id, event_description, event_date)
    VALUES ( p_eventInstanceId, p_eventDescription, p_eventDate);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_show_customer;
DELIMITER ;;
CREATE PROCEDURE p_show_customer(IN p_customer_id INT)
BEGIN
    SELECT * FROM customer WHERE Customer_id = p_customer_id;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_create_category;
DELIMITER ;;
CREATE PROCEDURE p_create_category(
    IN the_name VARCHAR(100)
)
BEGIN
    INSERT INTO category (name) VALUES (the_name);
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_categories;
DELIMITER ;;
CREATE PROCEDURE p_get_categories()
BEGIN
    SELECT * FROM category WHERE deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_category;
DELIMITER ;;
CREATE PROCEDURE p_get_category(
    IN id INT
)
BEGIN
    SELECT * FROM category where category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_edit_category;
DELIMITER ;;
CREATE PROCEDURE p_edit_category(
    IN id INT,
    IN the_name VARCHAR(100)
)
BEGIN
    UPDATE category SET name = the_name WHERE category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_delete_category;
DELIMITER ;;
CREATE PROCEDURE p_delete_category(
    IN id INT
)
BEGIN
    UPDATE category SET deleted = NOW() WHERE category_id = id AND deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_create_product;
DELIMITER ;;
CREATE PROCEDURE p_create_product(
    IN name VARCHAR(100),
    IN description TEXT,
    IN price DECIMAL(10,2),
    IN stock INT
)
BEGIN
    INSERT INTO product (product_name, description, price, stock) VALUES (name, description, price, stock);
    SET @product_id = LAST_INSERT_ID();
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_products;
DELIMITER ;;
CREATE PROCEDURE p_get_products()
BEGIN
    SELECT * FROM product WHERE deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_product;
DELIMITER ;;
CREATE PROCEDURE p_get_product(
    IN id INT
)
BEGIN
    SELECT * FROM product WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;

DROP PROCEDURE IF EXISTS p_edit_product;
DELIMITER ;;
CREATE PROCEDURE p_edit_product(
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

DROP PROCEDURE IF EXISTS p_delete_product;
DELIMITER ;;
CREATE PROCEDURE p_delete_product(
    IN id INT
)
BEGIN
    UPDATE product SET deleted = NOW() WHERE product_id = id AND deleted IS NULL;
END;;
DELIMITER ;
DELIMITER //

DROP PROCEDURE IF EXISTS p_show_orders_with_totals;
CREATE PROCEDURE p_show_orders_with_totals()
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        o.customer_id,
        o.status,
        COALESCE(SUM(oi.quantity), 0) AS total_products,
        COALESCE(SUM(oi.price * oi.quantity), 0) AS total_combined_price
    FROM
        `order` o
    LEFT JOIN
        `order_item` oi ON o.order_id = oi.order_id
    GROUP BY
        o.order_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS p_show_all_orders;

DELIMITER //

CREATE PROCEDURE p_show_all_orders()
BEGIN
    SELECT * FROM `order`;
END//

DELIMITER ;


DROP PROCEDURE IF EXISTS p_show_all_customers;
DELIMITER //

CREATE PROCEDURE p_show_all_customers()
BEGIN
    SELECT * FROM `customer`;
END//

DELIMITER ;

DROP PROCEDURE IF EXISTS p_show_customer_by_id;
DELIMITER //

CREATE PROCEDURE p_show_customer_by_id(IN p_customer_id INT)
BEGIN
    SELECT * FROM `customer` WHERE `customer_id` = p_customer_id;
END//

DELIMITER ;

DROP PROCEDURE IF EXISTS p_insert_order;

DELIMITER //

CREATE PROCEDURE p_insert_order(
    IN p_order_date DATETIME,
    IN p_total_price DECIMAL(10,2),
    IN p_customer_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO `order` (order_date, total_price, customer_id, status, created, updated)
    VALUES (p_order_date, p_total_price, p_customer_id, p_status, NOW(), NOW());
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS p_show_order_details;
DELIMITER //

CREATE PROCEDURE p_show_order_details(IN p_order_id INT)
BEGIN
    SELECT oi.order_id, oi.product_id, p.product_name,
           oi.quantity AS total_product, oi.price AS total_price
    FROM `order_item` oi
    JOIN `product` p ON oi.product_id = p.product_id
    WHERE oi.order_id = p_order_id;
END //

DELIMITER ;



DROP PROCEDURE IF EXISTS p_change_order_status;
delimiter //
CREATE PROCEDURE p_change_order_status(in orderid int)
begin
    update `order`
    set `status` = 'ordered'
    where `order_id` = orderid;
end //

delimiter ;

DROP PROCEDURE IF EXISTS p_get_order_information;
delimiter //
CREATE PROCEDURE p_get_order_information(in orderid int)
begin
    select * from `order`
    where `order_id` = orderid;
end //

delimiter ;

DROP PROCEDURE IF EXISTS p_update_order_status_to_shipped;
delimiter //
CREATE PROCEDURE p_update_order_status_to_shipped(in orderid int)
begin
    update `order`
    set `status` = 'Shipped', `shipped` = now()
    where `order_id` = orderid;
end //

delimiter ;


DROP PROCEDURE IF EXISTS p_soft_delete_order;
DELIMITER //

CREATE PROCEDURE p_soft_delete_order(IN p_order_id INT)
BEGIN
    UPDATE `order`
    SET `status` = 'deleted', `deleted` = NOW()
    WHERE `order_id` = p_order_id;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS p_plocklist;
DELIMITER //

CREATE PROCEDURE p_plocklist (IN p_order_id INT)
BEGIN
    SELECT
        oi.order_id,
        oi.product_id,
        p.product_name,
        oi.quantity AS order_quantity,
        (oi.price * oi.quantity ) AS order_price,
        w.shelf_location,
        w.stock_quantity,
        (w.stock_quantity - oi.quantity) AS quantity_difference
    FROM
        `order_item` oi
    JOIN
        `product` p ON oi.product_id = p.product_id
    LEFT JOIN
        `warehouse` w ON oi.product_id = w.product_id
    WHERE
        oi.order_id = p_order_id;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_order_status;
DELIMITER //

CREATE PROCEDURE p_get_order_status (IN p_order_id INT)
BEGIN
    SELECT
        order_id,
        order_date,
        customer_id,
        created,
        updated,
        deleted,
        shipped,
        order_status(created, updated, deleted, order_date, shipped) AS calculated_status
    FROM
        `order`
    WHERE
        order_id = p_order_id;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS p_show_order_with_totals_custom;
DELIMITER //

CREATE PROCEDURE p_show_order_with_totals_custom(IN order_id INT)
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        o.customer_id,
        o.status,
        COALESCE(SUM(oi.quantity), 0) AS total_products,
        COALESCE(SUM(oi.price * oi.quantity), 0) AS total_combined_price
    FROM
        `order` o
    LEFT JOIN
        `order_item` oi ON o.order_id = oi.order_id
    WHERE
        o.order_id = order_id
    GROUP BY
        o.order_id;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS p_get_products_by_category;
DELIMITER //
CREATE PROCEDURE p_get_products_by_category(
    IN category_id INT
)
BEGIN
    SELECT p.product_name, p.price, p.stock, p.description
    FROM product p
    JOIN product_category pc ON p.product_id = pc.product_id
    WHERE pc.category_id = category_id;
END //
DELIMITER ;
