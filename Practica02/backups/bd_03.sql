CREATE DATABASE  IF NOT EXISTS `db_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_test`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_users` varchar(80) NOT NULL,
  `description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=1, email=carlos.ramirez@ejemplo.com, nickname=Carlos','2026-09-10 11:05:11',_binary ''),(2,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=2, email=ana.valdez@ejemplo.com, nickname=Ana','2026-09-10 11:09:37',_binary ''),(3,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=3, email=miguel.angel@ejemplo.com, nickname=Miguel','2026-09-10 11:09:37',_binary ''),(4,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=4, email=sofia.torres@ejemplo.com, nickname=Sofia','2026-09-10 11:09:37',_binary ''),(5,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=5, email=diego.luna@ejemplo.com, nickname=Diego','2026-09-10 11:09:37',_binary ''),(6,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=6, email=laura.gomez@ejemplo.com, nickname=Laura','2026-09-10 11:09:37',_binary ''),(7,'tb_users','Create','carlos.alberto@%','Usuario creado. ID=7, email=pedro.perez@ejemplo.com, nickname=Pedro','2026-09-10 11:45:41',_binary ''),(8,'tb_users','Delete','carlos.alberto@%','Usuario eliminado. ID=3, email=miguel.angel@ejemplo.com, nickname=Miguel','2026-09-10 11:48:05',_binary ''),(16,'tb_products','Create','uriel.gonzalez.izquierda@192.168.1.85','Producto creado. ID=13, SKU=PROD-001, nombre=Laptop Asus Vivobook, precio=$12500.50, stock=15','2026-09-21 21:31:45',_binary ''),(17,'tb_products','Create','uriel.gonzalez.izquierda@192.168.1.85','Producto creado. ID=14, SKU=PROD-002, nombre=Mouse Logitech G203, precio=$350.00, stock=40','2026-09-21 21:31:45',_binary ''),(18,'tb_products','Create','uriel.gonzalez.izquierda@192.168.1.85','Producto creado. ID=15, SKU=PROD-003, nombre=Teclado Mecánico, precio=$899.99, stock=10','2026-09-21 21:31:45',_binary ''),(19,'tb_products','Update','uriel.gonzalez.izquierda@192.168.1.85','Producto actualizado. ID=13, SKU=PROD-001, nombre=Laptop Asus Vivobook, precio=$11999.00, stock=13','2026-09-21 21:31:45',_binary ''),(20,'tb_products','Delete','uriel.gonzalez.izquierda@192.168.1.85','Producto eliminado. ID=14, SKU=PROD-002, nombre=Mouse Logitech G203, precio=$350.00, stock=40','2026-09-21 21:31:45',_binary ''),(21,'tb_products','Create','lalo.amaro@PC-13','Producto creado. ID=16, SKU=LAP-DEL-G15, nombre=Laptop Gaming Dell G15 5530, precio=$24999.00, stock=15','2026-09-22 10:43:05',_binary ''),(22,'tb_products','Create','lalo.amaro@PC-13','Producto creado. ID=17, SKU=MON-LG-27GP, nombre=Monitor Gamer LG UltraGear 27GP850-B, precio=$7899.50, stock=22','2026-09-22 10:43:05',_binary ''),(23,'tb_products','Create','lalo.amaro@PC-13','Producto creado. ID=18, SKU=KEY-LOG-GMX, nombre=Teclado Mecánico Logitech G PRO X TKL, precio=$3499.00, stock=40','2026-09-22 10:43:05',_binary ''),(24,'tb_products','Create','lalo.amaro@PC-13','Producto creado. ID=19, SKU=MOU-RAZ-V3P, nombre=Mouse Inalámbrico Razer Viper V3 Pro, precio=$2999.99, stock=30','2026-09-22 10:43:05',_binary ''),(25,'tb_products','Create','lalo.amaro@PC-13','Producto creado. ID=20, SKU=AUD-HYP-CW2, nombre=Audífonos Gamer HyperX Cloud II Wireless, precio=$2150.00, stock=18','2026-09-22 10:43:05',_binary ''),(26,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=1, SKU=PROD-001, nombre=Laptop Asus Vivobook, precio=$11999.00, stock=13','2026-09-22 10:46:12',_binary ''),(27,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=2, SKU=PROD-003, nombre=Teclado Mecánico, precio=$899.99, stock=10','2026-09-22 10:46:12',_binary ''),(28,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=3, SKU=LAP-DEL-G15, nombre=Laptop Gaming Dell G15 5530, precio=$24999.00, stock=15','2026-09-22 10:46:12',_binary ''),(29,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=4, SKU=MON-LG-27GP, nombre=Monitor Gamer LG UltraGear 27GP850-B, precio=$7899.50, stock=22','2026-09-22 10:46:12',_binary ''),(30,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=5, SKU=KEY-LOG-GMX, nombre=Teclado Mecánico Logitech G PRO X TKL, precio=$3499.00, stock=40','2026-09-22 10:46:12',_binary ''),(31,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=6, SKU=MOU-RAZ-V3P, nombre=Mouse Inalámbrico Razer Viper V3 Pro, precio=$2999.99, stock=30','2026-09-22 10:46:12',_binary ''),(32,'tb_products','Update','carlos.alberto@%','Producto actualizado. ID=7, SKU=AUD-HYP-CW2, nombre=Audífonos Gamer HyperX Cloud II Wireless, precio=$2150.00, stock=18','2026-09-22 10:46:12',_binary ''),(33,'tb_products','Create','carlos.alberto@%','Producto creado. ID=8, SKU=MOU-LOG-01, nombre=Mouse Inalámbrico Logitech M170, precio=$249.00, stock=25','2026-09-22 10:55:33',_binary ''),(34,'tb_users','Create','cris.escamilla.derecha@PC-11','Usuario creado. ID=8, email=valeria.gomez@gmail.com, nickname=val_gomez','2026-09-22 11:32:35',_binary ''),(35,'tb_users','Create','cris.escamilla.derecha@PC-11','Usuario creado. ID=9, email=alejandro.torres@gmail.com, nickname=alex_torres','2026-09-22 11:32:35',_binary ''),(36,'tb_users','Create','cris.escamilla.derecha@PC-11','Usuario creado. ID=10, email=sofia.ramirez@gmail.com, nickname=sofia_ram','2026-09-22 11:32:35',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Laptop Asus Vivobook','16GB RAM, 512GB SSD',11999.00,13,_binary '','2026-09-21 21:31:45','2026-09-22 10:46:12'),(2,'PROD-003','Teclado Mecánico','Switches red, formato 60%',899.99,10,_binary '','2026-09-21 21:31:45','2026-09-22 10:46:12'),(3,'LAP-DEL-G15','Laptop Gaming Dell G15 5530','Procesador Intel Core i7-13650HX, 16GB RAM DDR5, SSD 1TB NVMe, Pantalla 15.6 FHD 165Hz, NVIDIA GeForce RTX 4060 8GB, Windows 11 Home.',24999.00,15,_binary '','2026-09-22 10:43:05','2026-09-22 10:46:12'),(4,'MON-LG-27GP','Monitor Gamer LG UltraGear 27GP850-B','Monitor de 27 pulgadas QHD (2560x1440), Panel Nano IPS, Tiempo de respuesta 1ms GTG, Tasa de refresco 165Hz (OC 180Hz), Compatible con NVIDIA G-Sync y AMD FreeSync Premium.',7899.50,22,_binary '','2026-09-22 10:43:05','2026-09-22 10:46:12'),(5,'KEY-LOG-GMX','Teclado Mecánico Logitech G PRO X TKL','Teclado inalámbrico compacto para esports con tecnología LIGHTSPEED, interruptores mecánicos Tactile, iluminación RGB LIGHTSYNC por tecla y conectividad Bluetooth.',3499.00,40,_binary '','2026-09-22 10:43:05','2026-09-22 10:46:12'),(6,'MOU-RAZ-V3P','Mouse Inalámbrico Razer Viper V3 Pro','Mouse ultra liviano de 54 gramos para eSports, Sensor óptico Focus Pro de 35,000 DPI, Switches ópticos de 3ra generación y tasa de sondeo real de 8000Hz.',2999.99,30,_binary '','2026-09-22 10:43:05','2026-09-22 10:46:12'),(7,'AUD-HYP-CW2','Audífonos Gamer HyperX Cloud II Wireless','Audífonos inalámbricos con sonido envolvente DTS Headphone:X Spatial Audio, altavoces de 53mm, almohadillas de espuma viscoelástica y batería de hasta 30 horas.',2150.00,18,_binary '','2026-09-22 10:43:05','2026-09-22 10:46:12'),(8,'MOU-LOG-01','Mouse Inalámbrico Logitech M170','Mouse óptico con conectividad USB de 2.4 GHz y diseño ambidextro',249.00,25,_binary '','2026-09-22 10:55:33','2026-09-22 10:55:33');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_tb_products` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT('Producto creado. ID=', NEW.ID, ', SKU=', NEW.SKU, ', nombre=', NEW.name, ', precio=$', NEW.current_price, ', stock=', NEW.current_stock)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_update_tb_products` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT('Producto actualizado. ID=', NEW.ID, ', SKU=', NEW.SKU, ', nombre=', NEW.name, ', precio=$', NEW.current_price, ', stock=', NEW.current_stock)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_delete_tb_products` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT('Producto eliminado. ID=', OLD.ID, ', SKU=', OLD.SKU, ', nombre=', OLD.name, ', precio=$', OLD.current_price, ', stock=', OLD.current_stock)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (1,'carlos.ramirez@ejemplo.com','Carlos','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:05:11','2026-09-10 11:05:11',NULL),(2,'ana.valdez@ejemplo.com','Ana','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:09:37','2026-09-10 11:09:37',NULL),(4,'sofia.torres@ejemplo.com','Sofia','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:09:37','2026-09-10 11:09:37',NULL),(5,'diego.luna@ejemplo.com','Diego','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:09:37','2026-09-10 11:09:37',NULL),(6,'laura.gomez@ejemplo.com','Laura','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:09:37','2026-09-10 11:09:37',NULL),(7,'pedro.perez@ejemplo.com','Pedro','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','2026-09-10 11:45:41','2026-09-10 11:45:41',NULL),(8,'valeria.gomez@gmail.com','val_gomez','97477a405ba5e251353af8a03563193d1ee58c6e19ccb832faa62c767aed838a','2026-09-22 11:32:35','2026-09-22 11:32:35',NULL),(9,'alejandro.torres@gmail.com','alex_torres','3c5dec459879f6271cf3de012c6b1e3e05ec7b38fafe3ad35ca1d75aecd56036','2026-09-22 11:32:35','2026-09-22 11:32:35',NULL),(10,'sofia.ramirez@gmail.com','sofia_ram','a593c1056b77e50e4f29885269756bc734adc682a3aeee868c98e39790420575','2026-09-22 11:32:35','2026-09-22 11:32:35',NULL);
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_tb_users` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_users',
        'Create',
        USER(),
        CONCAT('Usuario creado. ID=', NEW.ID, ', email=', NEW.email, ', nickname=', NEW.nickname)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_update_tb_users` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_users',
        'Update',
        USER(),
        CONCAT('Usuario actualizado. ID=', NEW.ID, ', email=', NEW.email, ', nickname=', NEW.nickname)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_delete_tb_users` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CONCAT('Usuario eliminado. ID=', OLD.ID, ', email=', OLD.email, ', nickname=', OLD.nickname)
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'db_test'
--

--
-- Dumping routines for database 'db_test'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-22 11:47:06
