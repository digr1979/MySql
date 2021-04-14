USE vk;

/*
1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).

 Имею следующие мысли:
		БД имеет таблицу entity, которая в моей реализации в данный момент может ссылаться на записи 
        в таблицах messages и media. Так как у указанных объектов возможна связь родитель-потомок, то 
		думаю что в таблицу `entity` надо добавить поля `parent_entity_id` и `parent_entity_type_id` 
*/


/*
2. Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

Приложенный ниже запрос возвращает пользователя 86, отправившего максимальное кол-во сообщений для пользователя 81
*/

USE vk;

SELECT  COUNT(*) AS `total_messages`
		,to_user_id
		,from_user_id
FROM messages
WHERE	to_user_id = 81

GROUP BY to_user_id
		,from_user_id
        
ORDER BY  COUNT(*) DESC LIMIT 1;      



/*
3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
*/
USE vk;


SELECT SUM(T.likes) AS `total_likes` FROM (
SELECT	COUNT(*)  AS `likes`
		,p.user_id
		,p.birthday
FROM	profiles AS p
LEFT JOIN votes AS v
		ON p.user_id = v.created_by
GROUP BY
		p.user_id
		,p.birthday
        
ORDER BY birthday DESC LIMIT 10
) AS T



/*
4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

83	M - мужчины поставили больше лайков
*/

USE vk;


SELECT	COUNT(*) AS `total_likes`
		,p.gender
FROM votes AS v
INNER JOIN profiles AS p
	ON v.created_by = p.user_id
GROUP BY p.gender
ORDER BY `total_likes` DESC LIMIT 1;




/*
5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
*/

USE vk;

/* находим общую активность */ 
SELECT * FROM ( 
SELECT  SUM(activities) AS `total_activities`, 
		id 
FROM (
/* находим кол-во сообщений отправленных каждым пользователем */
SELECT  u.id  AS id
		,COUNT(*) AS `activities`
FROM	users AS u
LEFT JOIN messages AS m
		on u.id = m.from_user_id
GROUP BY u.id       

UNION ALL

/* находим кол-во лайков поставленных каждым пользователем */
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN votes AS v
		on u.id = v.created_by
GROUP BY u.id       

UNION ALL

/* находим кол-во файлов выложенных пользователем */
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN media AS m
		on u.id = m.user_id
GROUP BY u.id       

) AS t
GROUP BY id
ORDER BY `total_activities`, id ) AS t2 LIMIT 10;
