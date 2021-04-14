
-- 	Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
USE shop;


/* 	Задание 1
	Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */
    
USE shop;

UPDATE users
SET created_at = DATE_FORMAT(current_timestamp(), "%d.%m.%Y %H:%i"),
	updated_at = DATE_FORMAT(current_timestamp(), "%d.%m.%Y %H:%i");
    
    
    
/*	Задание 2
	Таблица users была неудачно спроектирована. 
    Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
    Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.  */

 USE shop;

-- 2.1 создаем временную таблицу temp_users, в которую копируем данные таблицы users 
 CREATE TEMPORARY TABLE temp_users AS (
	SELECT 	*
    FROM	users );
    
    
-- 2.2 удаляем колонки created_at и updated_at в таблице users
ALTER TABLE users
	DROP COLUMN created_at;
 
ALTER TABLE users
	DROP COLUMN updated_at;

-- 2.3 добавляем колонки created_at и updated_at типа DATEIME в таблицу users
ALTER TABLE users
	ADD COLUMN created_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users
	ADD COLUMN updated_at DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
        

-- 2.4 заполняем новосозданные колонки created_at и updated_at типа DATEIME в таблице users данными из временной таблицы temp_users
UPDATE users AS u, temp_users AS t
SET u.created_at = STR_TO_DATE( t.created_at, '%d.%m.%Y %H:%i' )
	,u.updated_at = STR_TO_DATE( t.updated_at, '%d.%m.%Y %H:%i' )
WHERE u.id = t.id;

-- 2.5 удаляем таблицу temp_users, она больше не нужна
DROP TABLE temp_users;


/* В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
	если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
    чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей. */

USE shop;

SELECT 		* 
FROM storehouses_products AS sp
ORDER BY sp.value = 0, sp.value ASC; 

    
-- Практическое задание теме «Агрегация данных»

-- 1. Подсчитайте средний возраст пользователей в таблице users.

USE shop;

    
SELECT AVG(DATEDIFF(CURRENT_DATE(), birthday_at) / 365.4) AS `avg_age` 
FROM users;
    
    
-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- 	  Следует учесть, что необходимы дни недели текущего года, а не года рождения.
    
USE shop;


;WITH cte(id, `weekday_name`)
AS (
	SELECT id
			,date_format(CONCAT(YEAR(current_date()), date_format(birthday_at, '-%m-%d')), '%W')
	FROM users
)
SELECT COUNT(*) AS `total`
		,weekday_name
FROM cte
GROUP BY weekday_name;






    