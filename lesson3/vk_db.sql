
-- Создание БД для социальной сети ВКонтакте
-- https://vk.com/geekbrainsru


USE mysql;


-- Пересоздаём БД
DROP DATABASE vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;

-- Удаляем таблицы
/*
DROP TABLE IF EXISTS entity_types;
DROP TABLE IF EXISTS entity;
DROP TABLE IF EXISTS media_types;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS communities_users;
DROP TABLE IF EXISTS communities;
DROP TABLE IF EXISTS friendship_statuses;
DROP TABLE IF EXISTS friendship;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS users;
*/

-- Создаём таблицу пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  


ALTER TABLE users
	ADD COLUMN entity_type_id INTEGER UNSIGNED NOT NULL DEFAULT 1;

ALTER TABLE users
	ADD CONSTRAINT FK_users_entity_types FOREIGN KEY (entity_type_id) REFERENCES entity_types(id);
	

-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили"; 

ALTER TABLE profiles
	ADD CONSTRAINT FK_profiles_users FOREIGN KEY (user_id) REFERENCES users(id);

-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  CONSTRAINT FK_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users(id),
  CONSTRAINT FK_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users(id)
) COMMENT "Сообщения";

-- ALTER TABLE messages DROP COLUMN entity_type_id;

ALTER TABLE messages
	ADD COLUMN entity_type_id INTEGER UNSIGNED NOT NULL DEFAULT 2;
        
ALTER TABLE users
	ADD CONSTRAINT FK_messages_entity_types FOREIGN KEY (entity_type_id) REFERENCES entity_types(id);

INSERT INTO messages(from_user_id, to_user_id, body, is_important, is_delivered)
VALUES ( RAND()*100+1, RAND()*100+1, body, ROUND(RAND()), ROUND(RAND()) );
COMMIT;  


-- Таблица статусов дружеских отношений
CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статусы дружбы";

-- Таблица дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  friendship_status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ",
  CONSTRAINT FK_friendship_users_1 FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT FK_friendship_users_2 FOREIGN KEY (friend_id) REFERENCES users(id),
  CONSTRAINT FK_friendship_friendship_statuses FOREIGN KEY (friendship_status_id) REFERENCES friendship_statuses(id)
) COMMENT "Таблица дружбы";

-- Таблица групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

-- Создаем вторичные ключи для таблицы communities_users
ALTER TABLE communities_users 
	ADD CONSTRAINT FK_communities_users_users FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE communities_users 
	ADD CONSTRAINT FK_communities_users_comunities FOREIGN KEY (community_id) REFERENCES communities(id);


-- Таблица типов медиафайлов
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

-- Таблица медиафайлов
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";

-- ALTER TABLE media DROP COLUMN entity_type_id;
ALTER TABLE media
	ADD COLUMN entity_type_id INTEGER UNSIGNED NOT NULL DEFAULT 3;

ALTER TABLE media
	ADD CONSTRAINT FK_media_entity_types FOREIGN KEY (entity_type_id) REFERENCES entity_types(id);
    


-- Создаем вторичные ключи для таблицы media
ALTER TABLE media
	ADD CONSTRAINT FK_media_users FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE media
	ADD CONSTRAINT FK_media_media_types FOREIGN KEY (media_type_id) REFERENCES media_types(id);
    


