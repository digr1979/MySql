#######################################################################
#
#  File:  ozon_procedures.sql
#  Author: Dmitry Gromov
#  Date: 2021-05-08
#  Description: Course project - stored procedures and triggers for on-line marketplace a-la ozon.ru
#
#######################################################################


-- Процедуры и триггеры присутсвуют в файле ozon_ddl.sql


USE ozon07;

DROP PROCEDURE IF EXISTS `sp_getdiscussion`;

-- 'Возвращает все существующие ветки обсуждений по указанному товару, посредством вызова рекурсивного cte. Для примера: product_id = 27'
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getdiscussion`(IN productid BIGINT UNSIGNED)
    COMMENT 'Возвращает все существующие ветки обсуждений по указанному товару, посредством вызова рекурсивного cte. Для примера: product_id = 27'
BEGIN 
	WITH RECURSIVE CTE(parent_id, discussion_id, product_id, user_id, content)
	AS (
	 
	SELECT	d.parent_id, d.discussion_id, d.product_id, d.user_id, d.content
	FROM	discussions AS d
	WHERE 	d.product_id = productid

	UNION  

	SELECT dd.parent_id, dd.discussion_id, dd.product_id, dd.user_id, dd.content
	FROM	discussions AS dd
	   INNER JOIN CTE AS c
		ON c.parent_id = dd.discussion_id
	)
	SELECT eq.parent_id AS `branch id`
		, eq.discussion_id AS `message id`
        , eq.product_id AS `product id`
        , u.public_name AS `user, location`
        , eq.content AS `text` 
	FROM CTE AS eq
    
    INNER JOIN users AS u
    ON eq.user_id = u.id
    
	ORDER BY parent_id, discussion_id;
END ;;
DELIMITER ;


-- Триггеры на таблицу `reviews`

-- Триггер пересчитывается рейтинг и кол-во отзывов в таблице `products` при добавлении нового отзыва в таблицу `reviews`   
DROP TRIGGER IF EXISTS `ins_review`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` TRIGGER `ins_review` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
        UPDATE products 
            SET cummulative_rating = cummulative_rating + NEW.rating
                ,total_reviews = total_reviews + 1
            WHERE product_id = NEW.product_id;
    END;;
DELIMITER ;

-- Триггер пересчитывается рейтинг и кол-во отзывов в таблице `products` при удалении отзыва в таблице `reviews`   
DROP TRIGGER IF EXISTS `del_review`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` TRIGGER `del_review` AFTER DELETE ON `reviews` 
FOR EACH ROW BEGIN
        UPDATE products 
            SET cummulative_rating = cummulative_rating - OLD.rating
                ,total_reviews = total_reviews - 1
            WHERE product_id = OLD.product_id;
    END;;
DELIMITER ;


