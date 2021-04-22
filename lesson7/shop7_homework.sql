-- ДЗ№7 Тема “Сложные запросы”
-- Dmitry Gromov

USE shop;


-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

-- в принципе, в cte здесь необходимости нет, но решил сделать так
;WITH CTE(id, `name`, total)
AS (
SELECT		u.id
			,u.`name` -- AS `имя пользователя`
			,COUNT(*) -- AS `всего заказов`
FROM		orders AS o
	INNER JOIN users AS u
	ON o.user_id = u.id
GROUP BY u.id -- u.`name`
)
SELECT  id
		,`name` AS `имя пользователя`
		,total AS `всего заказов`
FROM CTE
ORDER BY  `всего заказов` DESC;

 
 -- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 	p.id AS `id товара`
		,p.`name` AS `наименование`
        ,c.id AS `id каталога`
        ,c.`name` AS `каталог`
FROM products AS p
	INNER JOIN catalogs AS c
    ON p.catalog_id = c.id;
    

