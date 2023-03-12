/* my database: sakila */
DROP SCHEMA IF EXISTS `sakila_dw1` ;
CREATE SCHEMA IF NOT EXISTS `sakila_dw1` DEFAULT CHARACTER SET latin1 ;
USE `sakila_dw1` ;

CREATE TABLE `dim_customer` (
  `customer_key` smallint unsigned NOT NULL AUTO_INCREMENT,
  `store_id` tinyint unsigned NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address_id` smallint unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `idx_fk_store_id` (`store_id`),
  KEY `idx_fk_address_id` (`address_id`),
  KEY `idx_last_name` (`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=600 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dim_staff` (
  `staff_key` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `address_id` smallint unsigned NOT NULL,
  `picture` blob,
  `email` varchar(50) DEFAULT NULL,
  `store_id` tinyint unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `username` varchar(16) NOT NULL,
  `password` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_key`),
  KEY `idx_fk_store_id` (`store_id`),
  KEY `idx_fk_address_id` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dim_store` (
  `store_key` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `manager_staff_id` tinyint unsigned NOT NULL,
  `address_id` smallint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`store_key`),
  UNIQUE KEY `idx_unique_manager` (`manager_staff_id`),
  KEY `idx_fk_address_id` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dim_rental` (
  `rental_key` int NOT NULL AUTO_INCREMENT,
  `rental_date` datetime NOT NULL,
  `inventory_id` mediumint unsigned NOT NULL,
  `customer_id` smallint unsigned NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `staff_id` tinyint unsigned NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rental_key`),
  UNIQUE KEY `rental_date` (`rental_date`,`inventory_id`,`customer_id`),
  KEY `idx_fk_inventory_id` (`inventory_id`),
  KEY `idx_fk_customer_id` (`customer_id`),
  KEY `idx_fk_staff_id` (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16050 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `sakila_dw1`.`dim_customer`
(`customer_key`,
`store_id`,
`first_name`,
`last_name`,
`email`,
`address_id`,
`active`,
`create_date`)
SELECT `customer`.`customer_id`,
    `customer`.`store_id`,
    `customer`.`first_name`,
    `customer`.`last_name`,
    `customer`.`email`,
    `customer`.`address_id`,
    `customer`.`active`,
    `customer`.`create_date`
FROM `sakila`.`customer`;

#SELECT * FROM sakila_dw.dim_customer;


INSERT INTO `sakila_dw1`.`dim_rental`
(`rental_key`,
`rental_date`,
`inventory_id`,
`customer_id`,
`return_date`,
`staff_id`,
`last_update`)
SELECT `rental`.`rental_id`,
    `rental`.`rental_date`,
    `rental`.`inventory_id`,
    `rental`.`customer_id`,
    `rental`.`return_date`,
    `rental`.`staff_id`,
    `rental`.`last_update`
FROM `sakila`.`rental`;

#SELECT * FROM sakila_dw.dim_rental;

INSERT INTO `sakila_dw1`.`dim_staff`
(`staff_key`,
`first_name`,
`last_name`,
`address_id`,
`picture`,
`email`,
`store_id`,
`active`,
`username`,
`password`,
`last_update`)
SELECT `staff`.`staff_id`,
    `staff`.`first_name`,
    `staff`.`last_name`,
    `staff`.`address_id`,
    `staff`.`picture`,
    `staff`.`email`,
    `staff`.`store_id`,
    `staff`.`active`,
    `staff`.`username`,
    `staff`.`password`,
    `staff`.`last_update`
FROM `sakila`.`staff`;
#SELECT * FROM sakila_dw.dim_staff;

INSERT INTO `sakila_dw1`.`dim_store`
(`store_key`,
`manager_staff_id`,
`address_id`,
`last_update`)
SELECT `store`.`store_id`,
    `store`.`manager_staff_id`,
    `store`.`address_id`,
    `store`.`last_update`
FROM `sakila`.`store`;
#SELECT * FROM sakila_dw.dim_store;
