-- ДЗ№11 Тема “Оптимизация запросов” и "NoSQL"
-- Dmitry Gromov

USE shop;

-- Практическое задание по теме “Оптимизация запросов”

-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа и содержимое поля name.


DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
	created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP() COMMENT 'время создания записи',
    object char(8) NOT NULL COMMENT 'наименование таблицы',
    row_id BIGINT UNSIGNED NOT NULL COMMENT 'идентификатор первичного ключа изменяемой записи',
    name_value varchar(255) NOT NULL COMMENT 'содержимое поля `name`'
) Engine Archive;

-- триггеры
DROP TRIGGER IF EXISTS ins_products;

DELIMITER //
CREATE TRIGGER ins_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(object, row_id, name_value ) 
    VALUES 
		( 'products', NEW.id, NEW.`name` ); 
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS ins_users;

DELIMITER //
CREATE TRIGGER ins_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(object, row_id, name_value ) 
    VALUES 
		( 'users', NEW.id, NEW.`name` ); 
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS ins_catalogs;

DELIMITER //
CREATE TRIGGER ins_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO `log`(object, row_id, name_value ) 
    VALUES 
		( 'catalogs', NEW.id, NEW.`name` ); 
END; //
DELIMITER ;

-- добавляем по строке в каждую таблицу

START TRANSACTION;

INSERT INTO catalogs VALUES
  (NULL, 'Колонки');
  
COMMIT;

START TRANSACTION;

INSERT INTO `users` 
VALUES 
	(NULL,'Ivan Ivanov','1980-06-13','2003-10-09 20:40:22','2015-01-04 22:24:00');
  
COMMIT;

START TRANSACTION;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Noname ssd', 'Твердотельный накопитель.', 12000.00, 4);
  
COMMIT;


-- Проверяем содержимое таблицы 'logs'
SELECT * FROM `logs`;



 -- Практическое задание по теме “NoSQL”

/*
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/

/*
	Установил и ПОСМОТРЕЛ redis. Не могу сказать, что я чего-то понял, это другой мир.
    На мой взгляд, одного урока недостаточно чтобы что-то сделать.
    MongoDB установить не смог.
*/