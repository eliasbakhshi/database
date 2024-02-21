-- Export the customer table to a CSV file
SELECT 'customer_id', 'firstname', 'lastname', 'email', 'password', 'address', 'phone_number'
UNION ALL
SELECT *
FROM customer
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/customer.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the product table to a CSV file
SELECT 'produkt_id', 'description', 'product_name', 'price', 'stock'
UNION ALL
SELECT *
FROM product
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/product.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the product_category table to a CSV file
SELECT 'produkt_id', 'category_id'
UNION ALL
SELECT *
FROM product_category
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/product_category.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the warehouse table to a CSV file
SELECT 'product_id', 'shelf_location', 'stock_quantity'
UNION ALL
SELECT *
FROM warehouse
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/warehouse.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Export the category table to a CSV file
SELECT 'category_id', 'name'
UNION ALL
SELECT *
FROM category
INTO OUTFILE '/mnt/hgfs/share/projects/database/kmom05/eshop1/sql/category.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