-- Таблица типов сущностей (
CREATE TABLE entity_types (
	id	INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор типа сущности",
	name	varchar(255) NOT NULL UNIQUE COMMENT "Название типа",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT = "Типы сущностей";


CREATE TABLE entity (
-- 	id	INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор записи",
        entity_id INT UNSIGNED NOT NULL COMMENT "Идентификатор сущности",
        entity_type_id INT UNSIGNED NOT NULL COMMENT "Идентификатор типа сущности entity_types id",
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания записи",
		updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
        created_by INTEGER UNSIGNED NOT NULL COMMENT "Идентификатор автора",
        PRIMARY KEY PK_entity (entity_id, entity_type_id, created_at),
        FOREIGN KEY FK_entity_entity_types (entity_type_id) REFERENCES entity_types(id),
        FOREIGN KEY FK_entity_users (created_by) REFERENCES users(id)
) COMMENT = "Сущности";


-- Заполняем таблицу users сгенерированными случайными данными 

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'Walker', 'Welch', 'cole.johnnie@example.org', '111-074-0667', '2005-06-18 07:44:00', '1973-12-27 20:34:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'Alexane', 'Dooley', 'ari.trantow@example.com', '(491)819-4378', '1976-09-03 07:27:59', '2004-03-05 01:04:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'Neha', 'McGlynn', 'kasandra.cummerata@example.com', '1-794-127-8762x42274', '2017-01-19 17:42:05', '1971-07-26 01:41:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'Reed', 'Jones', 'whuel@example.com', '1-198-427-7280', '2011-09-05 22:11:17', '1975-01-21 11:08:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'Adrain', 'Daugherty', 'bwillms@example.org', '1-482-473-2653', '1979-12-16 11:25:59', '2003-01-03 07:43:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'Tomasa', 'Rath', 'christiansen.brannon@example.org', '1-957-400-5889x1138', '2006-08-23 01:43:53', '1979-08-26 02:09:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'Zackary', 'Macejkovic', 'imogene72@example.net', '(762)225-2352x4309', '2008-02-08 15:56:11', '1982-07-17 23:08:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (8, 'Raphaelle', 'Hyatt', 'ybosco@example.com', '445-054-7163', '2001-11-28 13:45:46', '1994-02-12 06:18:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (9, 'Juwan', 'Carroll', 'qswaniawski@example.com', '1-419-217-3647', '1989-10-09 12:26:56', '1970-07-26 21:37:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (10, 'Jaeden', 'Kreiger', 'alisha.jacobi@example.com', '+44(5)5867895080', '1977-11-24 15:52:41', '1970-10-17 23:21:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (11, 'Rachel', 'Nader', 'forest.runolfsson@example.com', '(962)570-7557x3896', '1978-10-08 03:41:37', '1973-08-05 12:42:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (12, 'Ines', 'Walter', 'iconroy@example.net', '586.503.5031', '2016-11-28 07:49:26', '1991-10-27 20:39:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (13, 'Norbert', 'Hegmann', 'elisabeth.reilly@example.com', '688-379-9760', '2008-01-05 03:21:50', '1976-01-19 15:28:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (14, 'Krista', 'Quigley', 'cindy.schamberger@example.net', '(078)187-4906', '2012-08-27 10:11:15', '2014-10-07 09:23:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (15, 'Adalberto', 'Schowalter', 'lynch.marcellus@example.org', '+73(6)3708868327', '2008-06-01 18:28:54', '1997-10-15 16:23:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (16, 'Seamus', 'Keeling', 'legros.erica@example.com', '(502)947-2813', '2006-07-22 17:12:34', '1986-12-16 09:53:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (17, 'Lou', 'Schimmel', 'reagan75@example.org', '064.480.4031', '1990-10-25 03:10:38', '1977-05-01 13:03:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (18, 'Emma', 'Lakin', 'greta60@example.com', '+61(7)1912998877', '1987-07-24 19:45:33', '1972-05-07 10:27:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (19, 'Rodrick', 'Hahn', 'nader.berneice@example.org', '(615)189-6436', '1976-10-20 17:08:44', '2007-11-10 16:23:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (20, 'Lia', 'Runolfsson', 'merle.zieme@example.com', '004.275.1726x6899', '1972-01-25 07:48:59', '2008-07-07 17:55:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (21, 'Elias', 'Bauch', 'harber.lynn@example.net', '229-864-9826', '1990-01-12 11:07:39', '2000-02-21 04:45:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (22, 'Tristin', 'Hayes', 'towne.lea@example.com', '072.598.3311x937', '1981-05-27 14:53:49', '1995-08-22 01:59:44');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (23, 'Vincenza', 'Donnelly', 'adaline.kuphal@example.org', '1-604-816-9253x46878', '1988-06-15 04:59:22', '2007-01-25 20:06:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (24, 'Wilford', 'Toy', 'eaufderhar@example.org', '+77(2)9910731091', '2007-12-05 23:28:09', '1985-08-25 21:56:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (25, 'Audra', 'Anderson', 'pschowalter@example.net', '+95(8)8078199775', '1970-07-25 18:06:35', '1999-06-13 20:30:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (26, 'Jamaal', 'Feil', 'darrin.beahan@example.com', '048-955-8432', '2008-03-21 23:18:53', '2013-03-09 21:09:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (27, 'Erik', 'Swift', 'shanahan.estelle@example.net', '491.528.7357', '2006-05-07 22:52:50', '1972-11-22 21:29:50');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (28, 'Jeramie', 'Bins', 'ara61@example.org', '736-767-4961x800', '1982-08-29 03:09:23', '1997-05-05 07:44:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (29, 'Tomasa', 'Hudson', 'bschaden@example.org', '1-619-439-4099x748', '2013-09-27 15:12:05', '1995-04-23 21:19:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (30, 'Junius', 'Hahn', 'aida06@example.org', '1-295-552-0725x9375', '2002-11-01 14:50:38', '1973-10-16 00:32:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (31, 'Skyla', 'Kiehn', 'consuelo.koepp@example.net', '02346837920', '1999-03-31 01:54:10', '1994-03-12 06:48:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (32, 'Leora', 'Flatley', 'joe.kautzer@example.net', '328.969.7994x17251', '1976-03-01 01:58:10', '1975-07-13 14:34:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (33, 'Isom', 'Buckridge', 'bhilpert@example.net', '310.013.4249x262', '1972-10-29 20:19:11', '2015-01-16 15:13:24');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (34, 'Adolphus', 'Schuster', 'xerdman@example.org', '118-877-5504x3017', '2006-11-20 21:00:37', '1995-09-16 13:01:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (35, 'Antonia', 'Cartwright', 'leola93@example.org', '397.223.1415x8307', '2016-06-04 05:09:30', '1980-05-06 12:29:53');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (36, 'Elwyn', 'Christiansen', 'bogisich.ward@example.net', '(179)424-7165x9186', '1987-09-12 05:38:37', '1992-04-06 08:26:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (37, 'Aurore', 'McKenzie', 'esteban.feest@example.org', '(657)014-1149x5752', '2008-09-21 01:59:02', '1976-04-15 11:29:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (38, 'Carlee', 'Trantow', 'friesen.audrey@example.com', '1-916-861-4956x70149', '1979-02-14 23:36:39', '2003-09-25 20:25:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (39, 'Hanna', 'Mills', 'lwolf@example.org', '(935)865-8724x852', '1987-01-13 01:46:28', '1993-02-23 09:37:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (40, 'Katrina', 'Jaskolski', 'eo\'reilly@example.net', '(432)810-4358x685', '1981-07-31 23:51:49', '1979-01-17 07:22:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (41, 'Aiden', 'Monahan', 'pquigley@example.com', '(851)305-3959x86422', '2018-06-01 05:53:12', '2007-04-06 00:27:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (42, 'Gerardo', 'Renner', 'elakin@example.com', '1-936-455-0231x882', '2004-12-28 04:44:53', '2006-04-21 20:44:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (43, 'Matt', 'Borer', 'chase48@example.org', '170.905.4004', '2004-10-26 00:19:24', '1986-07-23 14:01:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (44, 'Kennith', 'Rice', 'ugibson@example.com', '(649)633-9727x88821', '1979-12-20 20:20:12', '1980-04-03 05:58:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (45, 'Shyanne', 'Konopelski', 'pollich.max@example.com', '499-655-5664', '1981-04-25 19:53:03', '1999-07-28 03:41:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (46, 'Elvis', 'Cummings', 'coleman.kuhn@example.net', '988.572.6421', '2014-07-08 12:52:37', '2012-06-21 21:51:50');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (47, 'Consuelo', 'Rath', 'merl.harvey@example.net', '1-001-112-5182x114', '1993-11-01 20:25:33', '2017-12-31 21:53:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (48, 'Melvina', 'Kihn', 'carolanne.effertz@example.com', '884-937-7179', '1992-09-10 05:23:56', '2004-04-03 03:44:00');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (49, 'Orin', 'Bayer', 'csmitham@example.net', '933.665.3115', '1994-10-31 15:42:55', '1975-02-01 18:06:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (50, 'Korey', 'Metz', 'mcglynn.ariel@example.org', '1-778-326-5014x09927', '1974-08-17 19:27:16', '1978-08-24 03:25:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (51, 'Zoila', 'Davis', 'magnus07@example.net', '(055)625-2211x4804', '2020-12-17 22:38:08', '1997-07-18 01:45:17');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (52, 'Anna', 'Keebler', 'demetrius29@example.com', '1-822-118-1674x3744', '2019-10-01 19:23:33', '1976-08-19 15:52:37');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (53, 'Hailie', 'Ondricka', 'cronin.aniyah@example.com', '1-861-752-6100x729', '1989-09-13 14:54:09', '1971-06-01 19:55:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (54, 'Shirley', 'Runolfsdottir', 'jimmie.bradtke@example.org', '344-278-8484', '2008-04-12 03:13:30', '1983-01-01 21:45:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (55, 'Deontae', 'Armstrong', 'iokuneva@example.com', '1-263-481-6640x631', '2015-01-29 23:00:41', '1978-04-10 19:03:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (56, 'Arnold', 'Vandervort', 'clark.franecki@example.org', '09119729062', '1993-05-03 15:01:01', '2006-02-10 10:20:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (57, 'Brenda', 'Crona', 'yvonne40@example.com', '406-233-0534x704', '2020-09-17 02:46:14', '2009-01-27 01:13:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (58, 'Shaina', 'Bergstrom', 'erika.kautzer@example.org', '(975)394-8716', '1982-08-09 20:18:27', '1978-10-28 10:35:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (59, 'Connie', 'Maggio', 'waters.emery@example.com', '158-304-7912x07506', '2005-06-16 17:12:51', '1989-11-16 03:32:17');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (60, 'Delbert', 'Kovacek', 'alessandra21@example.net', '1-806-157-7728', '1976-05-22 18:42:26', '1994-04-21 17:41:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (61, 'Jaeden', 'O\'Keefe', 'runte.shaniya@example.net', '602-172-2117', '1974-08-02 05:40:48', '1975-09-22 22:19:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (62, 'Lon', 'Abbott', 'ykuhic@example.org', '(536)738-4560x7691', '2001-05-27 01:45:27', '1990-06-28 17:23:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (63, 'Trycia', 'Abernathy', 'bsmitham@example.net', '021-653-6642', '1980-09-29 09:34:12', '1971-11-25 03:41:00');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (64, 'Emil', 'Reichel', 'wfadel@example.com', '333-027-2520x476', '1983-07-05 00:03:01', '1973-08-26 02:54:46');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (65, 'Ines', 'Johnston', 'leslie40@example.net', '+65(5)4824958213', '1996-11-21 07:32:11', '1974-02-17 19:03:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (66, 'Omari', 'Swaniawski', 'kertzmann.chet@example.org', '(824)054-5052', '1996-12-23 08:59:51', '1992-10-30 03:23:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (67, 'Alessandra', 'Dooley', 'reynold.larson@example.org', '00117864359', '1988-08-04 12:19:56', '1970-07-24 18:39:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (68, 'Elna', 'Walter', 'nreinger@example.com', '360.965.4785x65206', '1998-03-17 01:42:50', '2006-09-14 02:42:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (69, 'Fannie', 'Greenfelder', 'eugenia.shanahan@example.net', '02921741386', '1979-09-19 06:14:08', '2005-09-08 23:41:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (70, 'Katrine', 'Carter', 'zdaniel@example.org', '1-582-307-2356', '1974-09-22 13:59:46', '2012-12-11 15:19:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (71, 'Megane', 'Beatty', 'cassin.watson@example.org', '(758)706-9608', '1996-07-31 14:01:42', '2007-07-08 13:49:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (72, 'Halie', 'Blick', 'ddenesik@example.net', '821-785-5905', '1978-09-07 17:44:03', '1973-03-22 17:58:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (73, 'Lera', 'Dare', 'trystan05@example.net', '676.282.3435x506', '1997-09-04 06:11:24', '1972-06-12 00:42:55');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (74, 'Roberto', 'Gaylord', 'ehaag@example.org', '1-917-249-1310x346', '2012-04-23 10:31:56', '1983-02-28 11:18:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (75, 'Audra', 'Mueller', 'mattie54@example.com', '162.651.3451', '2013-03-11 10:47:41', '1994-03-24 13:31:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (76, 'Joanne', 'Moen', 'pwisoky@example.net', '1-428-593-6116x728', '1991-12-26 10:06:16', '2006-08-15 21:00:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (77, 'Blaise', 'West', 'marlon32@example.org', '+85(2)5166442410', '2004-04-30 02:51:16', '2008-05-05 01:43:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (78, 'Newell', 'Spinka', 'charles.ruecker@example.org', '031.213.7144x50282', '2003-03-13 18:35:21', '1995-06-08 11:52:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (79, 'Frederique', 'Weissnat', 'larmstrong@example.org', '(221)591-9052x04194', '1991-02-25 00:15:15', '1975-10-13 00:13:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (80, 'Theresia', 'Braun', 'esawayn@example.com', '00165188347', '1975-09-08 23:17:52', '1993-03-22 04:35:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (81, 'Myriam', 'Jast', 'icole@example.com', '830.387.6676', '1978-10-14 05:17:17', '1992-02-25 07:15:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (82, 'Misty', 'Predovic', 'hills.keyshawn@example.net', '05209501797', '2009-05-02 01:42:39', '1994-07-14 01:25:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (83, 'Pink', 'Gerhold', 'mraz.luigi@example.net', '1-917-657-8774', '1982-03-22 03:19:29', '2013-08-17 05:52:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (84, 'Lori', 'Mante', 'fannie.jakubowski@example.com', '850.098.9961', '1993-01-04 22:02:09', '1989-01-27 21:54:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (85, 'Sienna', 'Feeney', 'cschimmel@example.net', '+93(9)5429653191', '2006-07-07 06:30:01', '2001-04-04 18:12:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (86, 'Grady', 'Nader', 'effertz.nickolas@example.org', '+73(6)6529742578', '1978-12-12 11:48:57', '2011-11-06 18:12:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (87, 'Mariela', 'Collier', 'lizeth.ratke@example.net', '02151561872', '1995-12-25 07:48:42', '1978-07-15 12:50:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (88, 'Beulah', 'Feest', 'matilde38@example.net', '1-689-393-9026', '1978-11-22 16:01:44', '1996-07-28 23:37:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (89, 'Ola', 'Altenwerth', 'hbecker@example.org', '1-817-533-8539x74723', '1973-01-10 08:27:35', '1978-09-04 11:16:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (90, 'Krista', 'McGlynn', 'aniya30@example.com', '+83(0)8718211710', '1983-10-19 01:05:38', '1972-11-04 19:55:48');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (91, 'Herminio', 'Luettgen', 'zeichmann@example.com', '(826)298-8970', '2002-09-05 19:02:21', '2011-05-23 05:17:03');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (92, 'Dante', 'Zemlak', 'arthur.wisoky@example.org', '629.133.6764', '2016-09-04 06:56:14', '2019-05-08 11:35:17');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (93, 'Clint', 'Tremblay', 'xrutherford@example.com', '553-668-8813', '2014-10-22 02:47:26', '1974-11-16 14:30:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (94, 'Roberto', 'Harvey', 'adolf.prohaska@example.com', '05926488472', '2001-04-26 19:10:49', '2020-04-19 14:18:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (95, 'Ian', 'Schinner', 'toby.witting@example.net', '801.662.8285x55518', '1975-01-13 19:53:46', '1992-08-05 01:58:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (96, 'Antoinette', 'Hermann', 'mwalter@example.org', '371.024.7068', '2018-05-31 08:51:32', '2003-01-08 20:19:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (97, 'Jennifer', 'Jerde', 'rolando44@example.net', '677-529-1084', '1992-11-03 08:52:43', '2019-01-03 16:17:38');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (98, 'Eve', 'Emard', 'nedra43@example.com', '1-362-077-9972x062', '2009-12-06 22:48:49', '1996-10-02 15:33:02');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (99, 'Nasir', 'Hickle', 'vella.mills@example.net', '812-571-3320', '1973-09-16 12:16:02', '2006-08-03 16:16:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (100, 'Larue', 'Stiedemann', 'lbecker@example.com', '04843639513', '2013-08-09 08:57:41', '1983-07-02 00:35:30');
COMMIT;


-- Заполняем таблицу profiles сгенерированными случайными данными

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, '', '1999-03-27', 'Lake Malcolmmouth', '994463374', '1997-11-17 00:49:12', '2013-01-23 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, '', '2012-11-09', 'Lake Marcelinaberg', '1398', '2008-08-30 12:27:20', '1997-02-15 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (3, '', '2010-11-11', 'Lockmanview', '52132139', '1994-12-31 08:20:27', '2015-12-31 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (4, '', '2013-01-27', 'East Cassandra', '27200', '1971-01-19 23:18:56', '1983-09-28 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (5, '', '1988-12-06', 'Lake Dameonfurt', '842202', '2017-06-06 09:09:47', '2016-09-10 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (6, '', '1973-04-09', 'New Crystelmouth', '', '2019-05-05 17:40:42', '2001-09-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (7, '', '2016-01-05', 'South Jedland', '3213334', '2013-11-18 20:34:42', '2017-07-07 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (8, '', '2016-05-07', 'Westborough', '55417329', '1994-03-19 23:33:39', '1988-09-29 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (9, '', '1995-03-02', 'Clemensport', '6142499', '1981-10-31 18:02:41', '2020-07-05 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (10, '', '1975-09-14', 'Lake Eric', '', '2005-03-23 19:42:52', '2009-01-11 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (11, '', '2012-06-07', 'Lake Dewaynemouth', '7891646', '1997-03-21 07:39:35', '1991-04-23 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (12, '', '1988-10-31', 'Lake Millerhaven', '4613969', '1986-01-18 03:36:46', '1989-07-21 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (13, '', '2003-01-14', 'North Roxanne', '98933011', '1975-11-03 17:35:36', '1997-01-22 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (14, '', '1973-05-03', 'Labadiefurt', '146086519', '1983-06-07 08:29:18', '1980-10-30 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (15, '', '1983-03-31', 'Satterfieldhaven', '72701929', '1978-06-11 16:28:19', '2011-09-09 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (16, '', '1991-07-02', 'New Gia', '982218997', '1995-10-23 22:18:28', '2011-01-31 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (17, '', '2014-07-29', 'Streichview', '', '2003-12-09 10:45:26', '1987-09-30 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (18, '', '1994-02-10', 'North Reba', '422130', '1978-07-23 15:02:49', '2004-08-11 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (19, '', '1983-02-03', 'Port Joyfort', '18', '1983-05-13 23:44:51', '1979-06-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (20, '', '2010-01-06', 'Olsontown', '615170', '1999-07-02 02:33:57', '1999-04-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (21, '', '2007-01-12', 'West Fordberg', '4983', '2005-06-18 10:46:41', '1981-08-26 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (22, '', '2016-09-14', 'Collinsland', '249329476', '1970-02-02 22:32:32', '1973-01-03 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (23, '', '1989-02-13', 'East Roselyntown', '1318', '1988-10-21 08:30:45', '1979-02-24 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (24, '', '1972-05-08', 'Kundeland', '47', '2009-08-02 00:20:53', '1998-01-04 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (25, '', '1979-11-29', 'East Margueritetown', '9768', '2016-10-02 15:09:50', '1972-05-26 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (26, '', '1986-08-28', 'Port Pearl', '11100', '1998-07-22 05:14:44', '1977-11-27 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (27, '', '2018-05-25', 'Harmonychester', '', '1980-04-27 21:01:13', '2020-01-14 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (28, '', '2006-10-18', 'Port Emely', '62673318', '1973-10-30 06:23:58', '2020-10-16 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (29, '', '1992-10-08', 'Ginashire', '', '1985-08-12 19:36:49', '2009-07-26 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (30, '', '2000-12-24', 'East Clara', '15', '1978-08-12 14:42:00', '1976-12-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (31, '', '2001-05-03', 'West Sydnie', '7', '2019-11-21 01:18:35', '2013-10-21 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (32, '', '1992-03-09', 'Manuelshire', '6', '1984-10-30 17:29:32', '1999-09-12 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (33, '', '1970-03-11', 'Friedamouth', '38191', '2004-05-02 17:38:29', '1987-04-01 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (34, '', '2001-12-07', 'New Kaitlynland', '2205', '1984-01-10 21:57:03', '2012-03-13 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (35, '', '2001-08-17', 'Runolfssonshire', '558506', '2009-09-17 02:59:36', '2008-07-27 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (36, '', '1993-10-23', 'Mrazbury', '', '2015-04-20 08:14:44', '1976-08-04 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (37, '', '2017-05-11', 'Antoinetteton', '504', '1976-07-03 18:52:55', '2008-05-17 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (38, '', '2010-11-14', 'Lake Idellachester', '670719', '1988-02-09 19:25:09', '1987-10-14 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (39, '', '1971-10-04', 'Pagacville', '318349', '2004-05-03 20:55:57', '1971-07-02 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (40, '', '2017-10-07', 'South Jacynthe', '7', '2009-07-17 02:52:09', '1999-10-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (41, '', '2017-01-11', 'Spinkamouth', '', '1991-04-17 14:32:10', '1987-12-29 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (42, '', '1995-01-09', 'Kuhnside', '147', '2005-11-12 04:22:52', '1984-07-15 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (43, '', '2010-07-19', 'North Bridgettechester', '2105', '1989-07-11 03:40:55', '2015-03-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (44, '', '1991-09-27', 'Lake Abbyton', '84177', '2005-08-10 08:07:30', '1994-03-01 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (45, '', '1997-07-26', 'Boganland', '565', '1979-10-25 04:43:44', '2010-10-15 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (46, '', '1986-03-05', 'East Brayan', '2', '1970-10-16 11:29:23', '1989-12-17 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (47, '', '1988-03-22', 'Lueilwitzville', '2', '1976-10-18 19:29:07', '1991-06-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (48, '', '2003-11-04', 'Boscochester', '31292530', '1992-02-13 05:30:29', '1994-04-21 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (49, '', '1991-11-02', 'Scarlettville', '35', '2019-04-27 08:11:10', '1989-07-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (50, '', '1977-11-19', 'South Betty', '666838', '1973-10-16 02:18:32', '1988-12-06 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (51, '', '2019-09-28', 'Lake Beverlyport', '59563148', '1970-03-17 03:17:35', '2017-01-30 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (52, '', '1980-08-03', 'Collinsstad', '3435389', '2005-01-05 11:36:17', '1999-01-29 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (53, '', '1989-07-09', 'East Idella', '', '2012-02-17 19:03:50', '2009-05-26 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (54, '', '1979-12-11', 'South Evelinebury', '8', '1985-01-19 20:11:32', '1985-03-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (55, '', '1986-08-24', 'Reichelport', '51', '1976-08-13 03:11:41', '1990-04-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (56, '', '1982-08-01', 'North Bartonhaven', '38000', '1989-10-04 21:07:00', '1999-10-16 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (57, '', '1976-01-28', 'Feilchester', '62414', '2016-03-02 10:14:38', '2002-04-29 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (58, '', '1993-06-24', 'South Albury', '411488', '1989-09-23 01:21:27', '2011-12-27 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (59, '', '1978-09-26', 'West Brandymouth', '93350102', '2013-07-26 03:03:42', '2017-01-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (60, '', '2011-01-08', 'Monahanburgh', '7449055', '1991-11-25 20:47:24', '2013-10-14 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (61, '', '2013-08-04', 'New Rahsaanbury', '31913583', '1993-07-27 22:12:28', '2001-03-12 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (62, '', '1971-11-26', 'South Johann', '51998', '2013-01-26 22:40:18', '1991-08-28 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (63, '', '1993-03-16', 'West Albin', '2', '2018-08-02 22:54:29', '1999-12-04 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (64, '', '1987-09-27', 'South Tellybury', '174', '1973-08-06 21:53:47', '2017-10-19 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (65, '', '1974-07-15', 'West Jan', '33762', '2018-03-31 23:43:40', '1983-06-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (66, '', '2002-01-26', 'New Drewport', '275833', '1987-09-16 17:58:13', '2014-03-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (67, '', '2005-07-07', 'Port Robert', '', '1977-03-30 09:06:42', '1995-10-28 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (68, '', '2019-08-26', 'East Charles', '34', '1978-09-25 03:10:06', '1981-07-31 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (69, '', '1998-01-30', 'West Brayan', '5760', '1982-05-09 02:32:48', '2010-09-22 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (70, '', '1987-04-15', 'Hahnland', '660', '2008-04-08 01:42:02', '1973-12-30 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (71, '', '1974-03-29', 'Klingville', '89974318', '1992-10-02 21:12:58', '2016-08-28 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (72, '', '2006-09-28', 'South Conrad', '7', '1987-02-04 05:34:48', '1985-05-14 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (73, '', '1976-06-23', 'North Dan', '', '2009-07-16 00:41:04', '1992-04-15 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (74, '', '1970-02-02', 'Port Burleyville', '25', '2018-08-18 11:39:12', '2018-01-01 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (75, '', '2020-02-20', 'Schultzview', '289', '2011-10-09 19:24:46', '2017-01-26 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (76, '', '1992-04-28', 'Lake Bernitaport', '683236', '1990-08-07 05:41:47', '1978-07-09 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (77, '', '2004-01-18', 'Margotburgh', '', '1970-03-22 01:53:22', '1993-01-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (78, '', '2014-10-19', 'New Mellie', '785589378', '1973-11-21 10:39:48', '2018-03-03 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (79, '', '1989-12-10', 'East Eldon', '31430', '2020-01-19 17:58:05', '1978-09-18 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (80, '', '1975-12-26', 'New Justynberg', '237305391', '1988-04-02 16:36:39', '1972-07-28 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (81, '', '2005-09-30', 'Hartmannfurt', '763', '2021-01-20 08:19:40', '2011-06-02 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (82, '', '1987-02-06', 'Port Estrella', '7722968', '1993-05-21 04:09:59', '2015-07-09 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (83, '', '2006-01-06', 'West Donniebury', '533', '1983-02-06 12:34:01', '1981-03-24 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (84, '', '2021-02-11', 'South Priscillaside', '75576', '1997-10-11 03:37:13', '2020-08-27 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (85, '', '2001-07-21', 'Jaskolskimouth', '253', '1999-03-24 14:47:38', '2013-06-22 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (86, '', '2005-12-17', 'Callieton', '586575', '2017-09-19 05:12:24', '1973-03-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (87, '', '2007-10-16', 'North Nikoland', '1373', '2007-08-14 20:37:37', '1991-03-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (88, '', '1972-01-01', 'North Leilaville', '4130489', '2008-11-02 04:45:40', '1985-10-14 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (89, '', '2020-08-23', 'Bonniebury', '693937', '1989-08-09 18:28:33', '2003-08-06 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (90, '', '2013-01-02', 'Brannonmouth', '9266119', '1991-09-27 15:59:39', '2010-04-23 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (91, '', '1971-05-08', 'West Aaronborough', '', '1992-04-12 13:38:52', '2016-03-20 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (92, '', '2017-01-27', 'Kylertown', '22488', '2009-08-06 07:47:40', '1994-06-10 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (93, '', '2020-01-26', 'Ferminfurt', '5449', '1989-11-28 00:16:33', '1972-10-17 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (94, '', '2014-06-19', 'Cristinaburgh', '', '1974-04-22 06:48:21', '2014-02-11 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (95, '', '1971-08-10', 'Margaritaside', '91916', '1970-09-02 18:05:06', '2000-08-25 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (96, '', '1987-10-22', 'West Johnniefurt', '6076', '2004-12-09 02:21:44', '1980-01-08 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (97, '', '1973-07-29', 'Mariettatown', '74', '1997-11-20 21:55:48', '2008-04-04 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (98, '', '2006-01-22', 'Feestton', '247', '2003-07-24 21:43:28', '2002-04-06 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (99, '', '2017-03-24', 'North Joelburgh', '1094346', '1986-07-22 19:27:07', '1991-09-04 00:00:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (100, '', '2018-01-25', 'North Phyllisberg', '', '2002-04-16 11:00:23', '1988-09-12 00:00:00');
COMMIT;

-- Приводим данные в таблицах users и profiles в соответствие со здравым смыслом

USE vk;

UPDATE 	users
SET		created_at = updated_at
WHERE	updated_at < created_at;
  
COMMIT;

UPDATE 	profiles
SET		created_at = updated_at
WHERE	updated_at < created_at;
  
COMMIT;

  
-- Заполняем таблицу friendship_statuses

INSERT INTO `friendship_statuses` (`name`, `created_at`, `updated_at`) VALUES ('Запрос установление статуса', '1993-05-05 03:00:34', '2021-01-25 23:10:51');
INSERT INTO `friendship_statuses` (`name`, `created_at`, `updated_at`) VALUES ('Запрос подтвержден', '1993-05-05 03:00:34', '2021-01-25 23:10:51');
INSERT INTO `friendship_statuses` (`name`, `created_at`, `updated_at`) VALUES ('Запрос отклонен', '1993-05-05 03:00:34', '2021-01-25 23:10:51');
COMMIT;

 
-- Заполняем таблицу friendship

USE vk;

INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (6, 6, 2, '1998-05-12 10:37:48', '1999-05-29 20:31:33', '1988-04-22 19:16:40', '1976-10-14 03:14:39');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (10, 10, 3, '2015-08-24 04:31:25', '1993-02-14 00:04:47', '2018-09-05 18:40:38', '1971-11-23 10:53:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (11, 11, 3, '1986-11-28 11:06:14', '2017-12-19 10:09:12', '2008-07-16 16:24:38', '1975-05-09 20:21:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (13, 13, 1, '1972-05-11 00:05:38', '2017-11-01 16:38:28', '1978-04-27 22:46:52', '1985-09-29 23:16:46');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (14, 14, 1, '1994-12-10 06:16:46', '2008-10-28 06:11:23', '1997-06-29 11:17:30', '2006-08-07 00:22:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (15, 15, 3, '2014-10-01 13:17:44', '2009-01-18 21:55:58', '2001-07-28 17:27:05', '2020-07-15 20:52:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (21, 21, 1, '2016-07-16 13:56:19', '2007-10-02 16:06:25', '2007-09-07 16:32:32', '1996-07-21 15:11:44');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (26, 26, 1, '1994-10-05 15:58:56', '1991-04-02 02:11:30', '2015-08-09 18:35:21', '1996-05-23 02:26:19');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (27, 27, 1, '1997-11-05 09:04:58', '1974-03-29 23:58:47', '2005-09-16 06:32:43', '1986-10-26 20:07:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (28, 28, 1, '1984-01-16 21:08:41', '2019-01-06 18:25:15', '1973-01-26 03:55:34', '1982-05-19 03:46:29');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (30, 30, 1, '2001-10-18 10:20:30', '1992-11-10 03:26:33', '1974-01-14 05:27:44', '2007-08-21 00:57:19');
COMMIT;


-- Заполняем таблицу communities

USE vk;
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'Путешествия', '1986-12-22 08:50:56', '2020-08-30 06:33:49');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'Программисты', '2019-02-15 11:50:13', '1987-02-03 20:19:48');
INSERT INTO `communities` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'Активный отдых', '2001-03-05 17:54:41', '2013-05-09 19:11:03');
COMMIT;


-- Заполняем таблицу communities_users


INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 39, '1996-11-11 09:37:34');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 4, '1992-07-08 00:44:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 7, '2005-12-17 19:05:56');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 10, '1996-12-12 20:03:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 13, '1986-03-23 10:53:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 46, '2013-08-27 05:48:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 19, '1982-07-26 04:31:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 92, '1996-10-01 09:40:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 25, '2008-03-09 23:40:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 2, '1976-12-06 22:57:35');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 5, '2020-08-08 06:49:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 8, '2008-01-29 02:26:34');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 93, '1987-02-08 20:24:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 14, '1971-03-10 02:21:17');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 17, '1998-03-24 03:13:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 62, '1981-11-04 04:07:56');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 43, '1982-04-10 14:46:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 3, '2000-08-11 19:58:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 6, '2005-05-24 23:17:17');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 9, '1979-06-03 12:21:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 70, '1986-07-09 20:50:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 75, '2004-12-09 16:46:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 18, '1975-03-15 22:46:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 61, '2017-06-30 19:52:32');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 24, '2017-02-05 22:50:03');
COMMIT;


-- заполняем таблицу media_types

INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'jpg', '1976-09-27 07:40:33', '2001-10-15 10:32:33');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'mp3', '1984-07-03 17:27:10', '1973-11-16 22:22:40');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'mp4', '2019-08-13 13:11:25', '2017-01-04 18:22:49');
COMMIT;

-- Заполняем таблицу media

INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (1, 10, 'dolore', 681916, NULL, 1, '2004-06-16 17:59:29', '2011-03-25 02:09:47');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (2, 2, 'porro', 4079, NULL, 2, '1977-11-20 17:43:09', '1989-01-05 19:53:35');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (3, 3, 'sit', 969513, NULL, 3, '2012-02-19 01:24:47', '1983-12-14 02:08:49');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (4, 31, 'non', 378796, NULL, 1, '2014-06-15 11:51:58', '1998-05-06 04:09:57');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (5, 22, 'iste', 804094, NULL, 2, '2021-04-02 09:22:04', '1972-04-26 19:12:26');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (6, 61, 'alias', 8, NULL, 3, '1971-11-16 21:51:40', '1979-02-09 12:01:29');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (7, 7, 'non', 9, NULL, 1, '1972-07-24 15:26:44', '1993-06-30 21:19:55');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (8, 71, 'maxime', 53, NULL, 2, '1991-07-19 21:54:00', '1980-10-25 10:04:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (9, 9, 'aut', 949, NULL, 3, '1995-09-28 15:14:02', '1981-02-25 03:02:00');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (10, 10, 'molestiae', 9371939, NULL, 1, '1994-10-23 03:22:36', '2012-11-08 15:43:48');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (11, 11, 'et', 0, NULL, 2, '2008-02-28 08:49:27', '2002-06-28 23:27:42');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (12, 29, 'ea', 35397, NULL, 3, '2006-02-22 09:04:27', '2017-04-18 17:49:00');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (13, 42, 'est', 540583, NULL, 1, '2020-11-09 23:20:59', '2002-12-25 19:19:43');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (14, 54, 'excepturi', 8, NULL, 2, '1976-09-08 14:59:48', '2009-03-13 17:40:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (15, 15, 'dignissimos', 0, NULL, 3, '1978-11-09 21:22:57', '1981-07-15 23:53:55');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (16, 16, 'voluptas', 89909, NULL, 1, '2020-04-29 21:44:14', '1991-02-22 11:09:07');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (17, 17, 'ullam', 89216413, NULL, 2, '2017-11-24 01:11:40', '1974-10-20 11:29:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (18, 18, 'libero', 888, NULL, 3, '1988-03-02 12:30:41', '1975-04-25 03:00:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (19, 19, 'aspernatur', 705, NULL, 1, '1988-08-04 13:46:08', '1986-09-06 18:36:25');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (20, 60, 'et', 978951933, NULL, 2, '2013-01-21 06:21:44', '1998-02-20 04:49:59');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (21, 79, 'nam', 99405, NULL, 3, '2013-02-09 15:20:13', '1995-03-19 18:01:48');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (22, 14, 'dolorum', 31, NULL, 1, '2003-09-10 12:52:53', '2005-02-01 18:32:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (23, 23, 'voluptas', 522294609, NULL, 2, '1988-03-19 08:55:54', '2009-10-17 23:07:37');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (24, 14, 'ut', 0, NULL, 3, '2006-07-24 22:31:08', '1980-07-13 19:22:35');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (25, 5, 'rerum', 1509, NULL, 1, '1987-02-15 19:05:12', '1970-04-01 14:30:26');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (26, 16, 'soluta', 110063, NULL, 2, '1997-02-19 11:05:12', '1993-09-07 13:42:03');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (27, 21, 'explicabo', 74, NULL, 3, '2002-07-31 16:50:03', '1998-09-22 05:56:43');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (28, 88, 'soluta', 0, NULL, 1, '1987-08-21 14:28:07', '1974-11-13 01:22:47');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (29, 79, 'aut', 7750088, NULL, 2, '1976-06-01 18:23:30', '1977-06-28 20:13:39');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (30, 30, 'earum', 3965414, NULL, 3, '1991-08-19 02:29:56', '1981-07-04 13:08:11');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (31, 31, 'occaecati', 74442051, NULL, 1, '1972-11-21 21:02:20', '1992-02-17 19:05:16');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (32, 32, 'maiores', 582679, NULL, 2, '2009-04-28 15:57:15', '1981-06-20 20:46:09');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (33, 33, 'dicta', 21838637, NULL, 3, '2002-12-15 04:30:34', '2014-01-02 21:18:24');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (34, 24, 'nemo', 605646, NULL, 1, '1971-06-09 15:46:26', '1999-11-22 04:16:56');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (35, 35, 'repellendus', 26572432, NULL, 2, '1988-03-04 15:50:34', '2014-06-09 13:34:10');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (36, 66, 'provident', 84655, NULL, 3, '1983-07-22 22:19:00', '2020-03-25 00:58:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (37, 37, 'molestias', 2722701, NULL, 1, '2009-08-07 19:49:42', '1998-02-05 08:58:34');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (38, 78, 'officiis', 8232, NULL, 2, '2001-03-26 03:25:33', '2003-02-20 18:32:12');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (39, 39, 'nisi', 70, NULL, 3, '1982-11-01 03:59:35', '1991-03-09 07:48:48');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (40, 90, 'et', 8393, NULL, 1, '1979-05-03 14:40:16', '1981-03-17 15:40:36');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (41, 41, 'voluptas', 574897, NULL, 2, '1981-02-22 05:32:05', '1970-04-18 22:07:25');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (42, 42, 'vitae', 772, NULL, 3, '2007-03-06 11:07:56', '2006-05-24 19:31:51');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (43, 33, 'qui', 6, NULL, 1, '1987-07-27 12:27:10', '1992-10-07 02:33:37');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (44, 44, 'consequatur', 9417794, NULL, 2, '2002-04-28 00:22:34', '2021-02-05 16:57:38');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (45, 45, 'quasi', 2307546, NULL, 3, '1975-04-17 16:04:12', '1981-01-09 20:08:54');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (46, 18, 'consequatur', 3131, NULL, 1, '1976-05-04 13:10:05', '1980-04-07 05:19:12');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (47, 49, 'impedit', 4, NULL, 2, '1998-11-22 03:21:34', '1972-08-22 12:44:46');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (48, 28, 'odit', 6, NULL, 3, '2015-11-16 05:50:33', '1987-08-31 10:45:59');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (49, 19, 'reprehenderit', 49505, NULL, 1, '1989-10-11 04:27:22', '1989-11-22 01:00:39');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `created_at`, `updated_at`) VALUES (50, 67, 'magni', 7185114, NULL, 2, '2015-06-17 05:15:37', '2001-08-09 01:01:36');
COMMIT;


-- заполняем таблицу messages

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (201, 97, 19, 'Voluptatem atque ut molestiae ea nostrum. Quae consequuntur repudiandae sit veritatis tempora aut accusantium. Ab suscipit quam sapiente architecto ut et.', 0, 0, '1982-07-22 08:27:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (202, 67, 36, 'Esse omnis distinctio aliquam. Sunt ea quam aut quam facilis temporibus accusantium. Est facilis qui sunt enim et corrupti. Nulla quia facilis ea.', 1, 1, '1991-01-07 15:42:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (203, 83, 32, 'Voluptatem non aut et quia cupiditate aut. Consequatur voluptas perspiciatis corrupti. Rerum iste voluptatem rem accusamus. Quo pariatur quasi modi saepe.', 1, 1, '2014-06-04 12:12:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (204, 8, 75, 'Iste iure ex delectus deserunt porro veritatis id. Dolorem vel consequuntur temporibus omnis.', 1, 1, '1994-08-21 19:48:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (205, 26, 61, 'Nihil neque et aspernatur enim. Quod qui voluptatem dolore a rerum in.', 1, 1, '2013-12-10 06:55:58');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (206, 3, 26, 'Cupiditate veniam ullam porro assumenda dolor officia. Ipsam nobis necessitatibus et totam magni. Iusto totam repellendus suscipit dolorem pariatur ab. Consequatur ut sit qui possimus.', 1, 0, '2005-04-24 21:39:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (207, 29, 77, 'Ullam est est est ut cum quo. Rerum quis dignissimos ducimus. Veritatis eius est ducimus rerum deserunt eos dolorem. Nobis sint inventore nostrum ea.', 1, 1, '1984-01-04 19:39:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (208, 83, 82, 'Voluptatem maxime ut perspiciatis tenetur. Repudiandae quasi mollitia repudiandae. Fugit autem itaque ex harum dolorum. Est modi quasi aut sint impedit veritatis sed.', 0, 1, '1971-07-26 22:37:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (209, 38, 59, 'In doloremque sequi corrupti est dolores hic consequatur. Eligendi enim voluptatem aspernatur quis vel qui optio. Aliquid provident aut molestiae id autem ut esse. Ut et porro debitis. Cupiditate sapiente ad sunt placeat.', 0, 1, '1981-05-25 06:09:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (210, 11, 74, 'Quasi voluptas necessitatibus iusto corporis amet dolore voluptatem. Laboriosam nihil occaecati voluptas quod dolores dolorem. Adipisci commodi odio ipsa eligendi perferendis optio eum.', 1, 1, '1985-02-05 17:34:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (211, 30, 13, 'Inventore perspiciatis vel laboriosam placeat voluptatem numquam a. Quia laborum possimus in facere porro. Est ipsa et exercitationem molestias dolorem beatae.', 1, 0, '2003-07-03 09:06:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (212, 42, 91, 'Qui ad velit sed et est. Ut maiores optio est ducimus aut explicabo. Consequatur omnis aut facilis iusto eos modi.', 0, 0, '2000-04-13 00:08:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (213, 99, 26, 'Est quia enim quia eaque nihil fugit. Sit dolores est sunt quis eum autem molestiae. Necessitatibus expedita iusto quod similique et ab. Praesentium dolor dolor perspiciatis consequuntur ratione aut sint officia.', 1, 1, '1979-09-29 18:04:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (214, 78, 19, 'Magnam enim minus accusamus repudiandae voluptatem accusamus. Aut sed molestiae quod et adipisci minus iusto. Natus molestiae mollitia et quos ea in omnis. Autem magni sequi non omnis eum.', 1, 1, '1979-05-27 04:36:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (215, 52, 95, 'Nulla nihil ut aut dolor animi eos et. Sint quia incidunt dolor doloribus debitis ipsum.', 1, 1, '1996-07-08 11:31:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (216, 78, 86, 'Mollitia nostrum qui et unde nam nemo tempora. Quis sit reprehenderit quis et. Blanditiis in sed laboriosam dolorem nemo officia voluptas. Sit minima enim voluptatibus distinctio facere aliquid autem aliquid.', 0, 0, '1971-04-15 13:50:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (217, 43, 92, 'Veniam assumenda ipsam numquam optio optio accusantium. Qui odio expedita itaque et et dolore recusandae.', 0, 0, '1984-04-21 23:16:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (218, 82, 26, 'Deleniti sint aspernatur vero et dolores nam iusto. Voluptates minima incidunt vitae quis rem et. Et earum recusandae natus fugit quas.', 1, 0, '2020-02-15 12:29:26');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (219, 43, 79, 'Et sed iure excepturi ipsum aut. Excepturi quibusdam totam ex nobis rem voluptatum. Enim delectus est in id modi ut veniam. Sit dicta quae laborum aut.', 1, 0, '1983-09-10 09:40:58');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (220, 64, 13, 'Omnis veritatis ut iure. Libero vero rerum dolor debitis. Itaque consequuntur ut at fuga.', 1, 0, '1978-09-06 03:25:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (221, 57, 41, 'Animi rerum odit provident saepe ut. Similique iure iure velit aliquid dolores eligendi nesciunt molestiae. Ipsam repudiandae occaecati amet est qui dicta dolor.', 0, 1, '1972-09-27 22:14:42');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (222, 70, 36, 'Est magnam et at quia accusantium libero et consequatur. Facere atque explicabo qui quia. Est quam tenetur aut voluptates. Officiis esse ut laudantium occaecati ut. Nulla eveniet dolor vel quisquam consequuntur.', 1, 1, '2008-12-02 05:34:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (223, 95, 97, 'Est et culpa quia enim perspiciatis labore recusandae magnam. Sunt pariatur dolor omnis nostrum.', 1, 0, '1991-09-02 12:43:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (224, 26, 17, 'Eaque velit ipsa quia. Hic fuga ullam esse veritatis labore eos in. Quidem cumque porro dolorum optio.', 1, 1, '2012-09-26 17:19:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (225, 73, 15, 'Provident ullam velit explicabo unde consequuntur voluptatum. Deserunt et officia necessitatibus eum aut exercitationem voluptatem. Est maxime cumque dolor repudiandae.', 1, 0, '1986-04-21 01:26:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (226, 37, 18, 'Iste facere repudiandae rerum quaerat et dignissimos. Neque impedit molestiae eius reprehenderit tenetur id molestiae. Quia voluptatem sint amet corrupti. Ut molestiae voluptatem unde error amet nulla magni eius.', 0, 1, '1985-09-01 10:13:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (227, 17, 83, 'Ut tempore accusamus suscipit ut quo aperiam. Pariatur consequatur omnis eum et saepe in magni. Deserunt officiis quibusdam et nostrum rerum animi. Sit in enim alias.', 0, 0, '2012-09-29 22:27:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (228, 16, 50, 'Sed consequatur omnis sequi aut consequatur. At laudantium consequatur in quas in aut. Et culpa dolor rerum fugiat et amet. Dolor voluptatem beatae ad at consectetur sequi.', 1, 0, '2019-02-26 23:34:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (229, 23, 95, 'Aut non molestiae suscipit occaecati doloribus eveniet. Ab aut incidunt tempore totam. Consequatur autem debitis occaecati. Eaque natus eveniet cumque sed at et.', 1, 1, '1986-08-15 14:21:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (230, 84, 25, 'Hic quae eos iure quas unde nemo et et. Repellat aspernatur minus dignissimos accusantium eligendi ut repellat. Consequuntur quam quos nisi quos ratione. Nam officiis facere quo.', 0, 0, '1971-01-12 14:14:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (231, 43, 85, 'Dolores aut voluptate officiis ut rerum non. Qui officiis officia numquam est optio placeat. Qui similique sunt fugit quam unde ipsum velit. Architecto autem et nobis sint dolor sunt.', 1, 1, '1998-11-28 21:59:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (232, 91, 90, 'Voluptates omnis non dignissimos et laborum. Placeat officiis quis rem ut. Rerum velit nam nisi amet dolorum quia.', 0, 1, '1993-10-14 12:55:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (233, 42, 65, 'Adipisci natus soluta aliquam perspiciatis aut. Facilis ut rerum sequi commodi voluptatem. Ipsam aut sint laborum est. Et alias accusamus nemo accusamus ea quam.', 1, 0, '1991-01-30 13:03:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (234, 42, 86, 'Repudiandae modi ex qui aut. Odio nesciunt aut eos amet. Blanditiis distinctio nostrum magni.', 1, 0, '2010-05-13 17:36:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (235, 81, 46, 'Dicta nihil provident eligendi unde ut ab necessitatibus. Dolor omnis ea ad quia dolores corporis repudiandae. Quia laboriosam error dolores enim beatae molestiae. Totam labore esse quia nihil laboriosam.', 0, 0, '1993-01-11 02:59:09');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (236, 98, 34, 'Illum et sint rem omnis. Eum ut quam nisi qui rem id aliquam. Cumque ut accusamus qui repellendus ut aliquid. Aut ut voluptas non ducimus provident aut et aliquid.', 1, 1, '1996-06-26 06:06:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (237, 83, 35, 'Dolore repudiandae error ipsum alias. Atque eligendi expedita nulla quae in. Ipsam animi ut sint perferendis quia consequatur. Dolorum delectus tenetur consequatur. Minus nostrum in quos.', 1, 1, '2006-09-25 18:36:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (238, 77, 15, 'Voluptas sit rem fugiat voluptatibus non aut. Quod eligendi nihil asperiores voluptas. Sunt blanditiis ut hic et et minima debitis et. Sed non voluptatum libero quas iure sed.', 1, 0, '1986-03-29 12:59:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (239, 43, 87, 'Dicta quaerat esse odio praesentium et tempora qui. Quia omnis minima deserunt autem dolorem quibusdam voluptatem. Ipsam quia nobis asperiores qui.', 1, 1, '1972-12-15 04:26:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (240, 41, 45, 'Voluptatem sed facere unde eius ullam nulla. Et distinctio blanditiis qui fuga doloribus ducimus quibusdam minus. Voluptate consectetur eos placeat sunt voluptatem.', 0, 0, '1998-10-11 08:36:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (241, 19, 31, 'Sed veritatis qui expedita. Qui beatae rerum ipsum nulla et. Deleniti illo quasi quaerat nihil earum exercitationem.', 1, 1, '1989-12-14 12:48:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (242, 83, 11, 'Placeat incidunt id aliquid architecto assumenda repellat ea. Qui aut cum sunt pariatur aliquam vel nihil rerum. Totam quod ullam harum expedita eveniet dolore quo. Odit a vero voluptate facilis illum cumque.', 0, 1, '1993-08-20 09:03:03');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (243, 16, 44, 'Quia est amet eaque voluptates qui magnam. Et laboriosam reiciendis vitae dolorem. Magni fuga autem sit.', 1, 0, '1970-09-03 00:52:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (244, 52, 20, 'Magni accusamus ratione voluptates consectetur. Assumenda suscipit laudantium aliquam est et quia non. Molestiae quisquam necessitatibus optio adipisci non rerum dolor saepe. Aut sed voluptate reprehenderit rerum.', 1, 1, '1970-01-28 16:50:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (245, 75, 75, 'Non odit asperiores labore suscipit fuga aut ipsam dolorem. Sint facere id dolore reprehenderit nam soluta. Pariatur maxime quo ipsam veritatis. Necessitatibus aspernatur tempora eveniet architecto dolore excepturi voluptatem.', 0, 0, '2002-11-06 17:45:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (246, 73, 89, 'Architecto quo reiciendis officia odio et consequatur. Perspiciatis soluta quis eius hic eveniet. Et enim dolores tempora corrupti et. Itaque est nobis necessitatibus voluptatem. Ipsa inventore voluptate similique aut a exercitationem.', 1, 1, '1982-10-30 23:05:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (247, 13, 37, 'Voluptas et vitae cupiditate recusandae libero. Iusto enim cumque molestiae pariatur architecto sequi veniam. Blanditiis suscipit doloribus sed molestias et aut illo. Aliquam molestiae alias reprehenderit.', 1, 0, '1990-03-17 15:40:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (248, 90, 2, 'Asperiores ab esse odio harum. Consequuntur beatae numquam omnis delectus et iure aut ut. In sit necessitatibus et unde. Qui odit quaerat voluptatum voluptas consectetur alias.', 0, 1, '1996-09-10 01:43:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (249, 54, 9, 'Consequatur non quia quis reiciendis iure. Tenetur tenetur minus vitae error. Optio et excepturi est natus. Vero et sunt debitis consequatur ipsam aut.', 1, 1, '2007-07-18 05:51:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `is_delivered`, `created_at`) VALUES (250, 82, 63, 'Vel sit hic eum et dolore culpa ducimus. Magnam saepe sit dicta aut sit. Sit expedita sunt occaecati repudiandae sit. Ea quia veritatis est sed qui.', 1, 0, '2007-04-14 21:19:51');
COMMIT;


-- Заполняем entity_types

USE vk;

INSERT INTO `entity_types` (`name`, `created_at`) VALUES ('user', CURRENT_TIMESTAMP);
INSERT INTO `entity_types` (`name`, `created_at`) VALUES ('message', CURRENT_TIMESTAMP);
INSERT INTO `entity_types` (`name`, `created_at`) VALUES ('media', CURRENT_TIMESTAMP);
COMMIT;

-- Заполняем entity
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 13);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (11, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 21);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (10, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (8, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 6);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (15, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 40);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (13, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 83);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (4, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 39);
INSERT INTO `entity` (`entity_id`, `entity_type_id`, `created_at`, `updated_at`, `created_by`) VALUES (5, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 55);
COMMIT;
