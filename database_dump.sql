-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: pasantesrd
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.1

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
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('STUDENT','COMPANY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `internship_id` int NOT NULL,
  `status` enum('pending','reviewed','accepted','rejected') DEFAULT 'pending',
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `viewed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_application` (`student_id`,`internship_id`),
  KEY `internship_id` (`internship_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,12,1,'pending','2025-11-06 18:48:41','2025-11-06 18:48:41',NULL);
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) NOT NULL,
  `industry` varchar(100) NOT NULL,
  `company_size` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `website` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) NOT NULL,
  `contact_position` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `company_logo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `founded_year` int DEFAULT NULL,
  `verified` tinyint(1) DEFAULT '0',
  `premium_partner` tinyint(1) DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'EDAB Software Developer','tecnologia','1-10','Hello','https://www.edab.com','Chumbo','Campala','intec@mail.com','(444) 567-1234','$2b$10$3TLZpJZLxZdjcrN422TRyewfQIfRQZcPPtLbVPP9ChgOEH4g3Pzze','/uploads/company_logo-1761502147333-556517460.png','2025-10-26 18:09:07',NULL,0,0,'2025-11-07 15:14:14');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_benefits`
--

DROP TABLE IF EXISTS `company_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_benefits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `benefit` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `company_benefits_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_benefits`
--

LOCK TABLES `company_benefits` WRITE;
/*!40000 ALTER TABLE `company_benefits` DISABLE KEYS */;
INSERT INTO `company_benefits` VALUES (4,1,'Almuerzo','2025-11-07 15:14:14'),(5,1,'Flex Time','2025-11-07 15:14:14'),(6,1,'Capacitación','2025-11-07 15:14:14');
/*!40000 ALTER TABLE `company_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_locations`
--

DROP TABLE IF EXISTS `company_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `location_name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `is_remote` tinyint(1) DEFAULT '0',
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `company_locations_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_locations`
--

LOCK TABLES `company_locations` WRITE;
/*!40000 ALTER TABLE `company_locations` DISABLE KEYS */;
INSERT INTO `company_locations` VALUES (3,1,'Madrid','Apain',0,0,'2025-11-07 15:14:14'),(4,1,'France','Paris',0,1,'2025-11-07 15:14:14');
/*!40000 ALTER TABLE `company_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_statistics`
--

DROP TABLE IF EXISTS `company_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_statistics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `active_internships` int DEFAULT '0',
  `conversion_rate` decimal(5,2) DEFAULT '0.00',
  `rating` decimal(3,2) DEFAULT '0.00',
  `past_internships` int DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `company_statistics_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_statistics`
--

LOCK TABLES `company_statistics` WRITE;
/*!40000 ALTER TABLE `company_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internships`
--

DROP TABLE IF EXISTS `internships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `company_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `work_area` varchar(100) NOT NULL,
  `schedule` varchar(100) NOT NULL,
  `salary` varchar(100) DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `benefits` json DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `applicant_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_internships_company_id` (`company_id`),
  KEY `idx_internships_work_area` (`work_area`),
  KEY `idx_internships_is_active` (`is_active`),
  CONSTRAINT `fk_internships_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internships`
--

LOCK TABLES `internships` WRITE;
/*!40000 ALTER TABLE `internships` DISABLE KEYS */;
INSERT INTO `internships` VALUES (1,'Full Stack Developer','Hello ',1,'2025-11-10','2026-04-10','fullstack','remote','500$','4 months','[\"Almuerzo\", \"Transporte\", \"Seguro Médico\"]',1,0,'2025-11-01 19:36:06','2025-11-04 17:26:06'),(2,'Full Stack Developer','Hello ',1,'2025-11-13','2025-03-14','sales','remote','500$','4 months','[\"Almuerzo\", \"Transporte\", \"Seguro Médico\"]',0,0,'2025-11-01 19:40:29','2025-11-04 17:26:57');
/*!40000 ALTER TABLE `internships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `user_role` enum('student','company') NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `internship_id` int DEFAULT NULL,
  `application_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `internship_id` (`internship_id`),
  KEY `application_id` (`application_id`),
  KEY `idx_user` (`user_id`,`user_role`),
  KEY `idx_created` (`created_at`),
  KEY `idx_read` (`is_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'company','new_application','Nueva Aplicación Recibida','Mogo aplicó a \"Full Stack Developer\"',1,1,1,'2025-11-06 18:48:41'),(2,12,'student','application_submitted','Aplicación Enviada','Aplicaste exitosamente a \"Full Stack Developer\"',1,1,1,'2025-11-06 18:48:42');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `optional_email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  `university` varchar(255) NOT NULL,
  `career` varchar(255) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `gpa` decimal(3,2) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `student_card` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `skills` json DEFAULT NULL,
  `languages` json DEFAULT NULL,
  `profile_image_url` varchar(500) DEFAULT NULL,
  `cv_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'Charles Mendez','charles@gmail.com','charles1@gmail.com','(406) 456-6374','Madrid University','Student','first',4.00,'$2b$10$rQe288/Wc.9B4XaoWhCOxujtbaBmkoJtaD/ScOE39OKFA2wwhGR9i','/uploads/student_card-1760479375244-772528762.png','2025-10-14 22:02:55',NULL,NULL,NULL,NULL),(2,'Charles Mendez','charles1@gmail.com','charles2@gmail.com','(406)456374','Madrid University','Student','second',3.00,'$2b$10$jy4kqPW8/QCfG4alVOH5Luu9tAdlC3u.Q1Xex8GWuN7PmLU7mWp5.',NULL,'2025-10-14 22:16:58',NULL,NULL,NULL,NULL),(3,'Abubeker Taha','abu@gmail.com',NULL,'(251) 9681431','Addis Ababa','Student','Second',3.00,'$2b$10$2NWhz5KmBOALy1nMugW3nO6H9WgcbIwSbseGqPt93HZ8LalOoFywC','/uploads/student_card-1760500414124-961958812.png','2025-10-15 03:53:34',NULL,NULL,NULL,NULL),(4,'Abubeker','abubekertaha@gmail.com',NULL,'(251)968318913','Addis Ababa','Student','Second',4.00,'$2b$10$U9yTxIWfUGiw8gGZaJTOAupIidgL.c7JaabQp/XS0PGtJAeNso.NC','/uploads/student_card-1760500779242-912445899.png','2025-10-15 03:59:39',NULL,NULL,NULL,NULL),(5,'Jams','jams@gmail.com',NULL,'(+123) 786543','Kuba','Student','First',4.00,'$2b$10$Rxtzmb.Jjk4X1QDCTPCQcu.kibVeV4HKPWEH1BGX5ue3aXTYeJHGK','/uploads/student_card-1760683661425-906160097.png','2025-10-17 06:47:42',NULL,NULL,NULL,NULL),(6,'Aga','aga@gmail.com',NULL,'(251) 6754 7843','Addis Ababa','Student','Second',3.00,'$2b$10$olkfy79z9teMCq3ZtrAQZ.ysmLHAxKRZygdJWYUTkKnlScbM8w4FG',NULL,'2025-10-18 08:28:48',NULL,NULL,NULL,NULL),(7,'Abubeker','abubeker.taha@a2sv.org',NULL,'(564) 8967-1234','Madrid','Software Developer','Second',3.00,'$2b$10$Qp6iSpytmKqAdC3J2vonuu4TOppZMhPYCcTmlOoP6KQ1gJezotL12',NULL,'2025-10-18 15:52:52',NULL,NULL,NULL,NULL),(8,'Jacob','jacob@mail.coom',NULL,'(654) 3452 654','MIT','ML Student','First',3.48,'$2b$10$FLEw2Wpfuo9cfv5ZeNSLteJrY4v.yAR0AudSRdeW64SK6dWYyq9CS','/uploads/student_card-1760863841821-41432212.png','2025-10-19 08:50:43',NULL,NULL,NULL,NULL),(9,'Dev','dev@mail.com',NULL,'(546) 1234 567','MIT','ML Student','4',3.48,'$2b$10$NUoHgeKIQl.g4pM86s6CyOpd2g8co7uYJRB46f1QJBqKLLuCyh5mq','/uploads/student_card-1760870648341-50765326.png','2025-10-19 10:44:10',NULL,NULL,NULL,NULL),(10,'Jams','jams@mail.com',NULL,'(123) 4567 89','ASA','ML Student','4',3.48,'$2b$10$7mFKvgunYmu0baHmT4B7cuDSMwKvWsq6DhN.kChlTBPrYPl9FYYfi','/uploads/student_card-1760871919478-61425775.png','2025-10-19 11:05:20','[]',NULL,NULL,NULL),(11,'Charles Mendez','intec@mail.com',NULL,'(456) 1234 567','MIT','Software Developer','4',3.48,'$2b$10$aJ6zwCjWnXp.9t7kX9lFB.rcInE3fDxPVjEYOhgveQLWTIhB8UMwi','/uploads/student_card-1761240751870-782608202.png','2025-10-23 17:32:32',NULL,NULL,NULL,NULL),(12,'Mogo','usuariodeprueba@mail.com','','(564) 342-1234','Madrid','Software Developer','4',3.75,'$2b$10$bbK.so73pmUpa4t22c5kM.PO7blZtiOm63ZM3.z983oF9tb1d5bG2','/uploads/student_card-1761674947622-298490239.png','2025-10-28 18:09:08','[\"JavaScript\", \"C++\", \"Java\", \"Python\"]','[{\"name\": \"English\", \"level\": \"B1 - Intermediate\"}]','',NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-20 19:35:46
