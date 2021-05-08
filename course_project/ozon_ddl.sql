#######################################################################
#
#  File:  ozon_ddl.sql
#  Author: Dmitry Gromov
#  Date: 2021-05-08
#  Description: Course project - ddl for on-line marketplace a-la ozon.ru
#
#######################################################################


DROP DATABASE IF EXISTS ozon07;

CREATE DATABASE ozon07;

USE ozon07;



--
-- Table structure for table `media_types`
--

DROP TABLE IF EXISTS `mediatypes`;

-- Таблица используется для указания типа использования фотографий в таблице `mediadata` 
CREATE TABLE `mediatypes` (
  `mediatype_id` tinyint unsigned NOT NULL COMMENT '1- описание товара, 2 - отзыв на товар, 3 - вопрос-ответ, 4 - возврат',
  `mediatype_desc` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`mediatype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `profiles`
--


DROP TABLE IF EXISTS `profiles`;

-- Таблица содержит данные профиля покупателя не предназначенные для открытого доступа
CREATE TABLE `profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор профиля покупателя в пределах БД',
  `first_name` varchar(45) NOT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `gender` char(1) NOT NULL COMMENT 'M-male, F-female',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `birthday` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;

-- Создаём индекс по дате рождения для поздравлений и возможного использования в будущих акциях
CREATE INDEX ix_profiles_birthday ON `profiles`(birthday) USING BTREE;


--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;

-- Таблица `users` - не знаю что тут добавить 
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `password_hash` char(32) NOT NULL COMMENT 'md5-hash пароля',
  `public_name` varchar(45) NOT NULL COMMENT 'Публичное имя, часть того, что будет выводиться в обзорах и дискуссиях',
  `public_location` varchar(45) DEFAULT NULL COMMENT 'Часть того, что будет выводиться как публичное имя в обзорах и дискуссиях',
  `profile_id` bigint unsigned NOT NULL COMMENT 'Ссылка на ключ в таблице profile',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  KEY `FK_users_profiles` (`profile_id`),
  CONSTRAINT `FK_users_profiles` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;

-- таблица содержит категории и подкатегории товаров
-- данные взяты на основе информации из www.ozon.ru и имеют смысл 
CREATE TABLE `categories` (
  `category_id` int unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int unsigned NOT NULL DEFAULT 1 COMMENT 'Категория товаров может быть подкатегорией',
  `category_name` varchar(45) NOT NULL COMMENT 'Наименование категории' ,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_id_UNIQUE` (`category_id`),
  KEY `FK_categories_categories` (`parent_id`),
  CONSTRAINT `FK_categories_categories` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;


--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;

-- Таблица товаров. Содержит основную информацию по товарам (данные взяты с ozon.ru и имеют смысл)
-- Поля `cummulative_rating` и `total_reviews` заполняются по триггерам на таблицу `reviews`
CREATE TABLE `products` (
  `product_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `partnumber` varchar(64) NOT NULL COMMENT 'Внутренний партномер',
  `product_name` varchar(128) NOT NULL COMMENT 'Наименование',
  `category_id` int UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Категория товара', 
  `description` varchar(512) NOT NULL COMMENT 'краткое описание',
  `information` varchar(2048) NOT NULL COMMENT 'подробное описание',
  `cummulative_rating` int unsigned NOT NULL DEFAULT 0 COMMENT 'Накопительный рейтинг по результатам обзоров',
  `total_reviews` int unsigned NOT NULL DEFAULT 0 COMMENT 'количество обзоров по товару',
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `product_id_UNIQUE` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;


ALTER TABLE `products`
    ADD CONSTRAINT FK_products_categories FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- создаём индекс по категории и с обратной сортировкой по колонке `cummulative_rating`, для того, 
-- чтобы  предлагать похожие товары с наибольшим рейтингом     
CREATE INDEX ix_products__category_id_cummulative_rating_desc ON products(`category_id`, `cummulative_rating` DESC) USING BTREE;    

--
-- Table structure for table `mediadata`
--

DROP TABLE IF EXISTS `mediadata`;

-- таблица используется для привязки фотографий к описаниям, отзывам, возвратам и т. д.
-- т. е. для описания одни фотографии, для отзывов другие (добавленные пользователями) и т. д.
CREATE TABLE `mediadata` (
  `mediadata_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mediatype_id` tinyint unsigned NOT NULL COMMENT 'Тип родительского объекта, как то: описание товара, отзыв на товар, вопрос-ответ, возврат',
  `product_id` bigint unsigned NOT NULL COMMENT 'ссылка на товар',
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT 'ссылка на покупателя', 
  `photo_id` bigint unsigned NOT NULL COMMENT 'ссылка на фотографию ',
  PRIMARY KEY (`mediadata_id`),
  UNIQUE KEY `mediadata_id_UNIQUE` (`mediadata_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Индекс по товарам и типам их использования 
-- Первым индексируем поле product_id для большей селективности 
CREATE INDEX ix_mediadata__product_id_mediatype_id ON mediadata(`product_id`, `mediatype_id`) USING BTREE; 

ALTER TABLE `mediadata`
    ADD CONSTRAINT FK_mediadata_mediatypes FOREIGN KEY (mediatype_id) REFERENCES mediatypes(mediatype_id);

ALTER TABLE `mediadata`
    ADD CONSTRAINT FK_mediadata_users FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE `mediadata`
    ADD CONSTRAINT FK_mediadata_products FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE `mediadata`
    ADD CONSTRAINT FK_mediadata_photos FOREIGN KEY (photo_id) REFERENCES photos(photo_id);

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;

-- Таблица с фотографиями ( идентификатор - путь хранения в файловой системе )
-- вынес в отдельную таблицу, так как возможны варианты хранения достаточно больших бинарных объектов
CREATE TABLE `photos` (
  `photo_id` bigint unsigned NOT NULL,
  `image_path` varchar(255) NOT NULL COMMENT 'ссылка на файл в файловой системе', 
  PRIMARY KEY (`photo_id`),
  UNIQUE KEY `photo_id_UNIQUE` (`photo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `discussions`
--

DROP TABLE IF EXISTS `discussions`;

-- Таблица содержит вопросы и ответы по товарам (форум)
CREATE TABLE `discussions` (
  `discussion_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `parent_id` bigint unsigned DEFAULT NULL COMMENT 'ссылка на родительский элемент',
  `is_answered` tinyint DEFAULT '0' COMMENT 'О - если вопрос открыт, 1 - если вопрос закрыт',
  `user_id` bigint unsigned NOT NULL,
  `content` varchar(512) NOT NULL COMMENT 'содержание сообщения',
  PRIMARY KEY (`discussion_id`),
  UNIQUE KEY `discussion_id_UNIQUE` (`discussion_id`),
  KEY `FK_discussions_discussions` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;


ALTER TABLE `discussions`
    ADD CONSTRAINT FK_discussions_products FOREIGN KEY (product_id) REFERENCES products(product_id);
    
ALTER TABLE `discussions`
    ADD CONSTRAINT FK_discussions_users FOREIGN KEY (user_id) REFERENCES users(id);
    

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;

-- Общая информация по заказам 
-- детали содержатся в таблице `orderdetails`
CREATE TABLE `orders` (
  `order_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `is_shipped` tinyint DEFAULT '0' COMMENT 'Товар доставлен в пункт доставки',
  `is_delivered` tinyint DEFAULT '0' COMMENT 'Товар получен покупателем',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`,`user_id`),
  UNIQUE KEY `order_id_UNIQUE` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8;

ALTER TABLE `orders`
    ADD CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users(id);
    
--
-- Table structure for table `orderdetails`
--

DROP TABLE IF EXISTS `orderdetails`;

-- Таблица содержит детальную информацию о каждом заказе
CREATE TABLE `orderdetails` (
  `order_line_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL COMMENT 'идентификатор документа в таблице `orders`',
  `product_id` bigint unsigned NOT NULL,
  `qty` int unsigned NOT NULL DEFAULT 0 COMMENT 'количество',
  `price` decimal(10,2)  NOT NULL DEFAULT 0  COMMENT 'цена',
  `discount` decimal(3,2)  NOT NULL DEFAULT 0 COMMENT 'скидка',
  PRIMARY KEY (`order_line_id`),
  UNIQUE KEY `order_line_id_UNIQUE` (`order_line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `orderdetails`
    ADD CONSTRAINT FK_orderdetails_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);
    
ALTER TABLE `orderdetails`
    ADD CONSTRAINT FK_orderdetails_products FOREIGN KEY (product_id) REFERENCES products(product_id);
    

--
-- Table structure for table `returns`
--

DROP TABLE IF EXISTS `returns`;

-- Таблица содержит общую информацию по возвратам товаров
-- детали содержатся в таблице `returndetails`
CREATE TABLE `returns` (
  `return_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL COMMENT 'заказ (документ-основание)',
  `user_id` bigint unsigned NOT NULL COMMENT 'покупатель',
  `complaints` varchar(512) NOT NULL COMMENT 'описание неисправности',
  `is_approved` tinyint DEFAULT '0' COMMENT 'возврат согласован',
  `is_returned` tinyint DEFAULT '0' COMMENT 'товар возвращен',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`return_id`),
  UNIQUE KEY `return_id_UNIQUE` (`return_id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8;


ALTER TABLE `returns`
    ADD CONSTRAINT FK_returns_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);
    
ALTER TABLE `returns`
    ADD CONSTRAINT FK_returns_users FOREIGN KEY (user_id) REFERENCES users(id);
    
    
--
-- Table structure for table `returndetails`
--

DROP TABLE IF EXISTS `returndetails`;

-- Таблица содержит детальную информацию о возврате
CREATE TABLE `returndetails` (
  `return_line_id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Первичный ключ',
  `return_id` bigint unsigned NOT NULL COMMENT 'идентификатор документа в таблице `returns`',
  `product_id` bigint unsigned NOT NULL COMMENT 'идентификатор продукта',
  `qty` int unsigned NOT NULL COMMENT 'количество по строку',
  `return_sum` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'сумма по строке, высчитывается по данным из документа-заказа, поделенным на возвращаемое кол-во',
  PRIMARY KEY (`return_line_id`),
  UNIQUE KEY `id_UNIQUE` (`return_line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `returndetails`
    ADD CONSTRAINT FK_returndetails_returns FOREIGN KEY (return_id) REFERENCES `returns`(return_id);
    
ALTER TABLE `returndetails`
    ADD CONSTRAINT FK_returndetails_products FOREIGN KEY (product_id) REFERENCES products(product_id);
    

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;

-- Таблица с отзывами на товар
-- к данной таблице привязаны триггеры `ins_review` и `del_review`
-- при добавлении/удалении отзыва, пересчитывается рейтинг и кол-во отзывов в таблице `products`
CREATE TABLE `reviews` (
  `review_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `pros` varchar(128) DEFAULT NULL,
  `cons` varchar(128) DEFAULT NULL,
  `comment` varchar(512) DEFAULT NULL,
  `rating` tinyint unsigned NOT NULL DEFAULT 0,
  `user_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `reviews`
    ADD CONSTRAINT FK_reviews_users FOREIGN KEY (user_id) REFERENCES users(id);
    
ALTER TABLE `reviews`
    ADD CONSTRAINT FK_reviews_products FOREIGN KEY (product_id) REFERENCES products(product_id);
    
    
-- Триггер пересчитывается рейтинг и кол-во отзывов в таблице `products` при добавлении нового отзыва в таблицу `reviews`   
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `ins_review` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
        UPDATE products 
            SET cummulative_rating = cummulative_rating + NEW.rating
                ,total_reviews = total_reviews + 1
            WHERE product_id = NEW.product_id;
    END */;;
DELIMITER ;

-- Триггер пересчитывается рейтинг и кол-во отзывов в таблице `products` при удалении отзыва в таблице `reviews`   
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `del_review` AFTER DELETE ON `reviews` FOR EACH ROW BEGIN
        UPDATE products 
            SET cummulative_rating = cummulative_rating - OLD.rating
                ,total_reviews = total_reviews - 1
            WHERE product_id = OLD.product_id;
    END */;;
DELIMITER ;


--
-- Dumping routines for database 'ozon07'
--

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

--
-- View `ratings`
--

DROP VIEW IF EXISTS `ratings`;

-- Представление отображает изменение рейтинга товара с каждым новым отзывом (как суммарного, так и среднего) 
-- используя оконные функции
CREATE VIEW `ratings` (`row_number`,`product_name`,`total_cummulative_rating`,`pros`,`cons`,`comment`,`rating`,`author`,`current_cum_rating`,`avg_cum_rating`) 
AS 
	select row_number() OVER (PARTITION BY `p`.`product_id` )  AS `row_number`
			,`p`.`product_name` AS `product_name`
            ,`p`.`cummulative_rating` AS `total_cummulative_rating`
            ,`r`.`pros` AS `pros`
            ,`r`.`cons` AS `cons`
            ,`r`.`comment` AS `comment`
            ,`r`.`rating` AS `rating`
            ,concat_ws(', ',`u`.`public_name`,`u`.`public_location`) AS `author`
            ,sum(`r`.`rating`) OVER (PARTITION BY `p`.`product_id` ORDER BY `r`.`review_id` RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS `current_cumulative_rating`
            ,(sum(`r`.`rating`) OVER (PARTITION BY `p`.`product_id` ORDER BY `r`.`review_id` RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  / row_number() OVER (PARTITION BY `p`.`product_id` ) ) AS `avg_cumulative_rating`
	from ((`products` `p` 
		
        left join `reviews` `r` 
        on((`p`.`product_id` = `r`.`product_id`))) 
        
        join `users` `u` 
        on((`r`.`user_id` = `u`.`id`))) 
        
			order by `p`.`product_id`;

--
-- View `toptencustomersbyrevenue`
--

DROP VIEW IF EXISTS `toptencustomersbyrevenue`;

-- Представление отображает топ 10 покупателей, совершивших покупки на большую общую сумму
CREATE VIEW `toptencustomersbyrevenue` (`row_number`,`user_id`,`customer`,`total_orders`,`total_sum`,`cummulate_sum`) 
AS with `CTE` (`user_id`,`customer`,`total_orders`,`total_sum`) 
as (
	select `o`.`user_id` AS `user_id`
			,concat_ws(', ',`u`.`public_name`,`u`.`public_location`) AS `customer`
            ,count(`o`.`order_id`) AS `total_orders`
            ,sum(cast((((1 - `od`.`discount`) * `od`.`qty`) * `od`.`price`) as decimal(10,2))) AS `total_sum` 
	from ((`orderdetails` `od` 
    
		join `orders` `o` 
        on((`od`.`order_id` = `o`.`order_id`))) 
        
        join `users` `u` 
        on((`o`.`user_id` = `u`.`id`))) 
        
			group by `o`.`user_id`
) select row_number() OVER ()  AS `row_number`
		,`CTE`.`user_id` AS `user_id`
        ,`CTE`.`customer` AS `customer`
        ,`CTE`.`total_orders` AS `total_orders`
        ,`CTE`.`total_sum` AS `total_sum`
        ,sum(`CTE`.`total_sum`) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS `cummulate_sum` 
from `CTE` 
order by `CTE`.`total_sum` desc limit 10;

