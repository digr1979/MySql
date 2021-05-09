USE mysql;

DROP DATABASE IF EXISTS shop;

CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP() COMMENT 'время создания записи',
    object char(8) NOT NULL COMMENT 'наименование таблицы',
    row_id BIGINT UNSIGNED NOT NULL COMMENT 'идентификатор первичного ключа изменяемой записи',
    name_value varchar(255) NOT NULL COMMENT 'содержимое поля `name`'
) Engine Archive;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

DROP TRIGGER IF EXISTS ins_catalogs;

DELIMITER //
CREATE TRIGGER ins_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(object, row_id, name_value ) 
    VALUES 
		( 'catalogs', NEW.id, NEW.`name` ); 
END;
//
DELIMITER ;

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
COMMIT;  

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
--  created_at VARCHAR(16), 	
--  updated_at VARCHAR(16) 	
) COMMENT = 'Покупатели';

DROP TRIGGER IF EXISTS ins_users;

DELIMITER //
CREATE TRIGGER ins_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(object, row_id, name_value ) 
    VALUES 
		( 'users', NEW.id, NEW.`name` ); 
END;
//
DELIMITER ;

INSERT INTO `users` 
VALUES 
	(1,'Patsy Bode','1983-06-28','1983-10-09 20:40:22','1981-01-04 22:24:00')
    ,(2,'Rodolfo Ullrich MD','1977-07-28','1980-09-05 20:06:22','1978-04-02 02:22:43')
    ,(3,'Mr. Al Wiza II','2004-04-08','1977-05-16 10:31:50','1989-10-23 12:27:20')
    ,(4,'Leila Beatty','1984-12-24','1971-12-18 20:03:40','1996-09-20 11:39:13')
    ,(5,'Dr. Addison Shields','2006-04-13','1970-01-01 13:01:22','1976-07-24 06:37:00')
    ,(6,'Brady Considine','2000-11-02','1996-03-03 18:01:47','1979-03-29 10:49:55')
    ,(7,'Myrtis Blick','1999-02-17','1993-04-11 02:47:22','2012-12-09 21:23:18')
    ,(8,'Miss Jeanette Baumbach IV','1982-08-28','1982-03-29 23:14:10','2007-05-30 07:05:08')
    ,(9,'Jody Kulas DDS','1978-02-12','1983-03-26 03:08:17','2019-07-19 10:44:25')
    ,(10,'Hyman Nicolas','2013-04-04','1983-09-22 10:52:47','1986-01-14 14:25:53')
    ,(11,'Dan Miller','2012-05-02','2021-03-04 10:49:51','2015-10-24 00:07:09')
    ,(12,'Lorenz Stiedemann','1970-10-24','2019-01-05 04:36:44','1976-10-06 16:35:50')
    ,(13,'Issac Hahn','1971-04-03','1987-10-17 08:21:35','2013-07-14 01:38:21')
    ,(14,'Wilbert Auer','2006-08-09','2002-04-16 02:49:50','1998-09-27 08:17:10')
    ,(15,'Chance Ritchie','2000-02-29','2000-12-04 08:53:11','1997-05-18 22:49:36')
    ,(16,'Dejon Bayer Sr.','2014-02-18','2007-11-10 08:05:57','1985-03-06 04:08:58')
    ,(17,'Coty Hirthe','1979-03-07','1988-06-09 22:25:19','1988-03-22 20:52:31')
    ,(18,'Angus Marks','2017-11-29','1985-01-11 15:47:11','1993-06-25 08:44:35')
    ,(19,'Fannie Rodriguez','2001-02-11','2003-01-31 19:24:16','1970-09-25 07:32:04')
    ,(20,'Edwardo Auer','1997-09-16','1970-09-21 03:16:44','1986-08-03 14:46:36')
    ,(21,'Caleigh Homenick','1993-10-11','2013-06-04 01:11:59','2004-07-10 12:06:27')
    ,(22,'Dr. Raheem Buckridge Sr.','1996-05-17','2001-01-04 00:14:03','2020-12-19 17:31:49')
    ,(23,'Prof. Felicia Borer V','1987-10-19','1994-06-03 20:35:31','2006-10-09 17:18:38')
    ,(24,'Laurine Auer','1985-01-11','1989-05-07 06:47:11','1993-02-02 14:25:25')
    ,(25,'Dr. Percival Considine DDS','1988-12-21','1981-03-06 13:26:59','1994-04-28 16:26:00')
    ,(26,'Kelton McDermott','1985-11-26','1980-08-12 04:25:02','1988-06-09 02:21:33')
    ,(27,'Miss Zoila Sipes Jr.','1973-02-10','2017-02-17 07:54:47','2005-08-03 02:28:04')
    ,(28,'Mr. Rhett Hagenes DDS','2020-08-14','2009-10-17 05:26:29','1994-08-24 04:33:53')
    ,(29,'Miss Ericka DuBuque PhD','2004-02-02','1992-12-13 16:36:29','1973-12-24 23:05:27')
    ,(30,'Gerald Heller','2013-03-02','1973-07-22 07:51:08','2014-02-07 03:58:05')
    ,(31,'Dr. Toy Botsford DDS','2004-03-24','1977-07-03 09:33:55','2020-01-13 21:26:00')
    ,(32,'Christ Brekke','2000-06-29','2016-04-18 05:38:12','2001-10-10 10:54:31')
    ,(33,'Lucio Mitchell','1997-03-16','2010-03-17 00:54:07','1978-12-14 15:51:49')
    ,(34,'Prof. Monte Raynor','2006-05-11','1982-11-18 11:53:57','1978-10-28 22:36:42')
    ,(35,'Dr. Eli Mante','2003-06-14','1995-01-03 20:01:52','2009-05-31 11:12:55')
    ,(36,'Zula Prohaska PhD','1984-05-17','1970-04-18 04:58:57','1979-03-29 21:27:33')
    ,(37,'Prof. Bert Bins','2016-10-11','2003-07-16 19:38:52','1989-10-25 03:37:58')
    ,(38,'Nicolette Mohr','2008-10-18','1972-11-21 14:10:56','2014-11-16 00:26:03')
    ,(39,'Alyce Gutkowski','2012-07-21','1996-11-09 12:47:24','1989-06-25 02:16:54')
    ,(40,'Dr. Dillon Morissette IV','2008-08-25','1977-06-03 20:07:33','1983-04-10 19:50:51')
    ,(41,'Gerard Wintheiser','1978-02-22','1979-12-28 19:52:32','2001-07-27 13:01:36')
    ,(42,'Cayla Rau','1992-01-10','1993-04-18 08:34:44','1977-01-13 23:36:14')
    ,(43,'Jeremie Schamberger','1981-02-11','2001-11-25 01:43:58','1977-05-16 11:41:22')
    ,(44,'Aglae Sanford','2007-05-19','1997-11-24 07:36:58','2016-06-07 02:03:44')
    ,(45,'Prof. Robbie King DDS','1991-10-04','1986-09-28 21:54:22','1977-07-09 06:32:56')
    ,(46,'Humberto Gottlieb PhD','1993-02-27','1987-03-27 17:43:48','1980-02-19 04:17:51')
    ,(47,'Raymond West','1984-11-25','2005-01-01 09:06:56','1994-07-29 11:27:44')
    ,(48,'Prof. Deborah Emmerich','1978-03-02','1987-04-04 06:01:35','1995-07-26 04:25:30')
    ,(49,'Kaya Davis','2010-01-26','1971-05-27 08:45:51','2019-10-13 09:21:39')
    ,(50,'Stanley Huel','2019-12-14','1976-03-17 07:27:38','1986-11-16 14:10:49');
