USE mysql;

DROP DATABASE IF EXISTS shop;

CREATE DATABASE shop;

USE shop;DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
--  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  created_at VARCHAR(16), 	
  updated_at VARCHAR(16) 	
) COMMENT = 'Покупатели';


INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

/*
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '05.10.1990 00:00'),
  ('Наталья', '12.11.1984 00:00'),
  ('Александр', '20.05.1985 00:00'),
  ('Сергей', '14.02.1988 00:00'),
  ('Иван', '12.01.1998 00:00'),
  ('Мария', '29.08.1992 00:00');
*/

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('1', 'Центр', '2020-11-04 15:00:57', '2020-11-04 15:00:57');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('2', 'Восток', '2020-12-09 08:32:33', '2020-12-09 08:32:33');
INSERT INTO `storehouses` (`id`, `name`, `created_at`, `updated_at`) VALUES ('3', 'Запад', '2020-12-24 04:18:55', '2020-12-24 04:18:55');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('1', 1, 1, 5, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('2', 2, 1, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('3', 3, 1, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('4', 1, 2, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('5', 2, 2, 2, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('6', 3, 2, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('7', 1, 3, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('8', 2, 3, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('9', 3, 3, 8, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('10', 1, 4, 5, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('11', 2, 4, 7, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('12', 3, 4, 4, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('13', 1, 5, 10, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('14', 2, 5, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('15', 3, 5, 2, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('16', 1, 6, 2, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('17', 2, 6, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('18', 3, 6, 0, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('19', 1, 7, 1, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('20', 2, 7, 2, '2021-03-23 05:39:21', '2021-03-23 05:39:21');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('21', 3, 7, 6, '2021-03-23 05:39:21', '2021-03-23 05:39:21');


