###################################################################################
# 
# Author: 	   Dmitry Gromov
# Date:        2021-04-29
# Description: Homework #10
#
###################################################################################


USE vk;

/*
    1. Проанализировать какие запросы могут выполняться наиболее
       часто в процессе работы приложения и добавить необходимые индексы.
*/

-- Просмотрев существующие индексы, добавил следующие в файл vk_db_10_schema.sql:

-- Для таблицы users:
-- CREATE INDEX ix_last_name ON users(last_name ASC) USING BTREE COMMENT "Для поиска по фамилии";

-- Для таблицы profiles:
-- CREATE INDEX ix_birthday ON profiles(birthday ASC) USING BTREE COMMENT "Для возможности реализации напоминаний";
-- CREATE INDEX ix_country_city ON profiles(country ASC, city ASC) USING BTREE COMMENT "Для поиска по стране"; 
-- 				Полагаю, что здесь уместен композитный индекс из страны и города.





/*
    2. Задание на оконные функции
	   Построить запрос, который будет выводить следующие столбцы:
           имя группы;
           среднее количество пользователей в группах;
		   самый молодой пользователь в группе;
           самый старший пользователь в группе;
           общее количество пользователей в группе;
           всего пользователей в системе;
           отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
*/

USE vk;

/*   communities:
		id	int unsigned	NO	PRI		auto_increment
		name	varchar(150)	NO	UNI		
		principal_id	int unsigned	NO	MUL		
		created_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED
		updated_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED on update CURRENT_TIMESTAMP

	 communities_users:
		community_id	int unsigned	NO	PRI		
		user_id	int unsigned	NO	PRI		
		created_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED
*/

SELECT	*
FROM	communities;

SELECT  *
FROM 	communities_users;

--

SELECT		c.`name`
			,cu.*
FROM		communities AS c
	INNER JOIN communities_users AS cu
    ON c.id = cu.community_id
;


USE vk;

;WITH CTE (id, community_name, user_num, total_users_per_group, user_id, user_name, birthday, total_users)
AS (  
	SELECT		c.id  -- id группы
				,c.`name` -- наименование группы для наглядности 
				,ROW_NUMBER() OVER (PARTITION BY c.id) AS user_num -- нумерую пользователей в группах
                ,COUNT(cu.user_id) OVER (PARTITION BY c.id) AS total_users_per_group -- считаю кол-во пользователей в каждой группе
				,cu.user_id
				,concat_ws(' ', u.last_name, u.first_name) AS user_name -- полное имя пользователя для наглядности
				,p.birthday -- день рождения для нахождения самого молодого и самого старого в группе
                ,(SELECT COUNT(*) FROM users) AS total_users -- всего пользователей 
	FROM		communities AS c
		RIGHT OUTER JOIN communities_users AS cu
		ON c.id = cu.community_id
		
		INNER JOIN users AS u
		ON cu.user_id = u.id
		
		INNER JOIN `profiles` AS p
		ON cu.user_id = p.user_id
)
SELECT 	community_name
		,user_num
		,user_name
        ,birthday
        ,total_users_per_group -- всего пользователей в группе
        ,AVG(total_users_per_group) OVER () AS avg_users_per_group -- среднее число пользователей на группу
        ,MAX(birthday) OVER (PARTITION BY id) AS yongest_user_in_group -- самый молодой в группе
        ,MIN(birthday) OVER (PARTITION BY id) AS oldest_user_in_group   -- самый старый в группе
        ,total_users -- всего пользователей
        ,ROUND(((total_users_per_group / total_users) * 100)) AS division -- отношение кол-ва пользователей в группе к общему числу пользователей
FROM CTE;


-- В процессе выполнения задачи возник вопрос. Можно ли использовать аггрегацию внутри другой аггрегации??
-- т. е. к примеру, высчитать пользователей в группах и тут же отношение кол-ва пользователей в группе к общему числу пользователей?






           