COMMIT;    

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

DROP TRIGGER IF EXISTS ins_products;

DELIMITER //
CREATE TRIGGER ins_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(object, row_id, name_value ) 
    VALUES 
		( 'products', NEW.id, NEW.`name` ); 
END;
//
DELIMITER ;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('GIGABYTE GeForce GTX 1660 SUPER OC 6G', 'Видеокарта GIGABYTE GeForce GTX 1660 SUPER OC 6G (GV-N166SOC-6GD)', 19310.00, 3),
  ('Palit GeForce GTX 1650 GP OC 4GB', 'Видеокарта Palit GeForce GTX 1650 GP OC 4GB (NE61650S1BG1-1175A)', 4790.00, 3),
  ('GIGABYTE GeForce GTX 1660 SUPER OC 6G', 'Видеокарта GIGABYTE GeForce GTX 1660 SUPER OC 6G (GV-N166SOC-6GD)', 21000.00, 3),
  ('Palit GeForce GTX 1650 GP OC 4GB', 'Видеокарта Palit GeForce GTX 1650 GP OC 4GB (NE61650S1BG1-1175A)', 5000.00, 3),
  ('ASRock Radeon RX 6900 XT Phantom Gaming D OC 16GB', 'Видеокарта ASRock Radeon RX 6900 XT Phantom Gaming D OC 16GB (RX6900XT PGD 16GO)', 125010.00, 3),
  ('Palit GeForce GTX 1650 GP OC 4GB', 'Видеокарта Palit GeForce GTX 1650 GP OC 4GB (NE61650S1BG1-1175A)', 8000.00, 3),
  ('Kingston 250 GB SA2000M8/250G', 'Твердотельный накопитель Kingston 250 GB SA2000M8/250G', 3720.00, 4),
  ('Western Digital WD Blue SATA 500 GB', 'Твердотельный накопитель Western Digital WD Blue SATA 500 GB WDS500G2B0A', 5099.00, 4),
  ('Seagate SkyHawk 1 TB ST1000VX005', 'Жесткий диск Seagate SkyHawk 1 TB ST1000VX005', 4160.00, 4),
  ('Crucial 8GB DDR4 2400MHz SODIMM 260pin CL17 CT8G4SFS824A', 'Оперативная память Crucial 8GB DDR4 2400MHz SODIMM 260pin CL17 CT8G4SFS824A', 3885.00, 5),
  ('HyperX Fury 16GB (8GBx2) 2666MHz CL16 (HX426C16FB3K2/16)', 'Оперативная память HyperX Fury 16GB (8GBx2) 2666MHz CL16 (HX426C16FB3K2/16)', 8289.00, 5),
  ('Patriot Memory VIPER 4 BLACKOUT 16GB (8GBx2) 3000MHz CL16 (PVB416G300C6K)', 'Оперативная память Patriot Memory VIPER 4 BLACKOUT 16GB (8GBx2) 3000MHz CL16 (PVB416G300C6K)', 9177.00, 5);
