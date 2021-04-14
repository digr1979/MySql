
-- Создание БД для социальной сети ВКонтакте
-- https://vk.com/geekbrainsru


USE mysql;


-- Пересоздаём БД
DROP DATABASE vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;


-- Создаём таблицу пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  -- country VARCHAR(50) NOT NULL COMMENT 'Страна',
  -- city VARCHAR(50) NOT NULL COMMENT 'Город',
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  


-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  CONSTRAINT FK_profiles_users FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT "Профили"; 


-- Таблица типов сущностей 
CREATE TABLE entity_types (
	id	INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор типа сущности",
	name	varchar(255) NOT NULL UNIQUE COMMENT "Название типа",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT = "Типы сущностей";


-- Таблица сущностей

CREATE TABLE entity (
-- 	entity_id	INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор сущности",
 	entity_id	INT UNSIGNED NOT NULL COMMENT "Идентификатор сущности",
    entity_type_id INT UNSIGNED NOT NULL COMMENT "Идентификатор типа сущности entity_types id",
    created_by INTEGER UNSIGNED NOT NULL COMMENT "Идентификатор автора",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания записи",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    PRIMARY KEY PK_entity (entity_id, entity_type_id, created_by, created_at),
    FOREIGN KEY FK_entity_entity_types (entity_type_id) REFERENCES entity_types(id),
    FOREIGN KEY FK_entity_users (created_by) REFERENCES users(id)
) COMMENT = "Сущности";

/*
	INSERT INTO `entity` (entity_type_id, created_by) VALUES ( ROUND(RAND()+1), ROUND(RAND()*100) ); 
*/

-- Таблица статусов сообщений
CREATE TABLE message_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Статусы сообщений';    

-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  status_id INT UNSIGNED NOT NULL DEFAULT 1,
  entity_type_id INTEGER UNSIGNED NOT NULL DEFAULT 2,
  -- is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  CONSTRAINT FK_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users(id),
  CONSTRAINT FK_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users(id),
  CONSTRAINT FK_message_statuses_id FOREIGN KEY (status_id) REFERENCES message_statuses(id)
) COMMENT "Сообщения";


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
  principal_id INT UNSIGNED NOT NULL COMMENT 'Создатель-владелец',
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки", 
  CONSTRAINT FK_communities__users FOREIGN KEY (principal_id) REFERENCES users(id)
) COMMENT "Группы";

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ",
  CONSTRAINT FK_communities_users_users FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT FK_communities_users_comunities FOREIGN KEY (community_id) REFERENCES communities(id)
) COMMENT "Участники групп, связь между пользователями и группами";


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
  entity_type_id INT UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Идентификатор типа сущьности',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  CONSTRAINT FK_media_users FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT FK_media_media_types FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  CONSTRAINT FK_media__entity_types FOREIGN KEY (entity_type_id) REFERENCES entity_types(id)
) COMMENT "Медиафайлы";



-- Таблица голосов
CREATE TABLE votes (
	entity_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор элемента',
    created_by INTEGER UNSIGNED NOT NULL COMMENT 'Идентификатор автора',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания записи',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
    is_tumb_up TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 - tumb is up, 0 - tumb is down',
    CONSTRAINT PK_votes PRIMARY KEY (entity_id, created_by, created_at),
    CONSTRAINT FK_votes_entity_id FOREIGN KEY (entity_id) REFERENCES entity(entity_id),
    CONSTRAINT FK_votes__users_id FOREIGN KEY (created_by) REFERENCES users(id)
) COMMENT = 'Голоса (лайки)'; 


