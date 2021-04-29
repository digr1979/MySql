  
-- ДЗ№9. Видеоурок. Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггерыALTER
-- только обязательная часть 
-- Dmitry Gromov

USE shop;

/*
	1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/
-- На всякий случай, смотри текущий уровень изоляции транзакций
SHOW SESSION VARIABLES WHERE Variable_name = 'transaction_isolation';

-- Очищаем на всякий случай таблицу sample.users и смотрим текущие записи в таблицах shop.users и sample.users
TRUNCATE sample.users;

SELECT * FROM shop.users WHERE id = 1;
SELECT * FROM sample.users WHERE id = 1;

-- Создаем транзакцию
START TRANSACTION;

-- Вставляем строку в sample.users
INSERT INTO sample.users(`name` ,birthday_at ,created_at ,updated_at)
SELECT  `name`
        ,birthday_at
        ,created_at
        ,updated_at
FROM	shop.users
WHERE	id = 1;

-- Удаляем запись с id = 1 из таблицы shop.users
DELETE FROM shop.users
WHERE id = 1;

-- Подтверждаем транзакцию 
COMMIT;


-- Смотрим результат в таблице sample.users
SELECT * FROM sample.users WHERE id = 1;


/*    
	2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
*/

USE shop;


-- Создаем представление
DROP VIEW IF EXISTS assortment;
CREATE VIEW assortment(`product`, `catalog`)
AS
	SELECT	p.`name`
			,c.`name`
	FROM	products AS p
		INNER JOIN catalogs AS c
		ON p.catalog_id = c.id;    

-- Проверяем как работает
SELECT *
FROM assortment;



/*    
	3. (по желанию) Пусть имеется таблица с календарным полем created_at. 
		В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
        Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
        если дата присутствует в исходном таблице и 0, если она отсутствует.
*/    

/*
	4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
		Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/

        
