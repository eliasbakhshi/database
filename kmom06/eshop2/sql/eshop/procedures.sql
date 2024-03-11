DROP PROCEDURE IF EXISTS p_display_shelves_procedure;
DELIMITER ;;
CREATE PROCEDURE p_display_shelves_procedure()
begin
    select * from warehouse;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_display_products_on_shelves_procedure;
delimiter ;;
CREATE PROCEDURE p_display_products_on_shelves_procedure()
begin
    select p.product_name, w.shelf_location, w.stock_quantity
    from product p
    join warehouse w on p.produktid = w.product_id;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_add_product_procedure;
delimiter ;;
CREATE PROCEDURE p_add_product_procedure(
    in productid int,
    in description varchar(255),
    in productname varchar(255),
    in price decimal(10, 2),
    in stockquantity int
)
begin
    insert into product (produktid, description, product_name, price, stock)
    values (productid, description, productname, price, stockquantity);
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_add_product_to_shelf_procedure;
delimiter ;;
CREATE PROCEDURE p_add_product_to_shelf_procedure(
    in productid int,
    in shelflocation varchar(255),
    in stockquantity int
)
begin
    insert into warehouse (warehouse_id, product_id, shelf_location, stock_quantity)
    values (1,productid, shelflocation, stockquantity);
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_remove_product_from_shelf_procedure;
delimiter ;;
CREATE PROCEDURE p_remove_product_from_shelf_procedure(
    in productid int,
    in shelflocation varchar(255),
    in quantity int
)
begin
    update warehouse
    set stock_quantity = greatest(stock_quantity - quantity, 0)
    where product_id = productid and shelf_location = shelflocation;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_display_log_procedure;
delimiter ;;
CREATE PROCEDURE p_display_log_procedure(
    in lognumber int
)
begin
    select * from inventory_log order by event_date desc limit lognumber;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_display_products_procedure;
delimiter ;;
CREATE PROCEDURE p_display_products_procedure()
begin
    select product_id, product_name from product;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_display_shelf_locations_procedure;
delimiter ;;
CREATE PROCEDURE p_display_shelf_locations_procedure()
begin
    select distinct shelf_location from warehouse;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_display_inventory_procedure;
delimiter ;;
CREATE PROCEDURE p_display_inventory_procedure()
begin
    select p.product_id, p.product_name, w.shelf_location, w.stock_quantity
    from product p
    join warehouse w on p.product_id = w.product_id;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_filter_inventory_procedure;
delimiter ;;
CREATE PROCEDURE p_filter_inventory_procedure(
    in filterstring varchar(255)
)
begin
    select p.product_id, p.product_name, w.shelf_location, w.stock_quantity
    from product p
    join warehouse w on p.product_id = w.product_id
    where p.product_id like concat('%', filterstring, '%')
    or p.product_name like concat('%', filterstring, '%')
    or w.shelf_location like concat('%', filterstring, '%');
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_add_product_to_inventory_procedure;
delimiter ;;
CREATE PROCEDURE p_add_product_to_inventory_procedure(
    in productid int,
    in shelf varchar(255),
    in quantity int
)
begin
    insert into warehouse ( product_id, shelf_location, stock_quantity)
    values ( productid, shelf, quantity)
    on duplicate key update stock_quantity = stock_quantity + quantity;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_remove_product_from_inventory_procedure;
delimiter ;;
CREATE PROCEDURE p_remove_product_from_inventory_procedure(
    in productid int,
    in shelf varchar(255),
    in quantity int
)
begin
    update warehouse
    set stock_quantity = greatest(stock_quantity - quantity, 0)
    where product_id = productid and shelf_location = shelf;
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_add_inventory_log_procedure;
delimiter ;;
CREATE PROCEDURE p_add_inventory_log_procedure(
    in p_eventinstanceid varchar(36),
    in p_eventdescription varchar(255),
    in p_eventdate datetime
)
begin
    insert into inventory_log ( event_instance_id, event_description, event_date)
    values ( p_eventinstanceid, p_eventdescription, p_eventdate);
end;;
delimiter ;

DROP PROCEDURE IF EXISTS p_show_customer;
DELIMITER ;;
CREATE PROCEDURE p_show_customer(IN p_customer_id INT)
BEGIN
    SELECT * FROM Customer WHERE Customer_id = p_customer_id;
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
    SET @productId = LAST_INSERT_ID();
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
        f_order_status(created, updated, deleted, order_date, shipped) AS calculated_status
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