-- Заполняем таблицу users сгенерированными случайными данными 

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (1, 'Mabelle', 'Hudson', 'heidi09@example.net', '(356)114-3944', '1975-11-04 19:40:06', '1991-11-10 10:00:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (2, 'Trystan', 'Moore', 'leuschke.tracey@example.net', '073.451.4314', '1976-12-24 10:14:29', '1999-12-29 00:22:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (3, 'Lula', 'Leuschke', 'meghan.adams@example.com', '560.721.1540', '1991-11-02 12:30:46', '2014-01-24 17:00:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (4, 'Ally', 'Braun', 'dorcas48@example.net', '(433)874-6306x40315', '2020-05-15 21:52:39', '2006-06-21 02:40:56');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (5, 'Katharina', 'Schmidt', 'kcrist@example.com', '955-735-7540', '2001-04-26 17:13:45', '2013-03-04 18:47:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (6, 'Keshaun', 'Kovacek', 'wehner.vita@example.org', '1-420-040-2823', '2004-11-03 21:27:33', '1997-01-24 10:29:13');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (7, 'Julien', 'Hartmann', 'fbreitenberg@example.org', '1-431-959-1783x09263', '2014-10-27 05:50:18', '2011-05-18 10:23:37');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (8, 'Cathy', 'Wolff', 'nrath@example.net', '(334)997-0022x6009', '1984-05-19 15:48:09', '2017-07-14 21:57:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (9, 'Gia', 'Reilly', 'walker.edmund@example.com', '(495)477-1759', '1984-12-26 03:55:01', '1976-03-25 06:31:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (10, 'Mercedes', 'Murazik', 'ibaumbach@example.com', '368-043-7980x628', '1986-04-03 22:09:46', '1999-01-23 05:01:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (11, 'Jennings', 'Kemmer', 'reilly.marcellus@example.com', '+47(5)5843280586', '2000-12-12 17:23:22', '2007-12-19 20:10:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (12, 'Spencer', 'Tromp', 'hammes.scot@example.net', '+40(3)0172279445', '1979-04-14 10:08:07', '1992-03-14 13:31:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (13, 'Tavares', 'Swift', 'xrunolfsdottir@example.net', '122-878-9966x33327', '1985-04-19 13:16:56', '1980-09-25 04:58:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (14, 'Virgil', 'Collins', 'norberto25@example.net', '(597)024-1879x2705', '1977-09-18 17:40:41', '1988-05-27 20:47:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (15, 'Lafayette', 'Farrell', 'rene47@example.net', '1-293-603-0347', '2004-02-29 05:09:47', '1996-04-27 16:42:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (16, 'Bertram', 'Schulist', 'langosh.piper@example.com', '01736242458', '1989-05-03 15:36:17', '2013-10-28 06:12:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (17, 'Major', 'Kuhn', 'kkiehn@example.net', '+14(0)5481946357', '2000-07-27 19:10:27', '1973-11-27 21:19:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (18, 'Mozelle', 'Jaskolski', 'jared.labadie@example.com', '1-907-811-4487', '1992-04-01 21:24:05', '1990-01-27 00:10:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (19, 'Nettie', 'Stark', 'wwilkinson@example.org', '020.797.4627x90155', '2006-11-25 02:41:39', '1999-07-16 13:47:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (20, 'Alexandrine', 'Cassin', 'krobel@example.com', '034-175-5275x9548', '1973-11-24 15:45:52', '1980-09-21 18:40:35');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (21, 'Thaddeus', 'Mertz', 'katrine08@example.org', '+96(9)2029708995', '2012-02-28 17:58:13', '1991-10-14 12:00:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (22, 'Scottie', 'Bosco', 'casimir60@example.org', '(705)529-8862x9521', '1972-06-22 03:32:23', '2019-06-09 04:08:28');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (23, 'Ida', 'Fadel', 'hyatt.tristian@example.org', '768.736.9336', '1982-12-02 15:02:06', '1990-03-22 19:33:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (24, 'Judah', 'Jacobson', 'bbeier@example.org', '01602974923', '2020-04-11 20:01:29', '1984-08-21 19:28:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (25, 'Emmet', 'Kassulke', 'uheller@example.org', '(381)101-9285x7358', '1998-10-26 13:10:49', '1979-04-23 03:57:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (26, 'Evans', 'Cremin', 'gweissnat@example.com', '(069)509-4587x99598', '2021-01-26 05:32:29', '2002-04-15 06:26:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (27, 'Mckayla', 'Collins', 'bruen.alvis@example.net', '672-885-7412x45951', '1971-11-25 05:32:43', '1997-11-21 03:48:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (28, 'Winfield', 'Ferry', 'yborer@example.com', '1-825-028-9713x11746', '2007-12-19 21:45:32', '1984-12-17 04:07:40');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (29, 'Diamond', 'Bode', 'ibarton@example.com', '899.217.7240x11258', '1975-03-29 18:15:34', '1991-04-15 15:39:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (30, 'Earline', 'Barton', 'tod20@example.org', '275-702-3162x47940', '2006-12-30 10:40:44', '1981-01-08 20:05:17');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (31, 'Haven', 'Olson', 'terry.susanna@example.com', '(586)360-7070x7854', '2013-09-01 00:53:34', '1999-01-18 00:52:54');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (32, 'Fausto', 'Wisoky', 'edavis@example.net', '1-521-351-5258', '1989-09-20 10:00:54', '1974-11-21 04:31:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (33, 'Simeon', 'Denesik', 'kenya.smitham@example.org', '624-670-2436x662', '1973-09-03 10:30:57', '2015-04-28 14:33:21');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (34, 'Christian', 'Anderson', 'kunze.bertrand@example.org', '528.052.5717', '1995-09-25 02:01:25', '1976-11-23 11:06:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (35, 'Aileen', 'Hauck', 'timmothy.blick@example.com', '1-555-489-9641', '1996-06-24 17:13:01', '1977-10-08 19:33:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (36, 'Jamarcus', 'Mueller', 'denesik.cleve@example.net', '042-318-4351', '1971-09-10 01:53:33', '1997-11-01 12:53:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (37, 'Alexandrine', 'Grimes', 'deckow.tyreek@example.org', '1-717-051-6834x193', '1970-04-23 08:29:37', '2000-01-22 17:33:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (38, 'Nyasia', 'Pollich', 'rod.monahan@example.com', '627.468.5185x7699', '1974-08-15 01:07:12', '1979-04-26 05:40:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (39, 'Gerhard', 'Mayert', 'santino.wilderman@example.com', '128.125.3159x003', '1984-07-05 00:17:57', '2005-10-20 22:54:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (40, 'Kaylie', 'Parker', 'adrianna.o\'hara@example.net', '+47(3)5653968324', '1971-01-02 09:41:09', '2012-02-17 13:25:57');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (41, 'Enoch', 'Pollich', 'ebernhard@example.org', '877.339.1212x92005', '2005-08-17 15:35:04', '1997-12-02 07:54:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (42, 'Rocky', 'Nolan', 'wyman.joey@example.org', '1-921-395-1759x792', '2005-06-27 14:34:28', '1975-08-26 10:21:29');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (43, 'Rafael', 'Bednar', 'ferry.kylie@example.net', '05848259455', '1995-06-21 01:58:13', '2010-03-27 14:54:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (44, 'Enid', 'Reilly', 'mckenzie.meda@example.com', '(367)915-3831x12442', '1997-08-02 11:10:10', '1995-05-22 12:33:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (45, 'Elissa', 'Anderson', 'glabadie@example.org', '741-403-7255x275', '1971-05-06 07:41:29', '2009-04-21 11:35:09');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (46, 'Brent', 'Walsh', 'sophia47@example.com', '764-109-3447x9333', '1981-09-03 18:44:55', '1988-12-21 17:55:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (47, 'Arnulfo', 'Lubowitz', 'mhilpert@example.org', '533-705-4152', '2005-03-02 07:57:00', '1971-09-26 12:34:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (48, 'Name', 'Pfannerstill', 'welch.virgie@example.net', '(150)093-6370x349', '1999-08-08 21:37:42', '2000-04-11 07:04:49');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (49, 'Maiya', 'Johnston', 'ryleigh.gislason@example.com', '1-171-973-4394x351', '1981-03-21 14:36:47', '1982-03-01 20:57:24');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (50, 'Adolphus', 'Johns', 'kgleason@example.net', '014.738.5794x0464', '2020-12-27 14:13:16', '1980-01-15 02:00:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (51, 'Rashawn', 'Ritchie', 'marcia78@example.org', '261.092.2492', '2010-12-27 21:28:44', '1970-04-20 09:18:34');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (52, 'Tommie', 'Grimes', 'yasmin.herzog@example.org', '(194)602-3546', '1995-01-14 13:35:29', '1977-06-30 09:53:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (53, 'Mina', 'Murray', 'white.coty@example.org', '123.589.6923', '1996-07-10 13:08:05', '2016-09-13 10:23:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (54, 'Berta', 'Nader', 'kmedhurst@example.org', '+16(9)0886993888', '2017-11-30 02:30:52', '1983-10-29 06:05:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (55, 'Lowell', 'Swift', 'adaline.weber@example.org', '(095)134-2435', '2001-12-20 06:54:07', '1981-12-03 23:56:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (56, 'Marta', 'Mosciski', 'dboehm@example.net', '01740288471', '1987-06-30 11:10:25', '1981-08-06 19:14:16');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (57, 'Jacklyn', 'Fritsch', 'gerhold.ignacio@example.net', '510-614-9893', '2002-01-31 00:35:39', '2003-12-25 23:26:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (58, 'Billie', 'Dooley', 'zjohns@example.com', '510.297.8385', '2021-03-31 07:55:09', '1973-08-07 22:10:07');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (59, 'Coby', 'Treutel', 'vnicolas@example.org', '1-242-080-3657', '2010-07-08 17:01:43', '1980-11-30 20:17:30');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (60, 'Skylar', 'VonRueden', 'cruickshank.matilda@example.com', '+04(0)1796238076', '1991-07-26 21:40:17', '1987-09-10 16:33:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (61, 'Cayla', 'Shields', 'johns.amaya@example.net', '1-032-095-8466', '1975-03-31 18:10:33', '1975-08-27 08:11:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (62, 'Tiara', 'Reynolds', 'xavier31@example.org', '+22(1)5052985755', '1981-06-04 20:00:11', '2003-08-18 17:43:32');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (63, 'Brook', 'Wiegand', 'mercedes16@example.org', '01584845496', '1999-06-03 23:30:53', '2002-08-24 13:22:52');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (64, 'Gabriella', 'Bednar', 'wswaniawski@example.org', '035.749.1364x84789', '1977-09-18 21:38:41', '1990-09-30 17:46:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (65, 'Enola', 'Lesch', 'nferry@example.com', '686-888-3269x0960', '1997-10-18 14:31:37', '1970-01-02 23:11:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (66, 'Lon', 'Tromp', 'schulist.hassan@example.com', '+82(0)5249605185', '1998-04-09 05:33:01', '2009-06-07 18:00:31');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (67, 'Raquel', 'Dicki', 'thomas07@example.net', '(643)665-1980x164', '1990-10-26 18:44:38', '1983-06-29 04:46:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (68, 'Idella', 'Walker', 'zoe.ullrich@example.org', '01376747917', '2019-02-17 07:45:35', '1983-12-02 19:23:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (69, 'Xzavier', 'Leannon', 'willms.raleigh@example.net', '+89(4)3188779664', '1971-01-24 05:07:45', '1988-03-06 09:24:06');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (70, 'Anika', 'Cummings', 'aschuppe@example.net', '(466)389-9129x3986', '2005-12-04 22:27:15', '2018-01-18 18:54:11');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (71, 'Larissa', 'Graham', 'wintheiser.lourdes@example.com', '1-219-490-0715', '1980-10-05 03:12:59', '1995-08-29 04:57:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (72, 'Brown', 'Klocko', 'savanna.windler@example.com', '(703)902-2490x54737', '1973-09-18 04:47:28', '1971-07-04 05:40:20');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (73, 'Isobel', 'Keeling', 'vandervort.yvonne@example.org', '1-833-066-7174', '1983-08-25 06:59:50', '1998-09-19 23:47:00');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (74, 'Cynthia', 'Howe', 'olaf15@example.com', '1-007-395-3767x42112', '2019-02-18 15:51:20', '2018-12-29 16:23:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (75, 'Urban', 'Crist', 'hazel15@example.org', '398.067.6693', '1972-03-04 06:34:26', '2014-10-30 00:41:41');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (76, 'Afton', 'Schmitt', 'raynor.gustave@example.com', '236-380-4538', '1977-11-08 13:10:53', '2017-02-10 16:23:12');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (77, 'Jadon', 'Gleichner', 'zita.zemlak@example.org', '977.014.8517x99465', '1976-01-13 05:33:42', '1975-10-14 14:54:01');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (78, 'Gene', 'Walter', 'naomie28@example.net', '900-203-8209x3495', '1983-09-12 00:11:16', '2020-12-27 14:05:51');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (79, 'Eleanora', 'Bins', 'wschimmel@example.net', '(118)500-9790x9652', '1997-04-20 01:00:33', '1994-01-09 17:14:25');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (80, 'Felicity', 'Harvey', 'friesen.broderick@example.org', '1-738-401-8318', '2015-06-05 01:38:29', '1993-01-11 12:09:05');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (81, 'Jared', 'Sawayn', 'littel.magali@example.net', '(815)949-3345', '1981-10-21 06:20:29', '1980-07-04 18:15:26');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (82, 'Liana', 'Schamberger', 'claud.raynor@example.org', '+53(8)4352134189', '2018-08-04 22:11:01', '1978-05-22 02:35:22');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (83, 'Queen', 'Tremblay', 'yost.karolann@example.net', '1-873-201-3605', '1976-05-15 09:16:14', '2003-08-06 09:24:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (84, 'Meghan', 'Rolfson', 'dorothea82@example.com', '(630)229-4662x96167', '1988-10-08 00:39:26', '2004-06-10 17:33:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (85, 'Charlotte', 'Balistreri', 'ischoen@example.org', '1-739-971-6271x43314', '2019-06-28 04:56:45', '2010-10-22 02:02:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (86, 'Woodrow', 'Kreiger', 'maida55@example.org', '026.241.8987x42138', '2010-11-11 23:39:23', '1974-09-03 06:40:47');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (87, 'Estefania', 'Koepp', 'hal78@example.com', '157.382.9225x58252', '1974-09-20 05:01:07', '1992-09-12 21:15:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (88, 'Murl', 'Schmitt', 'stanton.allie@example.com', '520.464.8739x8604', '1983-04-01 20:17:55', '1982-06-12 10:20:23');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (89, 'Crystal', 'Gottlieb', 'denesik.russ@example.com', '05185470078', '1983-03-11 04:23:09', '1995-05-24 20:40:10');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (90, 'Lucile', 'Zieme', 'koepp.ethel@example.com', '(420)385-9211x17639', '1976-04-05 15:50:27', '2017-12-27 18:32:18');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (91, 'Wayne', 'Casper', 'julia02@example.com', '1-655-854-8461', '1970-05-13 16:03:25', '2004-08-29 05:08:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (92, 'Dalton', 'Barrows', 'providenci63@example.com', '198-816-3654x1580', '1991-08-14 22:16:30', '1972-11-07 18:52:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (93, 'Alexanne', 'Harvey', 'lnitzsche@example.net', '01316649111', '1988-08-12 03:26:35', '2016-12-18 11:51:42');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (94, 'Nova', 'Ledner', 'mitchell.keshawn@example.com', '087.940.1974', '2000-08-28 23:05:54', '1990-09-15 08:50:43');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (95, 'Isom', 'Jacobi', 'davis.josie@example.com', '08508535544', '1997-01-18 16:45:00', '2000-05-24 02:39:15');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (96, 'Kylee', 'Dickens', 'pollich.monica@example.org', '101-811-1373', '1986-04-07 08:00:57', '1985-08-04 16:47:33');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (97, 'Sigrid', 'Olson', 'vida77@example.com', '373.408.3066x67534', '1977-12-10 21:50:25', '1982-07-09 20:38:27');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (98, 'Delphine', 'Carter', 'malinda.abshire@example.com', '959.011.8265x987', '1986-07-17 19:08:41', '1975-09-16 13:30:45');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (99, 'Darron', 'Kulas', 'coleman62@example.org', '(662)180-9684x1309', '2011-07-11 02:15:28', '2019-08-30 09:10:58');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `created_at`, `updated_at`) VALUES (100, 'Emmanuelle', 'Armstrong', 'mcdermott.oswald@example.org', '802-876-9704x0961', '2000-03-04 16:01:02', '1979-10-13 11:50:09');
COMMIT;

-- Заполняем entity_types

/*
INSERT INTO `entity_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'message', '2017-10-03 21:43:58', '2003-03-13 05:18:30');
INSERT INTO `entity_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'media', '1984-07-21 23:31:25', '1975-02-03 18:11:57');
*/
INSERT INTO `entity_types` (`id`, `name`) VALUES (1, 'message');
INSERT INTO `entity_types` (`id`, `name`) VALUES (2, 'media');
COMMIT;


-- Заполняем таблицу profiles сгенерированными случайными данными

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (1, 'B', '1975-05-13', 'East Candice', 'Iran', '1973-10-25 15:36:21', '1991-03-09 23:26:09');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (2, 'H', '2017-02-19', 'Loyalhaven', 'French Polynesia', '1994-11-08 16:15:00', '1985-06-17 12:26:39');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (3, 'C', '1991-08-01', 'Shannonland', 'Saint Helena', '1983-03-08 10:34:59', '1983-05-22 22:26:20');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (4, 'P', '1971-07-15', 'Funkhaven', 'Cook Islands', '1970-03-13 07:19:32', '1991-11-29 13:11:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (5, 'L', '1986-06-23', 'New Kathrynehaven', 'Syrian Arab Republic', '1997-09-04 01:20:21', '1976-08-18 09:13:48');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (6, 'J', '1970-02-17', 'Filibertoshire', 'Netherlands', '2017-04-12 09:12:24', '1981-04-27 06:55:34');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (7, 'O', '2018-12-28', 'South Noblemouth', 'Nauru', '2018-07-19 19:49:25', '2004-02-04 03:20:04');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (8, 'J', '1970-05-09', 'Clintonhaven', 'Turks and Caicos Islands', '1976-05-10 05:54:43', '1986-05-01 16:57:29');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (9, 'E', '2012-07-10', 'North Vivien', 'Guadeloupe', '1994-05-23 22:00:40', '2007-09-30 01:06:48');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (10, 'S', '1984-08-31', 'Port Nova', 'Faroe Islands', '2019-08-06 12:29:31', '2015-11-04 11:32:39');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (11, 'Z', '1988-02-02', 'Lake Amya', 'Montenegro', '1992-03-01 03:02:54', '1998-11-18 03:10:00');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (12, 'T', '1975-12-08', 'East Darronhaven', 'Sweden', '1995-12-03 21:54:55', '1998-01-18 06:10:27');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (13, 'D', '2002-09-25', 'Lake Urielfort', 'Saint Kitts and Nevis', '1972-12-06 01:40:59', '2012-01-10 01:50:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (14, 'E', '1987-03-09', 'Faustinofurt', 'France', '1991-12-12 16:15:08', '1981-04-14 20:01:50');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (15, 'C', '1998-01-31', 'Yostview', 'Tajikistan', '2020-02-28 17:20:30', '1986-02-13 07:01:10');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (16, 'J', '1973-10-23', 'Ruthieton', 'Cote d\'Ivoire', '1978-05-22 17:11:36', '2018-03-18 22:25:12');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (17, 'D', '1993-01-09', 'North Lera', 'Netherlands', '2012-10-27 06:37:37', '2003-01-29 17:49:18');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (18, 'D', '1977-05-17', 'North Hettie', 'Jersey', '1980-07-02 19:18:44', '1971-12-03 00:51:37');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (19, 'R', '1977-04-06', 'Williamsonborough', 'Malta', '2004-07-05 18:10:11', '1994-08-01 06:42:40');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (20, 'D', '1978-11-25', 'Evemouth', 'Reunion', '1971-09-01 01:25:24', '2009-10-21 21:22:50');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (21, 'O', '1999-04-15', 'Cristobalview', 'Brunei Darussalam', '1997-02-03 10:59:43', '1970-05-29 14:33:07');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (22, 'N', '2016-10-18', 'Lesleyborough', 'India', '1992-07-16 19:20:25', '2007-12-10 02:20:25');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (23, 'D', '2006-08-09', 'Kerlukeland', 'San Marino', '1997-04-24 12:52:39', '2006-03-24 01:54:14');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (24, 'K', '1983-09-20', 'Aliaborough', 'French Polynesia', '2000-10-28 06:55:18', '2006-10-10 02:16:34');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (25, 'M', '1970-08-17', 'Lake Geneport', 'Somalia', '2001-02-25 23:36:35', '1977-05-19 13:03:35');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (26, 'H', '2016-12-22', 'Shanahanfurt', 'Puerto Rico', '1987-02-19 17:13:59', '2004-10-11 01:55:13');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (27, 'A', '1997-11-16', 'Laceyland', 'Lithuania', '2016-06-25 05:51:31', '1972-05-05 21:15:59');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (28, 'E', '1973-04-11', 'West Feliciatown', 'Belgium', '1997-02-01 13:37:35', '2014-03-05 02:34:27');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (29, 'D', '2013-06-16', 'North Fannyland', 'Austria', '2020-09-19 15:04:47', '2005-09-07 19:00:09');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (30, 'R', '2009-03-11', 'Gordonchester', 'Liberia', '1982-02-18 04:01:01', '1977-03-12 22:13:29');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (31, 'C', '1990-04-25', 'West Mortimer', 'French Polynesia', '1996-12-20 01:23:38', '2014-09-12 15:16:42');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (32, 'R', '1990-12-07', 'Adonisstad', 'Gibraltar', '1973-03-23 09:06:22', '1977-09-13 12:51:53');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (33, 'T', '1979-11-16', 'Magnoliaburgh', 'Malawi', '2014-08-16 16:59:35', '1988-01-15 21:57:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (34, 'A', '2015-04-10', 'Verlabury', 'Colombia', '1989-05-25 14:40:02', '1983-03-06 22:25:14');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (35, 'C', '2004-08-16', 'Port Jewel', 'Timor-Leste', '1978-01-17 12:47:28', '1995-11-13 14:25:44');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (36, 'S', '1989-10-13', 'West Wilfordfort', 'Suriname', '2013-04-05 21:22:24', '1997-07-22 19:04:57');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (37, 'R', '1992-01-15', 'Lake Vada', 'Cyprus', '2008-09-03 14:34:01', '2011-10-14 06:46:09');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (38, 'L', '1997-04-27', 'Hyattview', 'Kazakhstan', '2021-01-22 10:15:20', '2014-01-20 07:27:21');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (39, 'O', '2005-06-16', 'Purdyville', 'Peru', '1992-07-22 03:53:49', '2014-02-24 01:26:27');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (40, 'B', '1984-08-13', 'Port Kristytown', 'New Caledonia', '1989-11-19 18:29:54', '2004-10-10 02:17:35');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (41, 'J', '2013-09-15', 'East Roscoe', 'Tanzania', '2005-06-20 19:47:24', '1996-05-30 11:29:35');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (42, 'W', '2020-12-10', 'Lake Mohammed', 'Nauru', '2008-12-22 21:09:28', '2015-09-17 14:47:37');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (43, 'A', '1988-05-08', 'Port Raefurt', 'Tonga', '2008-12-15 09:54:09', '2016-04-19 01:59:31');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (44, 'K', '1996-03-16', 'New Britney', 'Zimbabwe', '1977-04-21 14:57:24', '2007-03-21 15:43:03');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (45, 'G', '1998-12-23', 'Terryport', 'Bahamas', '2005-10-09 08:00:25', '1985-10-10 13:51:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (46, 'J', '1982-11-09', 'Port Isabel', 'Suriname', '2003-06-01 05:26:15', '2008-04-14 12:44:15');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (47, 'M', '1999-06-03', 'Juliefurt', 'Micronesia', '2013-01-08 19:02:27', '1980-10-21 06:57:51');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (48, 'A', '2020-03-17', 'Port Williamside', 'Switzerland', '2005-07-11 03:20:12', '2005-09-29 10:43:18');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (49, 'T', '1991-10-25', 'Bruenville', 'Ukraine', '1991-02-07 05:15:21', '2021-01-17 20:25:25');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (50, 'E', '1997-11-24', 'Koreyburgh', 'Syrian Arab Republic', '2008-02-17 23:11:27', '1971-05-08 04:58:54');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (51, 'D', '2006-02-27', 'Schusterchester', 'Cape Verde', '1987-07-22 08:24:21', '1977-05-07 18:50:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (52, 'C', '1976-06-23', 'Elodystad', 'Marshall Islands', '1977-05-18 11:44:28', '2001-09-27 17:25:04');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (53, 'M', '1990-05-10', 'South Cloydville', 'Macedonia', '1986-11-19 23:09:21', '2011-07-24 01:46:58');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (54, 'R', '2015-03-29', 'South Audie', 'United Kingdom', '1988-03-20 04:42:03', '1997-03-13 22:50:56');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (55, 'R', '1988-05-11', 'Stanfordside', 'Mauritius', '2016-07-30 00:57:25', '2004-05-14 22:51:13');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (56, 'S', '1978-05-07', 'North Briana', 'India', '1977-06-22 10:18:41', '2012-11-22 11:22:37');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (57, 'R', '1986-08-25', 'Hudsonstad', 'Nicaragua', '1985-05-27 22:04:09', '2010-10-15 07:48:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (58, 'W', '1990-05-25', 'Lake Nameshire', 'Swaziland', '1993-08-12 07:03:01', '2001-02-17 20:00:20');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (59, 'L', '1992-06-19', 'Lake Hillary', 'Aruba', '1970-08-09 11:25:30', '2005-07-24 14:01:43');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (60, 'F', '2013-10-18', 'Adolffurt', 'Estonia', '1995-08-08 20:06:24', '2014-09-17 04:13:24');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (61, 'C', '2009-02-05', 'North Jarrett', 'Slovenia', '1986-04-28 01:58:36', '2015-01-10 14:06:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (62, 'R', '1983-07-24', 'Aurorestad', 'Switzerland', '1979-08-08 06:39:11', '2007-12-06 19:19:53');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (63, 'S', '1988-04-03', 'East Bryonberg', 'Barbados', '1995-11-12 02:47:38', '2014-08-17 01:19:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (64, 'A', '1988-09-08', 'Lake Genevieve', 'New Zealand', '1995-05-11 06:32:43', '2008-01-03 16:38:48');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (65, 'C', '1986-09-24', 'North Terrymouth', 'Ethiopia', '1991-08-04 00:01:43', '1980-12-22 07:59:31');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (66, 'C', '2019-01-23', 'Lake Reannatown', 'Croatia', '2004-07-12 08:23:29', '1988-07-12 09:48:48');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (67, 'A', '2020-10-27', 'Leonieton', 'Liberia', '2016-12-29 02:03:49', '1996-01-21 02:23:35');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (68, 'E', '1993-03-20', 'Thoramouth', 'Swaziland', '2014-09-28 22:42:31', '2004-02-28 13:01:51');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (69, 'F', '1996-04-12', 'Maybellehaven', 'Croatia', '1999-10-22 15:10:16', '2018-04-07 13:12:29');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (70, 'N', '1988-05-12', 'Bartonchester', 'Chile', '2014-04-27 00:33:01', '1974-05-08 10:06:53');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (71, 'M', '1982-08-06', 'Steubermouth', 'Kenya', '1977-09-27 05:01:48', '1988-06-22 18:59:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (72, 'S', '2002-12-19', 'Paxtonmouth', 'Cote d\'Ivoire', '1981-05-06 18:22:29', '1985-04-03 15:45:10');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (73, 'M', '1987-08-15', 'West Tianaberg', 'New Caledonia', '1974-07-13 20:43:17', '2010-04-23 07:03:11');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (74, 'K', '1982-08-22', 'Hicklefurt', 'Somalia', '1971-03-26 13:35:34', '2004-03-28 22:56:27');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (75, 'H', '1975-03-08', 'Watersview', 'Cyprus', '1984-05-07 05:46:46', '2001-02-15 19:59:23');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (76, 'J', '2013-10-23', 'North Bernardoborough', 'Slovenia', '1985-09-20 10:50:02', '1996-02-03 03:39:42');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (77, 'J', '1987-08-01', 'Lake Annabellview', 'Oman', '1996-05-25 23:45:45', '1996-02-26 10:02:02');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (78, 'F', '2016-05-20', 'Fayemouth', 'Monaco', '1988-04-30 12:08:09', '1997-01-01 03:27:40');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (79, 'D', '2014-10-23', 'Port Winona', 'Bulgaria', '1990-10-29 23:30:00', '1994-08-24 17:18:34');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (80, 'A', '2005-11-11', 'Kuhicchester', 'Christmas Island', '2007-02-15 06:19:48', '2019-10-16 11:47:15');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (81, 'O', '1981-09-06', 'Ericamouth', 'Guinea', '2013-01-18 09:16:09', '1980-07-22 11:42:28');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (82, 'D', '2006-09-01', 'Spinkafurt', 'Russian Federation', '2015-02-28 09:50:59', '1972-11-16 22:28:33');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (83, 'I', '1982-07-31', 'Schmittbury', 'Denmark', '2007-03-30 03:40:58', '1989-06-13 12:50:55');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (84, 'T', '2015-03-17', 'Lake Aaliyah', 'Sweden', '1997-12-06 18:03:15', '1989-09-21 02:25:30');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (85, 'A', '2009-06-04', 'Lake Patbury', 'Austria', '1970-09-12 01:57:38', '1990-08-01 17:53:39');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (86, 'G', '1978-11-24', 'East Cicerobury', 'Bangladesh', '1998-12-21 16:30:00', '1973-08-01 09:50:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (87, 'E', '2006-04-24', 'South Annabell', 'Kyrgyz Republic', '2019-03-17 08:30:51', '2000-05-21 17:11:22');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (88, 'C', '1978-02-07', 'Stantonside', 'Norway', '1975-07-19 17:59:53', '1973-04-29 04:37:41');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (89, 'W', '2001-07-07', 'New Libbyville', 'Samoa', '2015-06-24 02:09:41', '1979-01-16 12:37:16');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (90, 'A', '1997-10-07', 'New Summer', 'Mongolia', '1978-07-02 13:41:33', '2003-06-05 16:25:29');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (91, 'B', '1976-01-12', 'West Troymouth', 'Costa Rica', '2008-05-03 10:50:32', '2004-12-14 20:05:44');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (92, 'K', '2009-08-04', 'South Gregorio', 'Burkina Faso', '2001-05-28 03:59:38', '1989-07-19 04:41:20');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (93, 'K', '1999-12-12', 'Port Hester', 'Netherlands Antilles', '1992-02-10 18:18:54', '1972-01-17 23:52:49');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (94, 'C', '1987-12-04', 'North Autumnville', 'Kiribati', '1989-04-17 14:36:38', '2015-10-01 13:35:04');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (95, 'D', '1995-10-15', 'Muellermouth', 'New Caledonia', '2020-11-18 15:29:12', '2004-06-29 16:00:25');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (96, 'B', '1996-02-01', 'Port Antonietta', 'Central African Republic', '1998-09-20 19:33:08', '1981-03-31 00:24:32');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (97, 'R', '1990-12-11', 'Quitzonborough', 'Cape Verde', '2004-04-02 09:02:11', '1984-02-08 14:27:50');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (98, 'A', '2004-02-26', 'Port Gaetano', 'Peru', '1985-02-05 04:46:51', '1974-05-14 23:20:06');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (99, 'L', '1972-09-03', 'East Jonas', 'Mali', '1971-05-07 10:56:00', '2005-11-18 16:14:06');
INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `city`, `country`, `created_at`, `updated_at`) VALUES (100, 'C', '2019-09-08', 'South Theodore', 'Hong Kong', '2007-10-03 20:28:52', '2021-01-23 20:55:14');
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
INSERT INTO `friendship_statuses` (`name`, `created_at`, `updated_at`) VALUES ('Подписка', '1993-05-05 03:00:34', '2021-01-25 23:10:51');
INSERT INTO `friendship_statuses` (`name`, `created_at`, `updated_at`) VALUES ('Бан', '1993-05-05 03:00:34', '2021-01-25 23:10:51');
COMMIT;

 
-- Заполняем таблицу friendship

INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (2, 76, 1, '2000-02-06 01:16:45', '2014-07-05 02:41:58', '1971-12-28 09:49:27', '2003-09-27 21:17:40');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (4, 83, 5, '1981-08-31 01:47:03', '1978-08-04 16:14:34', '1983-11-16 03:33:08', '2017-05-10 16:45:17');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (5, 54, 5, '2007-02-22 14:22:21', '2002-02-20 15:41:50', '1970-06-06 14:44:06', '2007-02-19 10:15:44');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (6, 34, 5, '1985-09-29 17:07:09', '1998-11-21 02:16:54', '2011-01-11 10:13:56', '2003-04-08 16:09:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (12, 1, 3, '1987-12-21 11:57:00', '1998-08-19 18:47:58', '2018-12-16 13:21:47', '2011-07-31 22:10:11');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (14, 56, 1, '1990-10-13 15:42:38', '1981-08-14 03:37:24', '2008-03-03 01:31:10', '1980-06-05 10:36:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (16, 44, 3, '2000-04-18 00:34:24', '2007-11-16 23:34:47', '1992-02-09 21:48:51', '2008-11-16 20:19:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (19, 18, 5, '1990-05-25 05:36:37', '1997-11-13 22:36:54', '1992-11-10 11:50:32', '2012-07-20 20:33:52');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (20, 87, 1, '1987-05-12 19:04:38', '2004-08-28 11:26:58', '2003-06-06 13:14:14', '1989-01-16 20:41:11');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (21, 99, 2, '2018-03-05 13:59:47', '1981-09-15 13:08:10', '2004-02-23 10:16:14', '1989-01-26 07:50:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (23, 47, 4, '2014-10-16 12:41:35', '1985-07-08 20:13:38', '1977-12-23 21:20:17', '1981-11-14 15:34:17');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (24, 53, 2, '2001-09-22 00:35:28', '2019-02-25 06:48:51', '2005-10-28 15:16:30', '1987-07-30 19:20:26');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (25, 84, 1, '1980-02-18 00:14:57', '1987-08-29 03:28:09', '1985-08-03 01:22:46', '1986-11-18 18:02:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (26, 39, 4, '2020-01-08 02:23:47', '1994-01-18 14:18:30', '1987-12-13 01:57:01', '1975-07-16 01:58:10');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (27, 97, 4, '1978-06-30 19:13:30', '2007-03-18 08:36:29', '2002-07-20 20:00:02', '2007-07-23 17:46:01');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (28, 50, 5, '1979-08-31 15:51:06', '1994-05-22 08:01:27', '2021-04-07 11:17:10', '1977-08-24 17:01:46');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (29, 13, 2, '1997-06-26 04:40:17', '1970-03-05 23:01:22', '2007-07-01 22:40:48', '2016-12-12 06:59:57');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (36, 32, 3, '1988-03-05 10:56:46', '1992-12-01 13:46:55', '2001-11-20 14:13:25', '1984-10-21 09:59:20');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (37, 43, 4, '2011-05-12 05:15:43', '2009-03-18 10:27:06', '2001-05-02 06:04:49', '1977-01-28 15:43:15');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (38, 72, 1, '2017-07-16 06:18:19', '1976-09-14 17:28:17', '2005-04-09 11:52:08', '1992-01-12 12:25:34');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (40, 66, 1, '1994-06-03 19:13:58', '1980-07-08 21:47:17', '1973-01-25 05:06:14', '1988-07-09 02:06:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (45, 11, 2, '2012-06-12 23:29:18', '1990-09-22 04:13:43', '2003-05-27 08:15:14', '2005-06-30 13:46:08');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (46, 70, 4, '1980-07-17 03:32:07', '1979-01-02 16:29:24', '1976-01-16 10:25:57', '2014-09-16 23:52:56');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (48, 81, 3, '2000-03-08 01:24:56', '2003-01-11 14:50:21', '2005-07-28 17:48:51', '1973-04-07 02:39:13');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (57, 51, 2, '1993-06-29 10:27:16', '1979-07-02 19:54:16', '2009-10-18 17:43:03', '2002-12-02 18:37:03');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (58, 30, 5, '2011-03-07 06:10:13', '1997-05-21 13:24:23', '1996-03-17 23:40:13', '1971-05-10 02:17:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (59, 88, 1, '1975-04-08 14:09:33', '1971-10-30 22:22:43', '2015-03-17 14:50:13', '2020-12-31 20:49:23');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (60, 41, 2, '1970-08-28 14:43:21', '2001-10-15 01:15:33', '1986-01-29 21:12:29', '2017-09-29 12:46:43');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (61, 9, 1, '1973-12-26 03:08:14', '1979-02-01 08:43:04', '2016-02-07 12:17:07', '2001-06-11 04:11:47');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (63, 10, 5, '1975-01-04 17:03:22', '1986-08-05 21:52:25', '1987-09-19 17:42:33', '1984-09-24 21:00:45');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (64, 77, 3, '2011-03-11 23:40:16', '1977-05-13 20:41:30', '1983-03-04 00:10:53', '1999-11-03 16:41:20');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (67, 8, 2, '1988-01-01 11:16:25', '1975-02-28 04:09:42', '1975-07-28 17:18:24', '2017-11-06 12:31:16');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (68, 7, 3, '2016-05-26 08:46:55', '1980-11-23 04:52:10', '2020-02-27 03:31:52', '2011-12-25 11:39:30');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (69, 15, 5, '1993-01-13 03:16:59', '2019-07-14 23:14:48', '2005-03-01 08:44:55', '1972-02-11 12:37:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (71, 80, 4, '1979-12-22 17:33:33', '2007-09-05 07:34:07', '1985-04-15 15:38:21', '1983-09-30 05:17:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (73, 75, 3, '2016-10-29 15:57:03', '2013-12-12 02:30:09', '1973-05-05 17:00:12', '1981-10-31 06:04:24');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (74, 22, 3, '2004-06-26 21:06:59', '2016-07-28 21:50:16', '1979-08-05 13:14:05', '1977-09-08 22:45:19');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (79, 55, 4, '1980-08-06 00:03:53', '1971-01-18 15:57:35', '2020-05-27 20:15:07', '1972-11-07 14:35:22');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (82, 33, 3, '1977-10-01 02:16:59', '2007-05-27 13:23:06', '1997-05-13 18:08:46', '1988-05-10 05:15:53');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (85, 65, 1, '1981-12-24 15:23:09', '1974-03-23 04:22:57', '1989-07-17 20:52:38', '1981-11-13 17:21:31');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (86, 31, 5, '1976-08-12 19:09:14', '2018-03-17 00:53:18', '1996-03-06 02:47:20', '1995-03-03 23:15:25');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (89, 17, 4, '1992-11-30 03:39:43', '1976-11-14 10:39:31', '1997-03-11 18:40:49', '2011-02-28 08:02:51');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (90, 95, 4, '1975-10-17 04:20:47', '2002-03-16 01:28:45', '2020-11-03 18:11:37', '1971-08-13 11:43:02');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (91, 49, 3, '2013-12-06 04:07:00', '2005-10-28 08:42:11', '1981-08-26 04:30:45', '2013-11-29 17:22:48');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (92, 3, 4, '1996-12-02 23:55:05', '2009-03-04 17:47:03', '1986-08-21 18:29:34', '2009-12-20 16:39:59');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (93, 78, 2, '2001-06-30 14:16:43', '1971-07-04 01:53:42', '2014-05-14 13:40:38', '2010-07-02 10:18:44');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (94, 52, 5, '2005-06-27 06:25:16', '2010-06-11 13:54:53', '2013-12-17 16:43:30', '1970-01-30 09:18:08');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (96, 42, 1, '2012-02-04 04:11:25', '2018-05-25 14:56:58', '1993-03-12 07:51:09', '2005-05-08 13:32:09');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (98, 35, 2, '1996-08-03 04:37:30', '1997-09-05 14:09:38', '2020-06-11 16:12:04', '1988-09-27 19:22:36');
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `requested_at`, `confirmed_at`, `created_at`, `updated_at`) VALUES (100, 62, 2, '2015-06-10 18:06:47', '2008-08-15 21:40:18', '1978-05-17 08:28:48', '2004-07-27 23:51:08');
COMMIT;

-- Здесь необходимо отредактировать таблицу friendship

-- Заполняем таблицу communities

INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (1, 15, 'Электроника', '2018-07-28 04:08:55', '2001-09-25 05:03:15');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (2, 47, 'Качай железо', '1974-05-21 13:12:50', '2019-09-08 14:37:16');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (3, 44, 'Путешествия', '2013-05-27 18:25:27', '1994-07-15 12:25:35');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (4, 65, 'Компьютеры', '1982-12-11 16:11:38', '2016-03-20 14:28:30');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (5, 48, 'Еда и готовка', '1984-04-11 21:42:11', '2012-10-02 23:56:59');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (6, 84, 'Сделай сам', '1995-11-01 03:18:39', '1983-05-02 20:01:45');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (7, 56, 'Физика и химия', '2001-12-27 09:22:28', '1971-10-25 01:47:29');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (8, 58, 'Стройка и ремонт', '1997-08-09 12:24:08', '1995-08-13 09:26:11');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (9, 44, 'Вокруг света', '1999-01-27 14:35:54', '1994-10-18 19:07:49');
INSERT INTO `communities` (`id`, `principal_id`, `name`, `created_at`, `updated_at`) VALUES (10, 67, 'Тачки и бабы', '1988-05-16 17:56:50', '2007-11-04 12:05:28');
COMMIT;


-- Заполняем таблицу communities_users


INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 1, '1973-06-28 05:14:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 11, '1972-06-22 22:11:40');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 21, '1985-08-04 19:41:20');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 31, '1988-08-20 11:19:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 41, '1976-02-15 09:25:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 51, '1980-05-17 20:31:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 61, '2016-10-28 12:36:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 71, '2019-01-25 13:12:54');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 74, '1984-09-03 12:56:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 82, '1984-09-03 12:56:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 87, '1984-09-03 12:56:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 89, '1984-09-03 12:56:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 91, '2012-04-19 06:24:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (1, 2, '2018-11-27 13:03:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 12, '2002-08-13 20:49:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 22, '1971-12-29 00:28:20');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 32, '1976-01-01 12:37:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 42, '1981-01-24 18:46:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 52, '1981-02-23 17:07:44');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 62, '2000-03-05 03:27:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 72, '2011-03-15 00:39:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (2, 82, '1971-05-23 01:18:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 92, '2005-05-17 16:40:55');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 3, '1976-06-14 15:24:52');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 13, '1970-10-08 07:34:59');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 23, '2018-09-10 20:14:21');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 33, '1979-10-23 04:13:54');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 43, '2008-10-10 11:46:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 53, '2004-10-21 22:43:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 63, '1993-03-27 11:29:23');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 73, '1986-07-27 20:20:18');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 83, '1980-07-22 21:55:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (3, 93, '2016-09-02 14:28:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 4, '1972-11-29 14:26:13');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 5, '2006-02-26 08:05:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 14, '1993-07-25 21:22:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 24, '2009-04-16 03:56:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 25, '1970-02-01 04:14:22');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 34, '1973-10-05 12:31:40');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 44, '1994-05-24 01:06:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 54, '2020-03-30 15:37:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 64, '2000-10-04 13:38:46');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 74, '1972-11-23 06:52:50');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 84, '1970-06-09 13:35:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (4, 94, '2019-03-04 08:19:48');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 15, '1994-02-07 15:12:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 35, '1976-06-30 23:20:26');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 45, '1987-01-26 00:26:40');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 55, '2014-10-24 05:16:27');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 65, '1986-11-20 06:17:05');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 75, '2007-10-18 04:03:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (5, 85, '2015-07-07 21:32:58');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 4, '1971-04-19 20:52:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 6, '1971-04-19 20:52:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 16, '2009-06-19 17:03:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 26, '2016-10-12 00:42:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 36, '1980-09-11 11:35:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 46, '1977-07-26 08:14:36');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 56, '1988-04-13 01:26:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 66, '2011-03-23 17:32:43');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 76, '2016-04-30 20:25:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 86, '2000-01-28 06:29:52');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 95, '1982-04-24 01:06:28');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (6, 96, '2002-03-28 02:53:57');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 7, '1990-01-09 22:28:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 17, '2010-09-24 04:53:00');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 27, '1987-12-23 22:28:06');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 37, '2008-10-08 22:28:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 47, '2016-07-08 01:35:31');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 57, '2009-02-11 15:22:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 67, '2004-09-16 15:02:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 77, '2007-07-02 13:17:22');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 87, '2012-05-22 19:30:29');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (7, 97, '1974-11-17 02:30:11');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 8, '2001-12-04 04:13:49');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 18, '1985-01-03 10:49:08');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 28, '2007-03-29 05:14:39');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 68, '2004-12-07 11:33:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 78, '1995-04-26 13:57:56');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 88, '1995-12-28 05:20:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (8, 98, '1998-10-23 20:35:09');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 9, '2019-06-11 01:11:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 29, '2014-05-06 14:07:43');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 39, '1983-07-26 11:08:45');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 49, '1973-04-12 11:33:16');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 59, '2004-09-04 05:53:47');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 69, '1992-08-18 18:45:38');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 79, '2014-08-10 10:44:41');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 89, '2000-12-14 10:58:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (9, 99, '1976-10-06 01:10:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 2, '1986-10-25 12:39:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 5, '1986-10-25 12:39:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 6, '1986-10-25 12:39:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 10, '1986-10-25 12:39:30');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 19, '1992-12-06 19:24:25');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 20, '2000-01-20 07:18:22');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 30, '1981-04-02 12:18:01');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 38, '2010-07-04 17:13:19');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 48, '1975-08-27 02:34:02');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 52, '1984-07-13 22:02:12');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 50, '1971-03-23 00:53:03');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 58, '2000-08-21 23:56:24');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 60, '2001-09-16 11:16:42');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 70, '1983-06-16 08:52:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 80, '1992-06-15 07:46:51');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 90, '2003-07-04 10:44:15');
INSERT INTO `communities_users` (`community_id`, `user_id`, `created_at`) VALUES (10, 100, '2018-11-18 00:04:10');
COMMIT;


-- заполняем таблицу media_types
/*
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'jpg', '1976-09-27 07:40:33', '2001-10-15 10:32:33');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'mp3', '1984-07-03 17:27:10', '1973-11-16 22:22:40');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'mp4', '2019-08-13 13:11:25', '2017-01-04 18:22:49');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'png', '1984-07-03 17:27:10', '1973-11-16 22:22:40');
INSERT INTO `media_types` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'pdf', '2019-08-13 13:11:25', '2017-01-04 18:22:49');
*/
INSERT INTO `media_types` (`id`, `name`) VALUES (1, 'jpg');
INSERT INTO `media_types` (`id`, `name`) VALUES (2, 'mp3');
INSERT INTO `media_types` (`id`, `name`) VALUES (3, 'mp4');
INSERT INTO `media_types` (`id`, `name`) VALUES (4, 'png');
INSERT INTO `media_types` (`id`, `name`) VALUES (5, 'pdf');
COMMIT;

-- Заполняем таблицу media

INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (1, 10, 'perspiciatis', 9084, NULL, 1, 2, '1979-07-26 05:19:18', '2017-03-04 04:30:18');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (2, 12, 'et', 36, NULL, 2, 2, '2010-08-26 09:43:23', '2003-12-31 09:34:02');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (3, 33, 'nemo', 31348, NULL, 3, 2, '1974-07-12 08:50:46', '1999-06-24 11:48:06');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (4, 14, 'id', 493, NULL, 4, 2, '2013-12-19 12:04:35', '1984-01-05 23:42:42');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (5, 5, 'reiciendis', 0, NULL, 5, 2, '1986-10-06 07:31:32', '1981-04-08 16:13:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (6, 66, 'enim', 21720, NULL, 1, 2, '1978-09-08 02:11:41', '2018-02-23 05:34:06');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (7, 7, 'incidunt', 0, NULL, 2, 2, '1990-05-23 03:26:58', '2008-10-15 13:26:48');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (8, 28, 'rem', 0, NULL, 3, 2, '1990-11-21 22:55:58', '1973-06-20 19:47:10');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (9, 98, 'sit', 93510, NULL, 4, 2, '1994-09-30 19:12:24', '1990-03-18 15:18:32');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (10, 10, 'officiis', 53489, NULL, 5, 2, '2004-01-18 16:33:09', '2008-04-05 04:37:20');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (11, 1, 'eum', 9686, NULL, 1, 2, '1996-08-12 12:54:05', '1986-03-20 18:04:22');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (12, 10, 'qui', 9279238, NULL, 2, 2, '1996-02-14 10:45:14', '1994-09-23 20:45:27');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (13, 73, 'accusantium', 2977736, NULL, 3, 2, '2014-11-13 19:07:45', '1991-03-09 22:51:14');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (14, 24, 'veniam', 1245, NULL, 4, 2, '1981-08-06 23:30:51', '1993-11-24 06:16:17');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (15, 11, 'magni', 0, NULL, 5, 2, '1980-08-07 07:33:32', '2019-09-24 04:40:45');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (16, 86, 'sunt', 30192812, NULL, 1, 2, '1972-09-08 13:50:32', '1991-03-29 08:26:03');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (17, 54, 'harum', 9604, NULL, 2, 2, '1979-04-19 12:05:55', '2001-06-11 10:32:19');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (18, 69, 'rerum', 549188, NULL, 3, 2, '1998-10-02 00:17:47', '1995-07-09 17:13:13');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (19, 88, 'numquam', 76851071, NULL, 4, 2, '2004-12-30 03:48:25', '1975-09-18 07:32:47');
INSERT INTO `media` (`id`, `user_id`, `filename`, `size`, `metadata`, `media_type_id`, `entity_type_id`, `created_at`, `updated_at`) VALUES (20, 11, 'explicabo', 583, NULL, 5, 2, '1977-08-30 10:34:19', '2014-04-06 08:05:11');
COMMIT;

-- Заполняем таблицу message_statuses

INSERT INTO `message_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (1, 'et', '2017-10-15 02:42:13', '1981-01-09 10:23:59');
INSERT INTO `message_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (2, 'consequatur', '1987-06-28 08:40:09', '1986-01-01 22:53:17');
INSERT INTO `message_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (3, 'iure', '1980-02-29 14:10:48', '1971-05-28 15:37:52');
INSERT INTO `message_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (4, 'doloremque', '2002-12-01 20:25:20', '1992-02-05 02:02:21');
INSERT INTO `message_statuses` (`id`, `name`, `created_at`, `updated_at`) VALUES (5, 'voluptas', '1983-03-01 05:21:01', '1998-05-03 02:49:11');
COMMIT;

-- заполняем таблицу messages

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (1, 6, 98, 'Hardly knowing what she did, she picked her way into that beautiful garden--how IS that to be told so. \'It\'s really dreadful,\' she muttered to herself, \'whenever I eat or drink anything; so I\'ll.', 1, 1, 1, '1972-10-10 05:13:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (2, 37, 40, 'Duchess: \'flamingoes and mustard both bite. And the muscular strength, which it gave to my boy, I beat him when he sneezes: He only does it to her feet, for it flashed across her mind that she began.', 0, 2, 2, '2003-10-09 19:28:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (3, 29, 15, 'Alice, and sighing. \'It IS a Caucus-race?\' said Alice; \'living at the corners: next the ten courtiers; these were ornamented all over crumbs.\' \'You\'re wrong about the crumbs,\' said the Caterpillar.', 1, 3, 3, '2003-09-04 14:18:49');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (4, 28, 51, 'I wonder if I\'ve kept her waiting!\' Alice felt a very little use without my shoulders. Oh, how I wish you were down here with me! There are no mice in the last word with such a capital one for.', 1, 4, 4, '1975-11-28 18:16:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (5, 57, 49, 'I don\'t know,\' he went on, turning to Alice, and she felt that it was as much use in knocking,\' said the Queen, in a tone of great dismay, and began bowing to the rose-tree, she went on. Her.', 0, 5, 5, '2003-10-11 09:42:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (6, 15, 99, 'Alice after it, and burning with curiosity, she ran off at once: one old Magpie began wrapping itself up and repeat \"\'TIS THE VOICE OF THE SLUGGARD,\"\' said the Mock Turtle, who looked at each other.', 1, 1, 1, '2002-05-10 19:32:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (7, 39, 60, 'MARMALADE\', but to get through the little golden key in the sun. (IF you don\'t know one,\' said Alice. \'I\'ve read that in some alarm. This time Alice waited patiently until it chose to speak good.', 0, 2, 2, '1988-07-15 14:16:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (8, 68, 45, 'Alice heard the Queen jumped up in her haste, she had never seen such a simple question,\' added the Dormouse. \'Write that down,\' the King said, for about the temper of your flamingo. Shall I try the.', 1, 3, 3, '1996-10-05 00:43:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (9, 34, 7, 'There was a large crowd collected round it: there were a Duck and a sad tale!\' said the Queen, who had been jumping about like mad things all this grand procession, came THE KING AND QUEEN OF.', 1, 4, 4, '2007-03-09 02:35:42');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (10, 23, 94, 'Alice, \'it would be of any use, now,\' thought poor Alice, who had not long to doubt, for the hot day made her next remark. \'Then the eleventh day must have been ill.\' \'So they were,\' said the.', 0, 5, 5, '1988-08-14 20:16:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (11, 71, 14, 'Yet you finished the first figure!\' said the Dormouse shook itself, and began to say it any longer than that,\' said the Queen, \'Really, my dear, and that you have to whisper a hint to Time, and.', 1, 1, 1, '2004-08-15 22:44:43');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (12, 30, 20, 'Alice to herself, as usual. \'Come, there\'s no use speaking to it,\' she said to herself, and shouted out, \'You\'d better not talk!\' said Five. \'I heard every word you fellows were saying.\' \'Tell us a.', 1, 2, 2, '1983-11-06 17:05:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (13, 52, 94, 'And have grown most uncommonly fat; Yet you turned a back-somersault in at the Gryphon went on, \'\"--found it advisable to go on. \'And so these three weeks!\' \'I\'m very sorry you\'ve been annoyed,\'.', 0, 3, 3, '2004-10-19 05:43:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (14, 78, 19, 'Mock Turtle went on. \'We had the dish as its share of the mushroom, and raised herself to some tea and bread-and-butter, and then Alice dodged behind a great crash, as if she could see it trot away.', 1, 4, 4, '2002-08-22 02:55:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (15, 34, 50, 'WAS a narrow escape!\' said Alice, who always took a minute or two, it was over at last, more calmly, though still sobbing a little faster?\" said a sleepy voice behind her. \'Collar that Dormouse,\'.', 1, 5, 5, '2017-04-09 09:38:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (16, 54, 56, 'THAT direction,\' the Cat remarked. \'Don\'t be impertinent,\' said the King. \'When did you do either!\' And the muscular strength, which it gave to my right size: the next witness. It quite makes my.', 0, 1, 1, '1975-09-24 17:09:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (17, 45, 29, 'Alice, with a great thistle, to keep herself from being run over; and the Dormouse began in a dreamy sort of idea that they couldn\'t get them out with trying, the poor child, \'for I never was so.', 0, 2, 2, '1989-07-16 21:31:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (18, 10, 89, 'Alice thought the poor little thing sat down a jar from one minute to another! However, I\'ve got back to the jury, and the two sides of it; so, after hunting all about for some time with one foot..', 1, 3, 3, '1999-12-02 15:57:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (19, 8, 64, 'It was the first figure,\' said the Eaglet. \'I don\'t believe it,\' said Alice, seriously, \'I\'ll have nothing more to be true): If she should push the matter worse. You MUST have meant some mischief,.', 1, 4, 4, '1971-02-05 14:38:13');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (20, 11, 2, 'The first thing she heard a little ledge of rock, and, as the other.\' As soon as it is.\' \'Then you should say \"With what porpoise?\"\' \'Don\'t you mean that you couldn\'t cut off a bit of mushroom, and.', 1, 5, 5, '2016-01-14 02:44:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (21, 18, 58, 'The March Hare had just begun to repeat it, but her head down to the shore, and then Alice dodged behind a great letter, nearly as large as the soldiers did. After these came the guests, mostly.', 0, 1, 1, '1994-03-18 23:04:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (22, 88, 23, 'IN the well,\' Alice said to one of them.\' In another minute the whole pack of cards, after all. I needn\'t be so proud as all that.\' \'Well, it\'s got no business there, at any rate I\'ll never go THERE.', 0, 2, 2, '1978-08-08 17:05:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (23, 66, 20, 'Pigeon, raising its voice to its children, \'Come away, my dears! It\'s high time you were or might have been a holiday?\' \'Of course twinkling begins with an anxious look at the Mouse\'s tail; \'but why.', 0, 3, 3, '2021-04-08 13:04:41');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (24, 47, 95, 'Cat. \'Do you know I\'m mad?\' said Alice. \'Anything you like,\' said the Queen. An invitation from the shock of being upset, and their slates and pencils had been looking over his shoulder as she leant.', 1, 4, 4, '1973-12-24 00:08:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (25, 92, 5, 'I shan\'t go, at any rate: go and take it away!\' There was no label this time it vanished quite slowly, beginning with the name \'Alice!\' CHAPTER XII. Alice\'s Evidence \'Here!\' cried Alice, jumping up.', 1, 5, 5, '1996-10-26 18:42:11');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (26, 14, 62, 'No room!\' they cried out when they saw her, they hurried back to the Gryphon. \'We can do without lobsters, you know. So you see, so many tea-things are put out here?\' she asked. \'Yes, that\'s it,\'.', 1, 1, 1, '1975-05-06 08:47:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (27, 54, 85, 'HE was.\' \'I never saw one, or heard of \"Uglification,\"\' Alice ventured to remark. \'Tut, tut, child!\' said the Dormouse, who seemed to listen, the whole place around her became alive with the Lory,.', 1, 2, 2, '1976-12-21 23:02:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (28, 99, 85, 'Mock Turtle would be grand, certainly,\' said Alice hastily; \'but I\'m not the right size again; and the roof of the Gryphon, \'that they WOULD go with the words \'EAT ME\' were beautifully marked in.', 0, 3, 3, '1995-03-02 09:54:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (29, 38, 87, 'Rabbit say to itself \'Then I\'ll go round a deal faster than it does.\' \'Which would NOT be an old Turtle--we used to come before that!\' \'Call the next moment she appeared; but she could not join the.', 0, 4, 4, '1980-06-10 05:59:52');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (30, 6, 54, 'King said gravely, \'and go on crying in this way! Stop this moment, and fetch me a good many voices all talking together: she made some tarts, All on a summer day: The Knave did so, and were resting.', 0, 5, 5, '1971-01-17 21:29:20');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (31, 98, 32, 'King exclaimed, turning to Alice: he had come back and finish your story!\' Alice called after it; and while she ran, as well wait, as she swam lazily about in all directions, \'just like a.', 1, 1, 1, '1974-06-07 02:26:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (32, 78, 42, 'And the muscular strength, which it gave to my boy, I beat him when he sneezes; For he can thoroughly enjoy The pepper when he pleases!\' CHORUS. \'Wow! wow! wow!\' \'Here! you may SIT down,\' the King.', 0, 2, 2, '1970-05-13 00:20:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (33, 4, 19, 'I hadn\'t mentioned Dinah!\' she said aloud. \'I must be on the spot.\' This did not like the look of things at all, at all!\' \'Do as I tell you!\' But she waited for some way, and the two sides of it;.', 0, 3, 3, '1977-01-30 10:05:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (34, 12, 63, 'White Rabbit as he spoke. \'A cat may look at them--\'I wish they\'d get the trial done,\' she thought, and looked at the top of his shrill little voice, the name \'Alice!\' CHAPTER XII. Alice\'s Evidence.', 1, 4, 4, '2015-08-31 00:22:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (35, 65, 45, 'I\'m not the smallest notice of her favourite word \'moral,\' and the White Rabbit: it was certainly not becoming. \'And that\'s the queerest thing about it.\' \'She\'s in prison,\' the Queen left off, quite.', 1, 5, 5, '1998-01-06 09:53:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (36, 25, 68, 'Alice gave a look askance-- Said he thanked the whiting kindly, but he would deny it too: but the tops of the doors of the cattle in the other. \'I beg pardon, your Majesty,\' said Alice thoughtfully:.', 1, 1, 1, '1997-11-29 03:03:53');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (37, 25, 56, 'Alice, \'shall I NEVER get any older than you, and must know better\'; and this was his first remark, \'It was a paper label, with the time,\' she said, \'and see whether it\'s marked \"poison\" or not\';.', 0, 2, 2, '1989-01-09 10:38:22');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (38, 23, 16, 'Alice remarked. \'Right, as usual,\' said the March Hare. \'Exactly so,\' said the King, the Queen, \'and take this child away with me,\' thought Alice, and she swam nearer to watch them, and the three.', 0, 3, 3, '1997-10-18 20:54:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (39, 96, 38, 'WOULD twist itself round and swam slowly back again, and the fan, and skurried away into the garden. Then she went hunting about, and shouting \'Off with her head!\' about once in a great thistle, to.', 0, 4, 4, '2014-12-06 12:12:14');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (40, 59, 38, 'While the Panther received knife and fork with a great crowd assembled about them--all sorts of little pebbles came rattling in at the Caterpillar\'s making such VERY short remarks, and she at once.', 1, 5, 5, '1985-07-01 06:18:24');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (41, 86, 67, 'Alice coming. \'There\'s PLENTY of room!\' said Alice a little queer, won\'t you?\' \'Not a bit,\' she thought it must be getting somewhere near the King had said that day. \'That PROVES his guilt,\' said.', 0, 1, 1, '1971-07-21 00:36:16');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (42, 32, 44, 'And yet I wish I hadn\'t quite finished my tea when I grow up, I\'ll write one--but I\'m grown up now,\' she said, \'for her hair goes in such a wretched height to rest her chin upon Alice\'s shoulder,.', 1, 2, 2, '2017-04-26 17:54:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (43, 94, 65, 'As she said to herself, \'after such a new kind of authority among them, called out, \'First witness!\' The first thing I\'ve got to come before that!\' \'Call the next witness!\' said the Hatter, and he.', 0, 3, 3, '1997-09-05 07:29:08');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (44, 17, 29, 'England the nearer is to France-- Then turn not pale, beloved snail, but come and join the dance? Will you, won\'t you join the dance?\"\' \'Thank you, it\'s a very decided tone: \'tell her something.', 0, 4, 4, '1985-07-21 00:44:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (45, 80, 71, 'ARE OLD, FATHER WILLIAM,\"\' said the Rabbit whispered in reply, \'for fear they should forget them before the trial\'s begun.\' \'They\'re putting down their names,\' the Gryphon went on, \'What\'s your.', 0, 5, 5, '2017-01-04 07:53:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (46, 77, 42, 'I\'m a hatter.\' Here the other side, the puppy began a series of short charges at the sides of it, and on it were white, but there were no tears. \'If you\'re going to remark myself.\' \'Have you guessed.', 0, 1, 1, '2017-04-23 09:44:55');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (47, 32, 81, 'Presently the Rabbit whispered in reply, \'for fear they should forget them before the trial\'s begun.\' \'They\'re putting down their names,\' the Gryphon said, in a court of justice before, but she saw.', 0, 2, 2, '1977-05-31 00:38:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (48, 98, 92, 'She soon got it out loud. \'Thinking again?\' the Duchess said in a helpless sort of circle, (\'the exact shape doesn\'t matter,\' it said,) and then unrolled the parchment scroll, and read as follows:--.', 1, 3, 3, '2013-07-30 22:52:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (49, 54, 13, 'Dinah, if I know THAT well enough; don\'t be nervous, or I\'ll have you executed.\' The miserable Hatter dropped his teacup instead of onions.\' Seven flung down his brush, and had no idea how confusing.', 1, 4, 4, '2010-10-04 21:57:29');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (50, 95, 48, 'Cat went on, half to herself, as she had put the hookah into its eyes were getting so thin--and the twinkling of the accident, all except the King, \'that saves a world of trouble, you know, this.', 0, 5, 5, '2018-12-29 02:40:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (51, 37, 12, 'Cat. \'I said pig,\' replied Alice; \'and I wish I hadn\'t to bring but one; Bill\'s got the other--Bill! fetch it here, lad!--Here, put \'em up at this corner--No, tie \'em together first--they don\'t.', 0, 1, 1, '1999-09-30 02:28:33');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (52, 41, 38, 'And she kept fanning herself all the same, the next verse.\' \'But about his toes?\' the Mock Turtle sang this, very slowly and sadly:-- \'\"Will you walk a little sharp bark just over her head struck.', 1, 2, 2, '1989-01-01 03:57:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (53, 56, 71, 'Alice, always ready to make out what she was going to be, from one minute to another! However, I\'ve got to the door, and the Dormouse went on, \'if you don\'t know of any one; so, when the White.', 0, 3, 3, '1997-03-18 13:04:35');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (54, 99, 100, 'Turtle a little scream of laughter. \'Oh, hush!\' the Rabbit say to itself, \'Oh dear! Oh dear! I wish you could only see her. She is such a wretched height to rest her chin upon Alice\'s shoulder, and.', 0, 4, 4, '1975-02-15 07:34:36');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (55, 6, 72, 'Hatter replied. \'Of course not,\' Alice replied very gravely. \'What else had you to get out again. That\'s all.\' \'Thank you,\' said the Gryphon, half to Alice. \'Nothing,\' said Alice. \'Nothing.', 1, 5, 5, '2014-06-06 17:52:38');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (56, 69, 78, 'Alice\'s first thought was that you never had fits, my dear, I think?\' \'I had NOT!\' cried the Mouse, in a hurry. \'No, I\'ll look first,\' she said, \'for her hair goes in such a thing as a boon, Was.', 0, 1, 1, '1992-06-11 01:51:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (57, 15, 51, 'Caterpillar. Here was another long passage, and the three gardeners, but she ran off at once, in a sorrowful tone; \'at least there\'s no meaning in it,\' said Five, \'and I\'ll tell you just now what.', 1, 2, 2, '1986-10-23 09:20:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (58, 55, 67, 'THAT!\' \'Oh, you can\'t help it,\' she said aloud. \'I shall sit here,\' the Footman continued in the face. \'I\'ll put a white one in by mistake; and if it wasn\'t very civil of you to set them free,.', 0, 3, 3, '1999-06-08 22:07:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (59, 59, 94, 'Said the mouse doesn\'t get out.\" Only I don\'t care which happens!\' She ate a little worried. \'Just about as much as she spoke. \'I must be growing small again.\' She got up this morning? I almost wish.', 1, 4, 4, '2015-08-25 08:29:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (60, 1, 87, 'Alice went on, spreading out the proper way of keeping up the chimney, and said to herself, \'Which way? Which way?\', holding her hand again, and Alice joined the procession, wondering very much at.', 1, 5, 5, '2020-10-27 21:33:44');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (61, 53, 77, 'Alice thought she had nibbled some more bread-and-butter--\' \'But what am I to do such a tiny little thing!\' said Alice, \'a great girl like you,\' (she might well say this), \'to go on till you come to.', 0, 1, 1, '1993-07-10 13:23:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (62, 6, 87, 'Mouse, in a Little Bill It was as steady as ever; Yet you finished the first day,\' said the cook. The King looked anxiously at the window.\' \'THAT you won\'t\' thought Alice, \'and those twelve.', 1, 2, 2, '2004-03-02 07:33:19');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (63, 15, 9, 'It was high time you were down here with me! There are no mice in the kitchen. \'When I\'M a Duchess,\' she said this, she came suddenly upon an open place, with a melancholy way, being quite unable to.', 0, 3, 3, '1981-06-02 09:56:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (64, 85, 67, 'AT ALL. Soup does very well as she ran. \'How surprised he\'ll be when he finds out who was beginning to get in at the door of which was immediately suppressed by the time he had a large caterpillar,.', 1, 4, 4, '2013-08-18 03:46:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (65, 21, 93, 'I\'ve nothing to do: once or twice, half hoping that the hedgehog a blow with its eyelids, so he with his nose, you know?\' \'It\'s the first sentence in her brother\'s Latin Grammar, \'A mouse--of a.', 1, 5, 5, '1987-10-22 09:01:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (66, 13, 33, 'THAT direction,\' the Cat remarked. \'Don\'t be impertinent,\' said the Duchess, \'chop off her head!\' Alice glanced rather anxiously at the time he was speaking, and this was her dream:-- First, she.', 0, 1, 1, '2010-04-06 08:02:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (67, 59, 58, 'Alice had learnt several things of this ointment--one shilling the box-- Allow me to sell you a couple?\' \'You are old,\' said the Hatter. \'You might just as if a dish or kettle had been broken to.', 1, 2, 2, '1972-10-25 00:18:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (68, 72, 85, 'What WILL become of me? They\'re dreadfully fond of pretending to be a very interesting dance to watch,\' said Alice, \'and if it wasn\'t trouble enough hatching the eggs,\' said the Dormouse. \'Write.', 0, 3, 3, '1980-03-08 23:32:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (69, 44, 61, 'But said I didn\'t!\' interrupted Alice. \'You are,\' said the King, and the little door was shut again, and did not at all a proper way of settling all difficulties, great or small. \'Off with her head.', 0, 4, 4, '2012-09-04 04:54:04');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (70, 32, 67, 'WOULD put their heads down and began bowing to the other, and growing sometimes taller and sometimes she scolded herself so severely as to size,\' Alice hastily replied; \'at least--at least I know I.', 0, 5, 5, '1977-09-29 13:23:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (71, 39, 47, 'Alice crouched down among the trees as well say,\' added the Hatter, \'when the Queen merely remarking as it could go, and broke off a head unless there was silence for some minutes. Alice thought to.', 1, 1, 1, '1992-01-05 06:49:10');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (72, 46, 38, 'They had not the right size for ten minutes together!\' \'Can\'t remember WHAT things?\' said the Hatter, \'or you\'ll be asleep again before it\'s done.\' \'Once upon a Gryphon, lying fast asleep in the.', 1, 2, 2, '1997-12-24 18:06:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (73, 78, 43, 'So she set to work shaking him and punching him in the air. \'--as far out to her full size by this time, and was suppressed. \'Come, that finished the goose, with the Queen, in a natural way again..', 1, 3, 3, '1996-11-29 14:38:21');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (74, 53, 45, 'Hatter were having tea at it: a Dormouse was sitting between them, fast asleep, and the Queen, who was beginning to think about it, you may nurse it a minute or two. \'They couldn\'t have done that?\'.', 1, 4, 4, '2004-03-20 03:27:40');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (75, 12, 47, 'QUITE as much as she could. \'The Dormouse is asleep again,\' said the Queen, tossing her head in the lap of her sharp little chin into Alice\'s head. \'Is that all?\' said Alice, who felt ready to make.', 0, 5, 5, '1982-01-25 14:24:18');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (76, 86, 81, 'Good-bye, feet!\' (for when she had put the Dormouse went on, \'\"--found it advisable to go on crying in this way! Stop this moment, and fetch me a good deal until she made her feel very queer to ME.\'.', 0, 1, 1, '2009-03-10 09:53:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (77, 70, 95, 'Stop this moment, I tell you, you coward!\' and at once to eat or drink something or other; but the tops of the garden: the roses growing on it but tea. \'I don\'t quite understand you,\' she said,.', 0, 2, 2, '2015-11-06 08:04:59');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (78, 90, 85, 'Alice for protection. \'You shan\'t be beheaded!\' \'What for?\' said the King. (The jury all looked so grave and anxious.) Alice could hear him sighing as if she was up to her that she was a little.', 1, 3, 3, '1997-03-27 17:58:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (79, 33, 55, 'PRECIOUS nose\'; as an explanation; \'I\'ve none of them even when they passed too close, and waving their forepaws to mark the time, while the rest of my own. I\'m a hatter.\' Here the Queen till she.', 0, 4, 4, '1972-07-24 07:20:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (80, 26, 1, 'Dormouse go on for some minutes. Alice thought to herself. (Alice had been to the Gryphon. \'It\'s all his fancy, that: he hasn\'t got no sorrow, you know. So you see, Alice had got its head.', 0, 5, 5, '1996-11-21 05:50:02');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (81, 52, 20, 'Alice, they all crowded round her, calling out in a hot tureen! Who for such a noise inside, no one to listen to her. \'I can see you\'re trying to box her own ears for having cheated herself in the.', 0, 1, 1, '1990-10-15 23:09:00');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (82, 70, 74, 'There are no mice in the long hall, and close to the end of the house, and have next to no toys to play croquet.\' The Frog-Footman repeated, in the chimney as she couldn\'t answer either question, it.', 1, 2, 2, '2009-09-06 14:59:50');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (83, 52, 29, 'Alice in a bit.\' \'Perhaps it doesn\'t matter a bit,\' she thought it would not join the dance. \'\"What matters it how far we go?\" his scaly friend replied. \"There is another shore, you know, this sort.', 1, 3, 3, '1979-10-30 20:32:51');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (84, 24, 47, 'Queen, who were all in bed!\' On various pretexts they all looked puzzled.) \'He must have got altered.\' \'It is a raven like a candle. I wonder who will put on his spectacles and looked along the.', 1, 4, 4, '2013-01-24 06:33:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (85, 14, 30, 'Gryphon is, look at them--\'I wish they\'d get the trial done,\' she thought, \'till its ears have come, or at any rate, the Dormouse indignantly. However, he consented to go through next walking about.', 1, 5, 5, '1992-04-18 07:16:06');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (86, 47, 100, 'THIS witness.\' \'Well, if I chose,\' the Duchess by this time, as it went. So she set to work very diligently to write this down on one side, to look down and looked at it gloomily: then he dipped it.', 1, 1, 1, '1991-01-02 10:02:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (87, 40, 82, 'Mouse in the same age as herself, to see that queer little toss of her head in the sea. But they HAVE their tails in their mouths; and the little golden key in the same thing with you,\' said the.', 0, 2, 2, '1982-06-06 21:22:08');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (88, 34, 36, 'Rabbit say, \'A barrowful will do, to begin again, it was perfectly round, she came up to her feet as the Rabbit, and had no pictures or conversations?\' So she began: \'O Mouse, do you know what to.', 0, 3, 3, '1993-09-03 00:45:48');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (89, 63, 75, 'Alice. \'Did you say pig, or fig?\' said the Gryphon, and, taking Alice by the English, who wanted leaders, and had to leave off this minute!\' She generally gave herself very good advice, (though she.', 0, 4, 4, '2000-10-29 06:07:31');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (90, 86, 90, 'King and the Mock Turtle sighed deeply, and began, in rather a handsome pig, I think.\' And she began again: \'Ou est ma chatte?\' which was full of smoke from one of them can explain it,\' said Alice..', 1, 5, 5, '1999-07-31 03:47:32');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (91, 23, 53, 'Alice: \'allow me to sell you a couple?\' \'You are all dry, he is gay as a cushion, resting their elbows on it, for she had not a moment like a star-fish,\' thought Alice. One of the jurymen. \'No,.', 0, 1, 1, '2019-05-17 05:11:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (92, 54, 42, 'Alice. The King turned pale, and shut his note-book hastily. \'Consider your verdict,\' he said in a low voice, \'Why the fact is, you ARE a simpleton.\' Alice did not come the same when I got up very.', 0, 2, 2, '1994-03-16 06:17:46');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (93, 25, 76, 'Lory, with a shiver. \'I beg pardon, your Majesty,\' said Two, in a very grave voice, \'until all the party sat silent for a great hurry; \'and their names were Elsie, Lacie, and Tillie; and they went.', 1, 3, 3, '2014-04-04 06:52:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (94, 6, 43, 'I used--and I don\'t think,\' Alice went on, yawning and rubbing its eyes, for it to be said. At last the Mouse, frowning, but very politely: \'Did you say pig, or fig?\' said the young lady tells us a.', 1, 4, 4, '2018-04-17 11:13:12');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (95, 3, 4, 'They are waiting on the stairs. Alice knew it was indeed: she was quite silent for a conversation. Alice felt a violent shake at the sides of the other arm curled round her head. Still she went on.', 0, 5, 5, '2014-06-29 06:14:07');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (96, 6, 85, 'He looked at it, busily painting them red. Alice thought she might as well to say whether the pleasure of making a daisy-chain would be the right word) \'--but I shall be punished for it flashed.', 0, 1, 1, '1993-11-15 22:26:27');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (97, 71, 100, 'In a little glass table. \'Now, I\'ll manage better this time,\' she said to herself. \'Shy, they seem to put the Lizard in head downwards, and the jury wrote it down \'important,\' and some were birds,).', 1, 2, 2, '2001-02-24 07:08:39');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (98, 87, 28, 'Duchess, \'chop off her knowledge, as there was a most extraordinary noise going on between the executioner, the King, who had got its head to hide a smile: some of them at last, with a large pool.', 0, 3, 3, '1993-04-29 13:55:01');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (99, 18, 51, 'Gryphon. \'It all came different!\' the Mock Turtle, \'they--you\'ve seen them, of course?\' \'Yes,\' said Alice, very much at first, but, after watching it a very fine day!\' said a whiting to a mouse, you.', 1, 4, 4, '2000-05-29 16:10:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `is_important`, `status_id`, `entity_type_id`, `created_at`) VALUES (100, 97, 86, 'Gryphon, and, taking Alice by the prisoner to--to somebody.\' \'It must be getting home; the night-air doesn\'t suit my throat!\' and a sad tale!\' said the Mouse. \'--I proceed. \"Edwin and Morcar, the.', 0, 5, 5, '1998-07-08 05:31:23');
COMMIT;

-- Заполняем entity
/*
INSERT INTO `entity` (entity_type_id, created_by) VALUES ( ROUND(RAND()+1), ROUND(RAND()*100) ); 
*/

-- Warning!!! Посмотреть - или здесь не нужен автор-владелец, или в исходном элементе
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 1, 1, 10 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 1, 2, 11 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 2, 1, 12 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 1, 2, 13 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 1, 14 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 2, 15 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 4, 1, 16 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 5, 1, 17 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 6, 1, 18 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 4, 2, 19 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 7, 1, 20 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 8, 1, 25 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 9, 1, 26 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 10, 1, 27 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 11, 1, 28 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 12, 1, 29 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 13, 1, 30 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 14, 1, 10 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 5, 2, 11 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 6, 2, 12 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 15, 1, 13 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 7, 2, 14 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 16, 1, 15 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 17, 1, 16 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 18, 1, 17 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 8, 2, 18 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 9, 2, 19 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 10, 2, 20 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 19, 1, 25 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 20, 1, 26 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 21, 1, 27 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 1, 28 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 1, 29 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 1, 30 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 5, 1, 29 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 5, 1, 30 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 11, 1, 60 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 22, 1, 61 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 23, 1, 62 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 23, 1, 63 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 23, 1, 74 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 33, 1, 75 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 33, 1, 76 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 33, 1, 87 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 33, 1, 88 ); 

INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 41, 1, 26 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 41, 1, 37 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 51, 1, 38 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 51, 1, 39 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 51, 1, 30 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 52, 1, 40 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 52, 1, 41 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 53, 1, 32 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 54, 1, 33 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 54, 1, 14 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 55, 1, 5 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 55, 1, 6 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 55, 1, 17 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 55, 1, 18 ); 

INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 1, 2, 29 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 1, 2, 30 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 2, 2, 10 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 2, 11 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 3, 2, 22 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 4, 2, 23 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 4, 2, 24 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 5, 2, 35 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 6, 2, 16 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 8, 2, 37 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 10, 2, 8 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 15, 2, 9 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 19, 2, 50 ); 
INSERT INTO `entity` (entity_id, entity_type_id, created_by) VALUES ( 19, 2, 5 ); 

COMMIT;




