-- ДЗ№8 Громов Дмитрий
-- При выполнении, по сравнению с ДЗ №6, были добавлены новые данные в базу

USE vk;

/*
1.  Имею следующие мысли:
		В таблице friendship, по идее, дружба должна быть в обе стороны,
        соответственно я полагаю, что должно быть две записи (хоть это и в какой-то мере избыточно).
        
*/


/*
2. Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
Приложенный ниже запрос возвращает пользователя 86, отправившего максимальное кол-во сообщений для пользователя 81
*/

USE vk;

/* так было в домашней работе №6
SELECT  COUNT(*) AS `total_messages`
		,to_user_id
		,from_user_id
FROM messages
WHERE	to_user_id = 81

GROUP BY to_user_id
		,from_user_id
        
ORDER BY  COUNT(*) DESC LIMIT 1;      
*/

/* исправленный вариант с проверкой на наличие дружеского статуса 
	Результат - '2', 'Grimes Tommie', 'Ledner Nova'
*/

SELECT	COUNT(m.id) AS `messages_sent`
		,CONCAT_WS(' ', fu.last_name, fu.first_name) AS `from user`
		,CONCAT_WS(' ', tu.last_name, tu.first_name) AS `to user`
FROM	messages AS m
	INNER JOIN users AS fu -- джойним отправителей сообщений
    ON m.from_user_id = fu.id

	INNER JOIN users AS tu -- джойним получателей сообщений
    ON m.to_user_id = tu.id

	INNER JOIN friendship AS f -- джойним (проверяем) на дружбу
	ON (fu.id = f.user_id AND tu.id = f.friend_id)
    OR (tu.id = f.user_id AND fu.id = f.friend_id)

GROUP BY fu.id, tu.id

ORDER BY COUNT(m.id) DESC LIMIT 1;
    


/*
3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
*/

-- что я могу сделать с этой задачей в ДЗ №8 я не знаю.
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
) AS T;



/*
4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
83	M - мужчины поставили больше лайков
*/

USE vk;

/* Было в ДЗ№6
SELECT	COUNT(*) AS `total_likes`
		,p.gender
FROM votes AS v
INNER JOIN profiles AS p
	ON v.created_by = p.user_id
GROUP BY p.gender
ORDER BY `total_likes` DESC LIMIT 1;
*/

-- Новый вариант
SELECT * FROM (
SELECT	COUNT(*) AS `total_likes` 
		,p.gender
FROM votes AS v
INNER JOIN profiles AS p
	ON v.created_by = p.user_id
) AS likes;


/*
5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
*/

USE vk;

/*
-- Было в ДЗ №6
-- находим общую активность 
SELECT * FROM ( 
SELECT  SUM(activities) AS `total_activities`, 
		id 
FROM (
-- находим кол-во сообщений отправленных каждым пользователем *
SELECT  u.id  AS id
		,COUNT(*) AS `activities`
FROM	users AS u
LEFT JOIN messages AS m
		on u.id = m.from_user_id
GROUP BY u.id       

UNION ALL

-- находим кол-во лайков поставленных каждым пользователем 
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN votes AS v
		on u.id = v.created_by
GROUP BY u.id       

UNION ALL

-- находим кол-во файлов выложенных пользователем 
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN media AS m
		on u.id = m.user_id
GROUP BY u.id       

) AS t
GROUP BY id
ORDER BY `total_activities`, id ) AS t2 LIMIT 10;
*/


-- Для ДЗ №8 я добавил имена пользователей
-- находим общую активность 
SELECT t2.`total_activities`
		,t2.id
        ,CONCAT_WS(' ', eu.first_name, eu.last_name) AS `user_name` FROM ( 
SELECT  SUM(activities) AS `total_activities`, 
		id 
FROM (
-- находим кол-во сообщений отправленных каждым пользователем *
SELECT  u.id  AS id
		,COUNT(*) AS `activities`
FROM	users AS u
LEFT JOIN messages AS m
		on u.id = m.from_user_id
GROUP BY u.id       

UNION ALL

-- находим кол-во лайков поставленных каждым пользователем 
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN votes AS v
		on u.id = v.created_by
GROUP BY u.id       

UNION ALL

-- находим кол-во файлов выложенных пользователем 
SELECT  u.id
		,COUNT(*)
FROM	users AS u
LEFT JOIN media AS m
		on u.id = m.user_id
GROUP BY u.id       

) AS t
GROUP BY id
ORDER BY `total_activities`, id ) AS t2 -- LIMIT 10

		INNER JOIN users AS eu
        ON eu.id = t2.id

LIMIT 10;
