-- Table structure for table `category`
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `customer`
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- -- Table structure for table `delivery`
-- DROP TABLE IF EXISTS `delivery`;
-- CREATE TABLE `delivery` (
--   `delivery_id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_id` int(11) DEFAULT NULL,
--   `delivery_date` datetime DEFAULT NULL,
--   `status` varchar(20) DEFAULT NULL,
--   `created` datetime DEFAULT NOW(),
--   `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
--   `deleted` datetime DEFAULT NULL,
--   PRIMARY KEY (`delivery_id`),
--   KEY `order_id` (`order_id`),
--   FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `inventory_log`
DROP TABLE IF EXISTS `inventory_log`;
CREATE TABLE `inventory_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_instance_id` varchar(36) NOT NULL,
  `event_description` text DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`event_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `invoice`
-- DROP TABLE IF EXISTS `invoice`;
-- CREATE TABLE `invoice` (
--   `invoice_id` int(11) NOT NULL AUTO_INCREMENT,
--   `order_id` int(11) DEFAULT NULL,
--   `invoice_date` datetime DEFAULT NULL,
--   `total_price` decimal(10,2) DEFAULT NULL,
--   `created` datetime DEFAULT NOW(),
--   `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
--   `deleted` datetime DEFAULT NULL,
--   PRIMARY KEY (`invoice_id`),
--   KEY `order_id` (`order_id`),
--   FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `order`
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_date` datetime DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  `shipped` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `customer_id` (`customer_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `order_item`
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



-- Table structure for table `product_category`
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `category_id` (`category_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Table structure for table `warehouse`
DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse` (
  `product_id` int(11) NOT NULL,
  `shelf_location` varchar(255) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NOW(),
  `updated` datetime NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;