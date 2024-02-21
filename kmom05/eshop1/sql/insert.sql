--
-- Insert into customer table
--
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
