/* my database: sakila */
DROP SCHEMA IF EXISTS `sakila_dw` ;
CREATE SCHEMA IF NOT EXISTS `sakila_dw` DEFAULT CHARACTER SET latin1 ;
USE `sakila_dw` ;

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

CREATE TABLE `film_inventory` (
`film_inventory_key` int NOT NULL auto_increment,
`inventory_id` int DEFAULT NULL,
`customer_id` int DEFAULT NULL,
`staff_id` int DEFAULT NULL,
`store_id` int DEFAULT NULL,
`rental_id` int DEFAULT NULL,
  `film_id` int DEFAULT NULL,
  `title` varchar(128) NOT NULL,
  `description` text,
  `release_year` year DEFAULT NULL,
  `language_id` tinyint unsigned NOT NULL,
  `original_language_id` tinyint unsigned DEFAULT NULL,
  `rental_duration` tinyint unsigned NOT NULL DEFAULT '3',
  `rental_rate` decimal(4,2) NOT NULL DEFAULT '4.99',
  `length` smallint unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) NOT NULL DEFAULT '19.99',
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT 'G',
  `special_features` set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`film_inventory_key`),
  Key `film_if` (`film_id`),
  Key `customer_key` (`customer_id`),
  Key `staff_key` (`staff_id`),
  Key `store_key` (`store_id`),
  Key `rental_key` (`rental_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3;
  
  
  use sakila_dw;
INSERT INTO `sakila_dw`.`dim_customer`
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


INSERT INTO `sakila_dw`.`dim_rental`
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

INSERT INTO `sakila_dw`.`dim_staff`
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

INSERT INTO `sakila_dw`.`dim_store`
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

INSERT INTO `sakila_dw`.`film_inventory`
(`inventory_id`,
`customer_id`,
`staff_id`,
`store_id`,
`rental_id`,
`film_id`,
`title`,
`description`,
`release_year`,
`language_id`,
`original_language_id`,
`rental_duration`,
`rental_rate`,
`length`,
`replacement_cost`,
`rating`,
`special_features`,
`last_update`)
SELECT 
	inv.`inventory_id`,
	customer.`customer_id` as customer_id,
    staff.`staff_id` as staff_id,
    store.`store_id` as store_id,
    rental.`rental_id` as rental_id,
    f.`film_id`,
    f.`title`,
    f.`description`,
    f.`release_year`,
    f.`language_id`,
    f.`original_language_id`,
    f.`rental_duration`,
    f.`rental_rate`,
    f.`length`,
    f.`replacement_cost`,
    f.`rating`,
    f.`special_features`,
    f.`last_update`
    FROM sakila.inventory as inv
INNER JOIN sakila.film as f
ON inv.film_id = f.film_id
INNER JOIN sakila.store as store
ON inv.store_id = store.store_id
INNER JOIN sakila.staff as staff
ON store.store_id = staff.store_id
INNER JOIN sakila.rental as rental
ON staff.staff_id = rental.staff_id
INNER JOIN sakila.customer as customer
ON store.store_id = customer.store_id;










