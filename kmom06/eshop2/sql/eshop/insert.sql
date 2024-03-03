--
-- Insert into customer table
--
use eshop;
LOAD DATA LOCAL INFILE 'customer.csv'
INTO TABLE customer
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(`customer_id`, `firstname`, `lastname`, `email`, `password`, `address`, `phone_number`);

--
-- Insert into product table
--
LOAD DATA LOCAL INFILE 'product.csv'
INTO TABLE product
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(`product_id`, `description`, `product_name`, `price`, `stock`);

--
-- Insert into category table
--
LOAD DATA LOCAL INFILE 'category.csv'
INTO TABLE category
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(`category_id`, `name`);

--
-- Insert into product_category table
--
LOAD DATA LOCAL INFILE 'product_category.csv'
INTO TABLE product_category
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(`product_id`, `category_id`);

--
-- Insert into warehouse table
--
LOAD DATA LOCAL INFILE 'warehouse.csv'
INTO TABLE warehouse
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
(`product_id`, `shelf_location`, `stock_quantity`);

LOAD DATA LOCAL INFILE 'order.csv'
INTO TABLE `order`
CHARACTER SET utf8
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`order_id`, `order_date`, `total_price`, `customer_id`, `status`, `created`, `updated`, `deleted`, `shipped`);

LOAD DATA LOCAL INFILE 'order_item.csv'
INTO TABLE order_item
CHARACTER SET utf8
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`order_item_id`, `order_id`, `product_id`, `quantity`, `price`, `created`, `updated`, `deleted`);

LOAD DATA LOCAL INFILE 'inventory_log.csv'
INTO TABLE inventory_log
CHARACTER SET utf8
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(`log_id`, `event_instance_id`, `event_description`, `event_date`, `created`, `updated`, `deleted`);