COMMIT;  

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';


INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('1', 12, '2018-01-23 11:14:35', '1996-04-27 04:54:49');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('2', 21, '1985-06-02 12:19:30', '2009-04-10 02:28:14');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('3', 14, '1970-01-31 14:19:13', '2020-06-25 02:46:57');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('4', 24, '2015-05-20 15:08:37', '2011-06-06 20:54:56');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('5', 17, '2013-05-18 09:40:05', '1997-05-31 20:04:09');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('6', 7, '1984-01-31 23:11:49', '1986-12-29 19:24:44');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('7', 6, '1991-08-08 15:37:16', '1978-08-18 23:04:29');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('8', 8, '1979-07-16 12:27:36', '1970-11-13 12:48:30');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('9', 10, '2019-09-27 19:02:22', '1988-10-21 16:50:00');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('10', 10, '1999-08-21 12:40:24', '1979-07-22 00:08:22');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('11', 11, '1988-02-12 02:58:43', '2005-08-21 23:52:05');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('12', 2, '2018-02-02 04:47:33', '2015-10-09 01:06:45');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('13', 23, '1981-01-11 07:32:20', '1983-01-23 15:28:26');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('14', 34, '2002-03-27 22:21:43', '2007-05-10 08:34:48');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('15', 15, '1989-03-13 07:38:11', '1970-04-04 18:36:06');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('16', 16, '2009-07-20 03:07:10', '2015-11-04 06:54:06');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('17', 17, '1978-09-25 20:33:10', '1977-08-07 01:44:03');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('18', 18, '1986-01-17 07:16:51', '2017-10-21 21:00:36');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('19', 19, '1996-08-23 01:55:32', '1991-05-25 21:07:15');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('20', 20, '2018-05-16 12:11:48', '1974-12-27 14:40:08');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('21', 10, '1980-11-15 10:27:35', '1985-11-27 04:54:19');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('22', 9, '1971-05-14 06:27:50', '1989-08-04 03:10:01');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('23', 18, '2019-09-10 04:06:54', '1974-08-22 00:12:41');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('24', 7, '1995-12-05 01:03:03', '1992-12-03 21:33:54');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('25', 25, '2011-06-16 16:22:47', '1970-10-09 05:14:20');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('26', 21, '1977-06-10 22:19:08', '1989-05-17 15:04:09');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('27', 27, '2010-08-11 02:10:22', '2003-09-27 12:38:36');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('28', 28, '1983-01-24 01:37:23', '2016-04-29 08:23:28');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('29', 29, '1973-03-11 11:27:59', '2015-12-12 23:38:33');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('30', 30, '1991-05-30 00:30:23', '2003-12-03 04:13:17');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('31', 32, '1992-11-11 15:17:02', '1991-02-20 13:12:31');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('32', 32, '1986-09-08 17:35:44', '2012-06-05 16:50:10');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('33', 33, '1982-11-17 04:59:57', '1991-02-12 15:29:10');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('34', 34, '1974-04-12 12:02:35', '1997-06-15 10:21:27');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('35', 35, '2012-03-09 01:41:06', '1999-11-30 13:01:27');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('36', 36, '1970-11-18 22:29:50', '1995-03-26 20:13:26');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('37', 37, '1980-12-16 03:40:17', '2003-01-19 15:00:54');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('38', 38, '1992-10-26 10:50:26', '2000-07-21 23:30:33');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('39', 39, '2018-04-26 00:54:33', '1974-08-25 10:35:07');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('40', 10, '2010-08-08 07:37:43', '1971-10-26 02:26:23');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('41', 12, '1992-04-22 04:36:57', '2007-08-08 00:13:33');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('42', 1, '1980-04-03 02:48:22', '1976-04-08 08:02:52');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('43', 22, '2005-03-16 15:02:09', '1976-06-28 21:40:03');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('44', 21, '2000-03-05 03:06:01', '2009-08-05 17:11:49');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('45', 45, '2008-04-21 04:44:09', '2020-11-21 17:24:25');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('46', 16, '1993-12-16 02:50:24', '2005-03-28 21:04:30');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('47', 8, '1994-02-22 05:51:03', '2019-03-27 13:27:01');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('48', 48, '1987-06-08 18:27:35', '1980-05-19 05:45:00');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('49', 49, '1985-12-17 03:16:55', '2018-03-23 20:49:51');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('50', 50, '2013-03-24 08:43:49', '1978-02-03 18:30:09');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('51', 1, '2002-08-15 06:28:54', '1994-12-22 04:41:50');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('52', 2, '1988-05-23 14:14:19', '2014-09-07 02:51:35');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('53', 3, '1990-02-13 02:51:14', '2014-12-06 04:31:23');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('54', 4, '1987-12-05 21:31:55', '1978-07-26 04:19:53');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('55', 15, '2003-03-06 01:40:01', '1991-08-15 14:46:18');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('56', 19, '1992-07-23 15:51:43', '2015-05-22 02:01:04');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('57', 7, '1980-05-16 06:31:42', '1978-10-12 12:51:16');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('58', 8, '1993-01-31 03:44:10', '1985-11-25 20:46:43');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('59', 9, '2004-02-14 16:09:13', '2007-08-04 14:50:59');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('60', 10, '2017-01-21 22:14:14', '2014-12-01 13:55:49');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('61', 11, '1982-07-04 13:10:28', '2014-05-06 15:36:48');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('62', 12, '1987-05-29 09:30:40', '1985-01-23 05:08:15');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('63', 13, '2020-01-10 23:02:59', '1999-04-13 10:52:29');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('64', 24, '1994-09-17 21:18:50', '1995-04-01 18:45:23');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('65', 8, '2010-09-02 19:09:54', '1998-05-15 08:19:37');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('66', 16, '2014-12-11 18:51:59', '2012-04-17 20:04:25');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('67', 7, '1994-11-22 07:33:38', '1996-11-09 18:44:19');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('68', 18, '1987-09-15 05:40:55', '2011-03-15 12:14:50');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('69', 19, '1995-01-15 08:45:30', '1987-04-11 06:44:32');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('70', 20, '2003-05-08 17:33:34', '2015-04-19 20:05:08');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('71', 21, '1990-06-10 07:56:01', '1980-07-11 16:31:27');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('72', 22, '1983-06-03 22:34:26', '1983-08-07 06:51:05');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('73', 23, '2015-02-03 14:23:44', '1973-09-25 16:33:11');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('74', 20, '1996-01-15 10:52:03', '2002-09-21 15:58:50');
INSERT INTO `orders` (`id`, `user_id`, `created_at`, `updated_at`) VALUES ('75', 25, '1996-09-07 09:25:55', '1970-01-23 07:48:44');

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('1', 1, 1, 1, '1983-08-25 13:25:42', '1980-10-27 07:37:42');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('2', 2, 2, 1, '1981-08-02 10:34:03', '2019-02-19 17:26:11');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('3', 3, 15, 1, '1990-11-28 17:45:52', '1970-12-03 01:07:19');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('4', 4, 4, 1, '2012-09-01 22:32:36', '1992-01-15 12:20:04');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('5', 5, 5, 1, '1980-10-07 03:11:27', '2010-04-17 06:35:27');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('6', 6, 18, 1, '1971-03-30 02:42:06', '1987-07-07 12:44:31');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('7', 7, 7, 1, '1998-04-14 02:32:23', '1976-09-07 14:34:00');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('8', 8, 1, 1, '1995-06-10 23:23:10', '1980-04-25 16:57:11');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('9', 9, 3, 1, '1992-04-15 02:42:32', '2014-11-09 06:50:12');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('10', 10, 3, 1, '1988-07-18 04:20:46', '2002-11-11 11:53:51');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('11', 11, 4, 1, '1971-12-10 22:50:49', '2016-06-08 12:03:02');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('12', 12, 5, 1, '1986-12-23 23:45:52', '1986-07-18 05:17:39');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('13', 13, 10, 1, '2015-07-05 21:02:16', '2004-03-22 19:08:38');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('14', 14, 11, 1, '2007-09-19 06:53:45', '1978-05-21 05:20:42');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('15', 15, 12, 1, '1984-10-05 19:35:10', '1997-08-14 17:20:58');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('16', 16, 1, 1, '2005-11-03 01:36:30', '1974-01-07 17:21:46');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('17', 17, 17, 1, '1996-12-23 00:10:27', '2003-02-11 13:29:56');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('18', 18, 9, 1, '2010-03-30 08:24:31', '1983-02-19 18:32:31');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('19', 19, 6, 1, '1972-06-11 10:12:50', '2000-03-17 15:20:29');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('20', 20, 6, 1, '2006-12-29 19:36:37', '1979-07-05 02:00:06');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('21', 21, 7, 1, '1989-03-16 15:01:12', '2007-07-20 10:19:49');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('22', 22, 1, 1, '2016-10-19 11:14:46', '1974-08-31 05:48:31');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('23', 23, 17, 1, '1993-09-20 05:19:24', '2003-03-05 02:07:25');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('24', 24, 8, 1, '1998-02-05 06:41:56', '2010-10-30 23:45:19');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('25', 25, 10, 1, '1976-10-24 06:27:48', '1983-03-13 17:25:47');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('26', 26, 5, 1, '1978-06-10 10:37:05', '2010-07-25 00:12:16');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('27', 27, 6, 1, '1999-06-27 02:04:51', '2019-11-08 17:03:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('28', 28, 7, 1, '1971-06-18 21:27:26', '2004-02-15 17:55:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('29', 29, 1, 1, '2012-12-14 13:21:56', '2013-07-19 18:28:00');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('30', 30, 2, 1, '1976-04-29 15:47:34', '2004-01-11 06:26:34');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('31', 31, 33, 1, '1973-04-13 03:10:56', '2016-03-29 21:25:36');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('32', 32, 14, 1, '1985-09-18 18:50:54', '1982-08-21 12:04:01');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('33', 33, 5, 1, '1989-04-21 15:53:17', '1977-07-05 02:25:13');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('34', 34, 6, 1, '1999-05-14 09:35:08', '2000-01-10 17:10:26');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('35', 35, 7, 1, '1972-08-14 06:39:13', '2009-07-21 03:42:10');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('36', 36, 1, 1, '1970-01-29 04:39:23', '1977-03-11 14:56:43');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('37', 37, 2, 1, '1999-04-01 04:29:43', '1999-01-31 04:20:07');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('38', 38, 3, 1, '2010-09-02 20:26:32', '2005-02-16 16:12:43');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('39', 39, 4, 1, '2017-09-08 22:12:45', '1977-02-27 10:01:10');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('40', 40, 5, 1, '1976-11-12 02:05:25', '1985-03-12 01:17:01');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('41', 41, 6, 1, '2011-02-19 23:53:47', '2002-01-04 10:53:41');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('42', 42, 7, 1, '1973-07-03 00:06:51', '1974-01-09 14:32:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('43', 43, 1, 1, '2019-04-30 22:44:06', '1999-10-05 09:15:15');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('44', 44, 2, 1, '1987-01-17 02:21:21', '1971-12-19 17:14:22');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('45', 45, 3, 1, '1985-04-05 05:10:15', '1973-02-14 12:54:33');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('46', 46, 4, 1, '2013-05-04 12:01:29', '2018-11-30 16:19:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('47', 47, 5, 1, '1995-02-16 03:18:02', '1978-12-01 04:49:03');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('48', 48, 6, 1, '1981-12-23 03:23:20', '2004-06-12 02:19:09');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('49', 49, 7, 1, '1996-05-20 03:09:23', '1983-11-22 18:16:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('50', 50, 1, 1, '1971-07-31 00:17:45', '2020-11-20 15:48:51');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('51', 51, 2, 1, '1972-12-01 06:45:43', '1992-10-07 19:15:14');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('52', 52, 3, 1, '1987-06-22 01:54:14', '2012-04-28 09:06:00');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('53', 53, 4, 1, '1998-09-29 19:41:59', '1994-05-03 05:35:23');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('54', 54, 5, 1, '1985-08-08 04:41:34', '2012-09-08 03:55:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('55', 55, 6, 1, '2019-04-30 17:07:31', '1999-06-06 09:00:18');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('56', 56, 7, 1, '1997-06-19 00:55:14', '1984-07-22 04:43:24');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('57', 57, 1, 1, '1974-08-22 14:04:20', '2013-08-21 09:01:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('58', 58, 2, 1, '1997-05-21 15:18:27', '2007-08-08 22:11:22');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('59', 59, 3, 1, '1990-05-20 22:13:11', '1996-06-01 14:40:12');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('60', 60, 4, 1, '1971-09-20 23:37:57', '2004-02-16 13:33:01');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('61', 61, 5, 1, '1971-05-03 03:24:38', '1996-10-19 05:36:26');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('62', 62, 6, 1, '1996-03-21 06:40:40', '2012-01-05 09:36:30');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('63', 63, 7, 1, '2005-10-24 13:53:42', '1971-07-31 16:17:08');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('64', 64, 1, 1, '1979-07-22 12:58:59', '2012-02-04 08:42:43');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('65', 65, 2, 1, '1985-03-13 14:00:17', '1984-07-09 11:49:48');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('66', 66, 3, 1, '1991-10-15 05:18:59', '1990-12-17 20:48:04');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('67', 67, 4, 1, '1983-07-10 15:15:05', '1999-05-08 22:30:42');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('68', 68, 5, 1, '2006-05-01 18:18:04', '2001-08-12 14:56:38');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('69', 69, 6, 1, '1972-09-29 18:00:22', '2004-02-06 12:28:47');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('70', 70, 7, 1, '2017-09-14 19:34:08', '1992-08-22 21:39:32');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('71', 71, 1, 1, '2003-08-20 06:16:12', '1970-03-09 23:40:03');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('72', 72, 2, 1, '1987-03-05 17:21:52', '2017-11-04 14:31:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('73', 73, 3, 1, '2000-10-16 09:43:42', '1999-07-04 07:26:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('74', 74, 4, 1, '2016-04-18 15:17:33', '1974-11-30 05:21:01');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('75', 75, 5, 1, '2019-10-07 11:51:31', '1998-05-08 04:00:34');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('76', 1, 6, 1, '2000-08-09 23:41:55', '1977-12-30 09:53:05');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('77', 2, 7, 1, '2004-01-05 01:28:52', '2013-07-24 21:15:39');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('78', 3, 1, 1, '2019-09-12 02:59:45', '1990-05-27 08:40:10');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('79', 4, 2, 1, '2017-07-26 12:01:02', '2002-07-26 20:40:14');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('80', 5, 3, 1, '1981-01-10 14:44:20', '2004-06-03 16:17:44');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('81', 6, 4, 1, '1970-08-31 19:05:30', '1993-12-19 21:50:07');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('82', 7, 5, 1, '1977-03-30 16:53:48', '1971-05-16 11:52:43');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('83', 8, 6, 1, '1985-04-22 19:26:20', '2013-02-08 11:28:28');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('84', 9, 7, 1, '2004-03-25 08:03:50', '1971-03-08 22:28:41');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('85', 10, 1, 1, '2020-08-25 15:44:52', '1977-07-17 18:24:24');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('86', 11, 2, 1, '1972-09-24 15:45:48', '1989-03-15 20:48:39');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('87', 12, 3, 1, '1991-07-22 17:42:10', '2002-07-21 13:51:14');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('88', 13, 4, 1, '1982-02-11 19:10:10', '2011-07-22 23:36:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('89', 14, 5, 1, '1997-10-18 16:04:52', '1976-09-15 14:33:42');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('90', 15, 6, 1, '1980-07-28 20:54:05', '2013-01-21 22:06:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('91', 16, 7, 1, '1998-04-14 10:30:13', '1986-08-21 00:56:46');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('92', 17, 1, 1, '1979-12-29 21:45:42', '2002-08-09 23:00:04');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('93', 18, 2, 1, '2012-11-23 04:35:01', '1992-03-06 17:57:11');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('94', 19, 3, 1, '2013-10-11 22:07:17', '2019-02-16 12:58:05');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('95', 20, 4, 1, '1999-12-08 05:06:48', '1988-12-18 00:40:47');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('96', 21, 5, 1, '2011-12-15 16:29:59', '1972-04-16 13:12:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('97', 22, 6, 1, '1978-06-19 04:54:49', '2018-08-29 03:47:40');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('98', 23, 7, 1, '1992-04-04 16:27:10', '2015-01-31 10:49:11');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('99', 24, 1, 1, '1971-06-27 07:54:43', '2004-07-04 14:38:11');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('100', 25, 2, 1, '1975-06-20 12:25:22', '1970-05-07 08:37:16');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('101', 26, 3, 1, '1976-09-30 12:17:17', '1998-11-04 06:37:02');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('102', 27, 4, 1, '2019-06-05 01:58:48', '1984-11-21 11:42:45');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('103', 28, 5, 1, '2012-01-16 06:00:34', '2008-08-10 01:29:31');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('104', 29, 6, 1, '1975-09-10 05:15:21', '1994-08-29 13:36:47');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('105', 30, 7, 1, '2001-08-01 21:10:41', '2017-09-21 14:07:05');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('106', 31, 1, 1, '2015-12-19 09:42:50', '2017-09-06 12:53:38');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('107', 32, 2, 1, '2006-03-28 18:36:43', '2014-03-28 05:51:26');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('108', 33, 3, 1, '2015-02-18 23:30:46', '1999-01-31 01:46:07');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('109', 34, 4, 1, '2004-10-22 22:48:13', '1970-09-25 03:08:39');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('110', 35, 15, 1, '2003-09-21 17:35:49', '1970-12-28 23:27:24');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('111', 36, 16, 1, '2008-08-07 15:39:33', '1971-11-28 20:46:22');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('112', 37, 17, 1, '2001-03-19 08:45:54', '1983-03-06 09:03:00');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('113', 38, 1, 1, '2017-01-30 16:25:42', '1982-04-29 16:04:49');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('114', 39, 2, 1, '1992-03-11 22:07:57', '2002-07-18 23:01:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('115', 40, 3, 1, '1996-07-16 23:00:05', '2019-01-19 09:04:57');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('116', 41, 14, 1, '2015-02-20 13:06:48', '1988-02-15 17:44:19');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('117', 42, 15, 1, '1989-07-16 05:13:22', '2010-09-07 02:40:16');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('118', 43, 16, 1, '1996-04-28 01:38:24', '1990-03-01 23:06:09');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('119', 44, 7, 1, '2011-07-31 13:26:34', '1988-07-23 17:45:57');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('120', 45, 1, 1, '2014-01-24 00:28:32', '1987-04-13 05:58:09');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('121', 46, 12, 1, '1972-03-05 14:20:43', '1999-11-01 09:06:56');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('122', 47, 13, 1, '2002-05-03 17:32:42', '2000-09-24 09:59:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('123', 48, 4, 1, '1985-01-07 14:17:29', '2015-05-07 07:12:57');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('124', 49, 5, 1, '2009-03-04 18:04:44', '2013-08-11 23:04:54');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('125', 50, 6, 1, '1984-09-30 09:36:17', '2012-06-09 06:53:42');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('126', 51, 7, 1, '1994-11-11 14:35:54', '2013-09-07 07:18:01');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('127', 52, 11, 1, '1988-07-18 07:48:16', '2019-09-08 12:01:12');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('128', 53, 12, 1, '2013-02-23 03:38:56', '2008-12-07 23:25:05');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('129', 54, 13, 1, '2016-10-23 02:52:14', '1984-10-21 04:52:03');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('130', 55, 4, 1, '1993-02-02 03:59:45', '1984-11-13 08:16:18');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('131', 56, 5, 1, '2006-10-31 15:48:44', '1999-11-16 20:32:53');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('132', 57, 6, 1, '1982-08-25 22:04:07', '1983-06-16 17:02:37');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('133', 58, 7, 1, '1984-11-24 01:03:36', '1970-03-07 15:21:33');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('134', 59, 1, 1, '1978-01-07 16:55:50', '1986-05-25 20:52:46');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('135', 60, 2, 1, '1978-10-11 15:14:21', '1996-04-28 04:00:25');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('136', 61, 3, 1, '2003-10-04 10:51:17', '2019-04-23 04:16:06');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('137', 62, 4, 1, '2010-07-30 14:05:06', '1991-11-12 22:55:06');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('138', 63, 5, 1, '1972-10-23 14:39:52', '1977-12-09 06:01:44');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('139', 64, 6, 1, '1999-03-09 18:24:24', '2018-12-07 14:24:44');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('140', 65, 7, 1, '2020-08-11 16:25:53', '1985-08-20 03:26:22');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('141', 66, 1, 1, '1977-11-07 23:42:56', '2017-04-03 16:54:17');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('142', 67, 2, 1, '1992-07-06 07:46:20', '2011-11-18 21:06:15');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('143', 68, 8, 1, '1983-11-11 16:48:47', '1984-01-21 00:31:29');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('144', 69, 9, 1, '1973-02-27 16:23:09', '2003-06-20 19:00:16');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('145', 70, 5, 1, '1971-01-04 11:42:02', '1977-08-03 06:10:45');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('146', 11, 16, 1, '1975-10-15 05:01:17', '1970-01-10 03:39:51');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('147', 12, 17, 1, '1992-06-11 05:52:19', '1992-04-23 08:35:06');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('148', 73, 1, 1, '2007-11-26 03:33:00', '1996-01-01 23:10:35');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('149', 74, 12, 1, '1982-11-23 06:46:50', '2010-04-12 20:45:44');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('150', 25, 13, 1, '1971-03-14 18:08:22', '2010-05-31 14:34:14');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('151', 26, 1, 1, '2003-08-20 06:16:12', '1970-03-09 23:40:03');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('152', 72, 2, 1, '1987-03-05 17:21:52', '2017-11-04 14:31:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('153', 33, 3, 1, '2000-10-16 09:43:42', '1999-07-04 07:26:50');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('154', 33, 1, 1, '2003-08-20 06:16:12', '1970-03-09 23:40:03');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('155', 52, 2, 1, '1987-03-05 17:21:52', '2017-11-04 14:31:59');
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`, `created_at`, `updated_at`) VALUES ('156', 53, 3, 1, '2000-10-16 09:43:42', '1999-07-04 07:26:50');


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

INSERT INTO `discounts` 
VALUES 
	(1,23,2,0.4,'1990-07-13 14:46:54','1992-02-24 21:32:54','2000-05-01 04:26:06','1987-07-29 09:40:27')
    ,(2,28,2,1.2,'1983-07-31 00:30:01','1971-10-19 12:51:42','1976-03-26 21:35:04','1984-08-12 06:26:14')
    ,(3,10,7,0.2,'2007-11-05 00:51:45','2020-12-12 05:33:18','1992-04-21 09:20:14','2007-04-29 17:57:19')
    ,(4,17,6,0.5,'1984-07-22 07:03:46','1978-11-17 02:07:04','1977-10-16 15:33:54','1990-08-01 10:15:50')
    ,(5,33,5,1.4,'1986-10-14 06:01:02','1970-10-17 06:44:02','2003-07-26 14:02:01','1979-02-11 04:23:26')
    ,(6,6,6,1.4,'2002-05-27 19:09:04','2016-03-29 14:31:22','2004-11-02 01:41:38','2009-08-13 05:12:57')
    ,(7,30,4,1.8,'1986-11-30 15:12:31','1975-07-28 13:06:39','1995-07-28 18:45:45','2018-01-15 09:45:50')
    ,(8,19,7,0.5,'1988-12-07 10:31:17','1988-10-26 03:11:15','1971-08-16 08:29:42','2005-11-17 12:14:04')
    ,(9,42,4,1,'2005-09-14 11:50:03','2002-11-06 19:40:19','1976-04-19 00:03:44','1978-07-10 13:51:08')
    ,(10,11,1,1.1,'2011-08-13 07:02:39','1974-08-20 22:58:11','1978-06-11 13:57:52','1994-02-24 07:09:05')
    ,(11,16,4,0.7,'1999-02-17 10:54:55','1984-02-15 04:46:43','1994-04-08 06:05:52','2011-07-28 07:47:41')
    ,(12,6,2,1.8,'1970-12-23 22:04:55','2017-04-15 04:00:28','2001-02-14 17:15:55','2016-07-31 14:54:18')
    ,(13,12,5,1.7,'1970-09-15 04:37:47','2003-06-08 04:45:59','1984-04-21 06:53:13','2016-05-18 19:41:17')
    ,(14,7,3,0.3,'2007-05-03 06:24:07','1976-11-19 14:52:28','2016-06-05 10:20:03','1991-11-15 03:03:16')
    ,(15,45,6,0.5,'2013-06-22 10:06:27','1989-04-11 02:10:07','2003-04-09 09:43:15','1971-08-26 18:28:40');

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








