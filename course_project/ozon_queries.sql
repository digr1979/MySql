#######################################################################
#
#  File:  ozon_queries.sql
#  Author: Dmitry Gromov
#  Date: 2021-05-08
#  Description: Course project - some queries for on-line marketplace a-la ozon.ru
#
#######################################################################


USE ozon07;



-- Запрос отображает подробную информацию о заказе с нарастающим ИТОГО ( для примера, заказ №25)
SELECT 	o.order_id AS `номер заказа`
		,row_number() OVER( PARTITION BY (o.order_id) ORDER BY (od.order_line_id)) AS `номер строки заказа`
		,concat_ws(', ', u.public_name, u.public_location) AS `покупатель` 
        ,p.product_name AS `наименование`
        ,od.qty AS `количество`
        ,od.price AS `цена`
        ,od.discount AS `скидка на товар`
        ,(1 - od.discount) * od.qty * od.price AS `цена со скидкой`
        ,SUM((1 - od.discount) * od.qty * od.price) OVER( PARTITION BY(o.order_id) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS `итого`

FROM  orders AS o        
	
    INNER JOIN orderdetails AS od
    ON od.order_id = o.order_id

    INNER JOIN users AS u
    ON o.user_id = u.id

    INNER JOIN products AS p
    ON od.product_id = p.product_id

WHERE o.order_id = 25;
-- конец запроса


-- Извлекаем картинки относящиеся к описанию товара с id=19 (Контрольное списывание. 1-й класс)
SELECT  p.product_name AS `Наименование товара`
		,mt.mediatype_desc AS `Картинка - для чего использовать`
		,ph.image_path AS `Файл`
FROM 	mediadata AS md

	INNER JOIN mediatypes AS mt
    ON md.mediatype_id = mt.mediatype_id

	INNER JOIN products AS p
    ON md.product_id = p.product_id

	INNER JOIN photos AS ph
	ON md.photo_id = ph.photo_id
    
WHERE md.product_id = 19
	  AND mt.mediatype_desc LIKE 'Описание товара'

ORDER BY md.product_id, md.photo_id;
-- конец запроса



-- выводим все товары из категории и подкатегорий электроника (id = 12)
WITH RECURSIVE CTE(category_id, parent_id, category_name)
AS (
-- получаем категорию 'Электроника', первый элемент рекурсии
SELECT  c.category_id
		,c.parent_id
        ,c.category_name
FROM	categories AS c
WHERE	c.category_name LIKE '%Электроника%'

UNION ALL

-- получаем подкатегории
SELECT  c1.category_id
		,c1.parent_id
        ,c1.category_name
FROM	categories AS c1
	
		INNER JOIN CTE AS ce
        ON c1.parent_id = ce.category_id
)
SELECT c2.category_id
		,c2.parent_id AS `категория-родитель`
        ,c2.category_name AS `наименование категории товаров`
        ,p.product_name AS `наименование товара`
FROM CTE as c2
	-- джойним полученные категории (в том числе и пустые) с товарами
    -- или INNER JOIN без пустых категорий 
    LEFT JOIN products AS p
    ON p.category_id = c2.category_id

ORDER BY c2.category_id;    
-- конец запроса



-- два представления `toptencustomersbyrevenue`, `ratings`

-- Представление отображает топ 10 покупателей, совершивших покупки на большую общую сумму
SELECT * FROM toptencustomersbyrevenue;

-- Представление отображает изменение рейтинга товара с каждым новым отзывом (как суммарного, так и среднего) 
-- используя оконные функции
SELECT * FROM ratings;

