-- lesson6

USE vk;

SELECT	*
FROM	users LIMIT 5;


DESCRIBE media;

SELECT	filename
		,size
FROM	media
WHERE	id IN (
			SELECT media_id
            FROM	profiles
            );

DESCRIBE users;
DESCRIBE messages;

SELECT	u.id
		,u.last_name
        ,u.first_name
FROM	users AS u LIMIT 5;
        
--

SELECT	COUNT(m.from_user_id) AS sent_total
		,u.last_name
        ,u.first_name
FROM	users AS u
			INNER JOIN messages AS m 
				ON u.id = m.from_user_id 
GROUP BY m.from_user_id 
		,u.last_name
        ,u.first_name
ORDER BY   sent_total DESC      
;


-- UNION, MINUS, INTERSECT

SELECT user_id, friend_id FROM friendship WHERE user_id = 6;

DESCRIBE friendship;

SELECT  COUNT(user_id)
		,user_id
        ,friend_id
FROM	friendship
GROUP BY user_id
        ,friend_id
;


SELECT user_id, friend_id FROM friendship; 


SELECT CAST((RAND() * 100) AS UNSIGNED);

HELP CAST;

/*
user_id	int unsigned	NO	PRI		
friend_id	int unsigned	NO	PRI		
friendship_status_id	int unsigned	NO	MUL		
requested_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED
confirmed_at	datetime	YES			
created_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED
updated_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED on update CURRENT_TIMESTAMP
*/

INSERT INTO friendship (user_id, friend_id, friendship_status_id)
VALUES ( (SELECT CAST((RAND() * 100) AS UNSIGNED)), (SELECT CAST((RAND() * 100) AS UNSIGNED)), (SELECT CAST(((RAND() * 100) DIV 3) AS UNSIGNED) ));
