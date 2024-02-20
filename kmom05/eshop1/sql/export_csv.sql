use eshop;

-- Export the customer table to a CSV file
SELECT *
FROM customer
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/customer.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the product table to a CSV file
SELECT *
FROM product
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/product.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the product_category table to a CSV file
SELECT *
FROM product_category
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/product_category.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the warehouse table to a CSV file
SELECT *
FROM warehouse
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/warehouse.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
