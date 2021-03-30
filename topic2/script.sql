/*

Практическое задание по теме “Управление БД”
1. Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и 	пароль, который указывался при 	установке.
2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

*/


/*
1. Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и 	пароль, который указывался при 	установке.
*/

[client]
user=root
password=my8sql


/*
2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/

-- mysql -u root -p

/* Выводим текущий список БД 
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| shop               |
| sys                |
+--------------------+
8 rows in set (0.00 sec)
*/

-- Создаем базу данных example 
CREATE DATABASE IF NOT EXISTS example;
-- Query OK, 1 row affected (0.00 sec)

/* Выводим текущий список БД 

SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| example            |
| information_schema |
| mysql              |
| performance_schema |
| shop               |
| sys                |
+--------------------+
8 rows in set (0.00 sec)
*/
-- use example;
-- Database changed

/* Создаем таблицу users  */
CREATE TABLE users ( id SERIAL PRIMARY KEY, name VARCHAR(255) );
-- Query OK, 0 rows affected (0.01 sec)


/*
3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
*/

-- mysqldump -u root -p example > ./example.dump

-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: example
-- ------------------------------------------------------
-- Server version	8.0.23-0ubuntu0.20.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-28 21:03:47


-- Создаем БД sample
CREATE DATABASE sample;

/*
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| Test               |
| example            |
| information_schema |
| mysql              |
| performance_schema |
| shop               |
| sys                |
| vk                 |
+--------------------+
8 rows in set (0.00 sec)
*/

-- Загружаем данные дампа БД example в БД sample 
/*
 mysqldump -u root -p sample < ./example.dump
Enter password: 
-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: sample
-- ------------------------------------------------------
-- Server version	8.0.23-0ubuntu0.20.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-30  6:48:00
*/


/*
4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
*/

-- mysqldump -u root -p --opt --where="1 limit 100" mysql help_keyword > help_keyword.dump




-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: mysql
-- ------------------------------------------------------
-- Server version	8.0.23-0ubuntu0.20.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) /*!50100 TABLESPACE `mysql` */ ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 ROW_FORMAT=DYNAMIC COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_keyword`
--
-- WHERE:  1 limit 100

LOCK TABLES `help_keyword` WRITE;
/*!40000 ALTER TABLE `help_keyword` DISABLE KEYS */;
INSERT INTO `help_keyword` VALUES (108,'%'),(264,'&'),(421,'(JSON'),(86,'*'),(84,'+'),(85,'-'),(422,'->'),(424,'->>'),(87,'/'),(75,':='),(59,'<'),(266,'<<'),(58,'<='),(56,'<=>'),(57,'<>'),(55,'='),(61,'>'),(60,'>='),(267,'>>'),(90,'ABS'),(851,'ACCOUNT'),(91,'ACOS'),(655,'ACTION'),(49,'ADD'),(120,'ADDDATE'),(121,'ADDTIME'),(877,'ADMIN'),(270,'AES_DECRYPT'),(271,'AES_ENCRYPT'),(578,'AFTER'),(247,'AGAINST'),(898,'AGGREGATE'),(579,'ALGORITHM'),(718,'ALL'),(50,'ALTER'),(580,'ANALYZE'),(62,'AND'),(525,'ANY_VALUE'),(656,'ARCHIVE'),(254,'ARRAY'),(719,'AS'),(463,'ASC'),(185,'ASCII'),(92,'ASIN'),(6,'ASYMMETRIC_DECRYPT'),(7,'ASYMMETRIC_DERIVE'),(8,'ASYMMETRIC_ENCRYPT'),(9,'ASYMMETRIC_SIGN'),(10,'ASYMMETRIC_VERIFY'),(639,'AT'),(93,'ATAN'),(94,'ATAN2'),(852,'ATTRIBUTE'),(740,'AUTOCOMMIT'),(678,'AUTOEXTEND_SIZE'),(581,'AUTO_INCREMENT'),(457,'AVG'),(582,'AVG_ROW_LENGTH'),(752,'BACKUP'),(766,'BEFORE'),(741,'BEGIN'),(288,'BENCHMARK'),(63,'BETWEEN'),(186,'BIN'),(253,'BINARY'),(561,'BINLOG'),(526,'BIN_TO_UUID'),(459,'BIT_AND'),(269,'BIT_COUNT'),(187,'BIT_LENGTH'),(460,'BIT_OR'),(461,'BIT_XOR'),(17,'BOOL'),(18,'BOOLEAN'),(230,'BOTH'),(643,'BTREE'),(464,'BY'),(42,'BYTE'),(933,'CACHE'),(686,'CALL'),(496,'CAN_ACCESS_COLUMN'),(497,'CAN_ACCESS_DATABASE'),(498,'CAN_ACCESS_TABLE'),(499,'CAN_ACCESS_USER'),(500,'CAN_ACCESS_VIEW'),(657,'CASCADE'),(76,'CASE'),(255,'CAST'),(832,'CATALOG_NAME'),(95,'CEIL'),(96,'CEILING'),(742,'CHAIN'),(583,'CHANGE'),(562,'CHANNEL'),(43,'CHAR'),(39,'CHARACTER'),(189,'CHARACTER_LENGTH'),(289,'CHARSET'),(188,'CHAR_LENGTH'),(584,'CHECK');
/*!40000 ALTER TABLE `help_keyword` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-30  6:58:30
