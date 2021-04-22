-- Создание БД для социальной сети ВКонтакте
-- https://vk.com/geekbrainsru
-- ДЗ №8

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


        
 -- Таблица сущностей, к которым можно привязывать другие объекты, такие как: лайки, и т д и т п. На данный момент ссылается на messages и media       

CREATE TABLE entity (
-- 	entity_id	INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT "Идентификатор сущности",
 	entity_id	INT UNSIGNED NOT NULL COMMENT "Идентификатор сущности (на данный момент это messages(id) или media(id)",
    entity_type_id INT UNSIGNED NOT NULL COMMENT "Идентификатор типа сущности entity_types id",
    created_by INTEGER UNSIGNED NOT NULL COMMENT "Идентификатор автора",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания записи",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
--    PRIMARY KEY PK_entity (entity_id, entity_type_id, created_by, created_at),
    PRIMARY KEY PK_entity (entity_id, entity_type_id, created_by),
    FOREIGN KEY FK_entity_entity_types (entity_type_id) REFERENCES entity_types(id),
    FOREIGN KEY FK_entity_users (created_by) REFERENCES users(id)
) COMMENT = 'Таблица сущностей, к которым можно привязывать другие объекты, такие как: лайки, и т д и т п';

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
  entity_type_id INTEGER UNSIGNED NOT NULL DEFAULT 1,
  -- is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время создания строки",
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
  entity_type_id INT UNSIGNED NOT NULL DEFAULT 2 COMMENT 'Идентификатор типа сущьности',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  CONSTRAINT FK_media_users FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT FK_media_media_types FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  CONSTRAINT FK_media__entity_types FOREIGN KEY (entity_type_id) REFERENCES entity_types(id)
) COMMENT "Медиафайлы";


-- Таблица голосов
CREATE TABLE votes (
	entity_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор элемента',
    entity_type_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор типа сущности entity_types id',
    created_by INTEGER UNSIGNED NOT NULL COMMENT 'Идентификатор автора сущности',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания записи',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
    vote_created_by INTEGER UNSIGNED NOT NULL COMMENT 'Идентификатор проголосовавшего',
    is_tumb_up TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 - tumb is up, 0 - tumb is down',
    CONSTRAINT PK_votes PRIMARY KEY (entity_id, entity_type_id, created_by, created_at),
    CONSTRAINT FK_votes_entity_id FOREIGN KEY (entity_id) REFERENCES entity(entity_id),
    CONSTRAINT FK_votes__users_id FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT FK_votes__users_id2 FOREIGN KEY (vote_created_by) REFERENCES users(id)
) COMMENT = 'Голоса (лайки)'; 