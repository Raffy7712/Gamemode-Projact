-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.7.2-MariaDB-log - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for ryujirp
DROP DATABASE IF EXISTS `ryujirp`;
CREATE DATABASE IF NOT EXISTS `ryujirp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `ryujirp`;

-- Dumping structure for table ryujirp.account
DROP TABLE IF EXISTS `account`;
CREATE TABLE IF NOT EXISTS `account` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UCP` varchar(255) NOT NULL,
  `Activated` int(11) NOT NULL DEFAULT 0,
  `Otp` char(50) DEFAULT '',
  `Admin` int(11) NOT NULL DEFAULT 0,
  `Password` varchar(255) DEFAULT NULL,
  `LastLogin` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table ryujirp.account: ~1 rows (approximately)
REPLACE INTO `account` (`Id`, `UCP`, `Activated`, `Otp`, `Admin`, `Password`, `LastLogin`) VALUES
	(1, 'Lolicon', 1, NULL, 0, '47a226815f61e35ead29fa6b976b0a75', NULL);

-- Dumping structure for table ryujirp.character
DROP TABLE IF EXISTS `character`;
CREATE TABLE IF NOT EXISTS `character` (
  `Id` int(10) NOT NULL AUTO_INCREMENT,
  `Name` varchar(64) NOT NULL,
  `UCP` varchar(64) NOT NULL,
  `Health` float NOT NULL DEFAULT 100,
  `Armour` float NOT NULL DEFAULT 0,
  `PosX` float NOT NULL DEFAULT 1682.61,
  `PosY` float NOT NULL DEFAULT -2327.89,
  `PosZ` float NOT NULL DEFAULT 13.5469,
  `Angle` float NOT NULL DEFAULT 3.4335,
  `Interior` int(5) NOT NULL DEFAULT 0,
  `VirtualWorld` int(5) NOT NULL DEFAULT 0,
  `Skin` int(5) NOT NULL DEFAULT 98,
  `Level` int(3) NOT NULL DEFAULT 0,
  `Exp` float NOT NULL DEFAULT 0,
  `Money` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumping data for table ryujirp.character: ~1 rows (approximately)
REPLACE INTO `character` (`Id`, `Name`, `UCP`, `Health`, `Armour`, `PosX`, `PosY`, `PosZ`, `Angle`, `Interior`, `VirtualWorld`, `Skin`, `Level`, `Exp`, `Money`) VALUES
	(1, 'Ryuji_Haston', 'Lolicon', 41, 10, 1636.83, -2184.14, 13.5547, 195.256, 0, 0, 1, 1, 0, 100);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
