-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 02, 2014 at 06:46 PM
-- Server version: 5.5.25a
-- PHP Version: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `pubmed`
--

-- --------------------------------------------------------

--
-- Table structure for table `alternative_name`
--

CREATE TABLE IF NOT EXISTS `alternative_name` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bioentity`
--

CREATE TABLE IF NOT EXISTS `bioentity` (
  `term` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `bioentity_db` varchar(100) NOT NULL,
  `bioentity_db_id` int(11) NOT NULL,
  PRIMARY KEY (`term`,`type`,`bioentity_db`,`bioentity_db_id`),
  KEY `type` (`type`),
  KEY `bioentity_db` (`bioentity_db`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bioentity_alternative_name`
--

CREATE TABLE IF NOT EXISTS `bioentity_alternative_name` (
  `term` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `bioentity_db` varchar(100) NOT NULL,
  `bioentity_db_id` int(11) NOT NULL,
  `alternative_name` varchar(100) NOT NULL,
  PRIMARY KEY (`term`,`type`,`bioentity_db`,`bioentity_db_id`,`alternative_name`),
  KEY `bioentity` (`term`,`type`,`bioentity_db`,`bioentity_db_id`),
  KEY `alternative_name` (`alternative_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bioentity_appearance`
--

CREATE TABLE IF NOT EXISTS `bioentity_appearance` (
  `term` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `bioentity_db` varchar(100) NOT NULL,
  `bioentity_db_id` int(11) NOT NULL,
  `pmcid` int(11) NOT NULL,
  `pmid` int(11) NOT NULL,
  `source` enum('us','eu','ca') NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`term`,`type`,`bioentity_db`,`bioentity_db_id`,`pmcid`,`pmid`,`source`),
  KEY `bioentity` (`term`,`type`,`bioentity_db`,`bioentity_db_id`),
  KEY `paper` (`pmcid`,`pmid`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `bioentity_db`
--

CREATE TABLE IF NOT EXISTS `bioentity_db` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `journal`
--

CREATE TABLE IF NOT EXISTS `journal` (
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `keyword`
--

CREATE TABLE IF NOT EXISTS `keyword` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `license`
--

CREATE TABLE IF NOT EXISTS `license` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `license_text`
--

CREATE TABLE IF NOT EXISTS `license_text` (
  `pmcid` int(11) NOT NULL,
  `pmid` int(11) NOT NULL,
  `source` enum('us','eu','ca') NOT NULL,
  `text` text,
  `license` varchar(100) NOT NULL,
  PRIMARY KEY (`pmcid`,`pmid`,`source`,`license`),
  KEY `paper` (`pmcid`,`pmid`,`source`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mesh_qualifier`
--

CREATE TABLE IF NOT EXISTS `mesh_qualifier` (
  `name` varchar(100) NOT NULL,
  `major_topic` tinyint(1) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mesh_term`
--

CREATE TABLE IF NOT EXISTS `mesh_term` (
  `term` varchar(100) NOT NULL,
  `major_topic` tinyint(1) NOT NULL,
  PRIMARY KEY (`term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mesh_term_mesh_qualifier`
--

CREATE TABLE IF NOT EXISTS `mesh_term_mesh_qualifier` (
  `mesh_term` varchar(100) NOT NULL,
  `mesh_qualifier` varchar(100) NOT NULL,
  PRIMARY KEY (`mesh_term`,`mesh_qualifier`),
  KEY `mesh_term` (`mesh_term`),
  KEY `mesh_qualifier` (`mesh_qualifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `paper`
--

CREATE TABLE IF NOT EXISTS `paper` (
  `pmcid` int(11) NOT NULL DEFAULT '-1',
  `pmid` int(11) NOT NULL DEFAULT '-1',
  `source` enum('us','eu','ca') NOT NULL,
  `publication_source` varchar(100) DEFAULT NULL,
  `journal` varchar(255) DEFAULT NULL,
  `title` varchar(1000) NOT NULL,
  `abstract` text NOT NULL,
  `body` mediumtext NOT NULL,
  `oa` tinyint(1) NOT NULL,
  `license` varchar(100) DEFAULT NULL,
  `import_source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pmcid`,`pmid`,`source`),
  KEY `publication_source` (`publication_source`),
  KEY `journal` (`journal`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `paper_keyword`
--

CREATE TABLE IF NOT EXISTS `paper_keyword` (
  `pmcid` int(11) NOT NULL,
  `pmid` int(11) NOT NULL,
  `source` enum('us','eu','ca') NOT NULL,
  `keyword` varchar(100) NOT NULL,
  PRIMARY KEY (`pmcid`,`pmid`,`source`,`keyword`),
  KEY `paper` (`pmcid`,`pmid`,`source`),
  KEY `keyword` (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `paper_mesh_term`
--

CREATE TABLE IF NOT EXISTS `paper_mesh_term` (
  `pmcid` int(11) NOT NULL,
  `pmid` int(11) NOT NULL,
  `source` enum('us','eu','ca') NOT NULL,
  `mesh_term` varchar(100) NOT NULL,
  PRIMARY KEY (`pmcid`,`pmid`,`source`,`mesh_term`),
  KEY `paper` (`pmcid`,`pmid`,`source`),
  KEY `mesh_term` (`mesh_term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `publication_source`
--

CREATE TABLE IF NOT EXISTS `publication_source` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `semantictype`
--

CREATE TABLE IF NOT EXISTS `semantictype` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bioentity`
--
ALTER TABLE `bioentity`
  ADD CONSTRAINT `bioentity_bioentity_db_CON` FOREIGN KEY (`bioentity_db`) REFERENCES `bioentity_db` (`name`),
  ADD CONSTRAINT `bioentity_semantictype_CON` FOREIGN KEY (`type`) REFERENCES `semantictype` (`name`);

--
-- Constraints for table `bioentity_alternative_name`
--
ALTER TABLE `bioentity_alternative_name`
  ADD CONSTRAINT `alternative_name` FOREIGN KEY (`alternative_name`) REFERENCES `alternative_name` (`name`),
  ADD CONSTRAINT `bioentity` FOREIGN KEY (`term`, `type`, `bioentity_db`, `bioentity_db_id`) REFERENCES `bioentity` (`term`, `type`, `bioentity_db`, `bioentity_db_id`);

--
-- Constraints for table `bioentity_appearance`
--
ALTER TABLE `bioentity_appearance`
  ADD CONSTRAINT `bioentity_apperance_bioentity_CON` FOREIGN KEY (`term`, `type`, `bioentity_db`, `bioentity_db_id`) REFERENCES `bioentity` (`term`, `type`, `bioentity_db`, `bioentity_db_id`),
  ADD CONSTRAINT `bioentity_apperance_paper_CON` FOREIGN KEY (`pmcid`, `pmid`, `source`) REFERENCES `paper` (`pmcid`, `pmid`, `source`);

--
-- Constraints for table `license_text`
--
ALTER TABLE `license_text`
  ADD CONSTRAINT `license_text` FOREIGN KEY (`license`) REFERENCES `license` (`name`),
  ADD CONSTRAINT `license_text_paper_CON` FOREIGN KEY (`pmcid`, `pmid`, `source`) REFERENCES `paper` (`pmcid`, `pmid`, `source`);

--
-- Constraints for table `mesh_term_mesh_qualifier`
--
ALTER TABLE `mesh_term_mesh_qualifier`
  ADD CONSTRAINT `mesh_term_mesh_qualifier_mesh_qualifier_CON` FOREIGN KEY (`mesh_qualifier`) REFERENCES `mesh_qualifier` (`name`),
  ADD CONSTRAINT `mesh_term_mesh_qualifier_mesh_term_CON` FOREIGN KEY (`mesh_term`) REFERENCES `mesh_term` (`term`);

--
-- Constraints for table `paper`
--
ALTER TABLE `paper`
  ADD CONSTRAINT `journal` FOREIGN KEY (`journal`) REFERENCES `journal` (`name`),
  ADD CONSTRAINT `license` FOREIGN KEY (`license`) REFERENCES `license` (`name`),
  ADD CONSTRAINT `publication_source` FOREIGN KEY (`publication_source`) REFERENCES `publication_source` (`name`);

--
-- Constraints for table `paper_keyword`
--
ALTER TABLE `paper_keyword`
  ADD CONSTRAINT `paper_keyword_keyword_CON` FOREIGN KEY (`keyword`) REFERENCES `keyword` (`name`),
  ADD CONSTRAINT `paper_keyword_paper_CON` FOREIGN KEY (`pmcid`, `pmid`, `source`) REFERENCES `paper` (`pmcid`, `pmid`, `source`);

--
-- Constraints for table `paper_mesh_term`
--
ALTER TABLE `paper_mesh_term`
  ADD CONSTRAINT `paper_mesh_term_mesh_term_CON` FOREIGN KEY (`mesh_term`) REFERENCES `mesh_term` (`term`),
  ADD CONSTRAINT `paper_mesh_term_paper_CON` FOREIGN KEY (`pmcid`, `pmid`, `source`) REFERENCES `paper` (`pmcid`, `pmid`, `source`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
