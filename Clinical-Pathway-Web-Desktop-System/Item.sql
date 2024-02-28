/*
Navicat MySQL Data Transfer

Source Server         : 医院系统数据库
Source Server Version : 50562
Source Host           : localhost:3306
Source Database       : hospital

Target Server Type    : MYSQL
Target Server Version : 50562
File Encoding         : 65001

Date: 2020-05-10 18:59:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for Item
-- ----------------------------
DROP TABLE IF EXISTS `Item`;
CREATE TABLE `Item` (
  `itemID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pathsegID` int(10) unsigned NOT NULL,
  `itemCat` varchar(10) NOT NULL,
  `itemName` varchar(50) NOT NULL,
  PRIMARY KEY (`itemID`),
  KEY `pathsegID` (`pathsegID`),
  CONSTRAINT `Item_ibfk_1` FOREIGN KEY (`pathsegID`) REFERENCES `Pathseg` (`pathsegID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Item
-- ----------------------------
INSERT INTO `Item` VALUES ('11', '8', '长期医嘱', '长期医嘱1');
INSERT INTO `Item` VALUES ('12', '8', '长期医嘱', '长期医嘱2');
INSERT INTO `Item` VALUES ('13', '9', '长期医嘱', '长期医嘱3');
INSERT INTO `Item` VALUES ('14', '8', '诊疗工作', '诊疗工作');

-- ----------------------------
-- Table structure for Path
-- ----------------------------
DROP TABLE IF EXISTS `Path`;
CREATE TABLE `Path` (
  `pathID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pathVer` varchar(4) NOT NULL,
  `pathName` varchar(20) NOT NULL,
  `pathCode` varchar(10) NOT NULL,
  `pathDept` varchar(6) NOT NULL,
  `pathReq` varchar(100) NOT NULL,
  `pathAbs` varchar(200) DEFAULT NULL,
  `pathSlos` varchar(10) NOT NULL,
  `pathCrtstaff` varchar(10) NOT NULL,
  `pathTimestamp` varchar(17) NOT NULL,
  PRIMARY KEY (`pathID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Path
-- ----------------------------
INSERT INTO `Path` VALUES ('16', '1', '支气管炎', '101', '内科', '发烧39度', '摘要', '7天', '张三', '20-05-07 23:02:18');
INSERT INTO `Path` VALUES ('18', '1', '肺炎', '102', '内科', '发烧40度', '摘要', '14天', '张三', '2020-05-09 15:33:');

-- ----------------------------
-- Table structure for Pathseg
-- ----------------------------
DROP TABLE IF EXISTS `Pathseg`;
CREATE TABLE `Pathseg` (
  `pathsegID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pathID` int(10) unsigned NOT NULL,
  `pathsegDay` int(4) unsigned NOT NULL,
  PRIMARY KEY (`pathsegID`),
  KEY `pathID` (`pathID`),
  CONSTRAINT `Pathseg_ibfk_1` FOREIGN KEY (`pathID`) REFERENCES `Ptpath` (`pathID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Pathseg
-- ----------------------------
INSERT INTO `Pathseg` VALUES ('8', '16', '1');
INSERT INTO `Pathseg` VALUES ('9', '16', '2');
INSERT INTO `Pathseg` VALUES ('11', '16', '3');

-- ----------------------------
-- Table structure for Patient
-- ----------------------------
DROP TABLE IF EXISTS `Patient`;
CREATE TABLE `Patient` (
  `ptID` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `ptName` varchar(12) NOT NULL,
  `ptGender` tinyint(1) DEFAULT NULL,
  `ptAge` int(3) unsigned DEFAULT NULL,
  `ptStartdate` varchar(17) NOT NULL,
  `ptPathcond` tinyint(1) unsigned NOT NULL,
  `ptEnddate` varchar(17) DEFAULT NULL,
  `ptBed` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ptID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Patient
-- ----------------------------
INSERT INTO `Patient` VALUES ('10', '病人3', '0', '18', '2020-01-03', '2', '2020-05-10 00:58:', '10');
INSERT INTO `Patient` VALUES ('11', '不入径患者', '0', '18', '2020-01-03', '0', null, '11');
INSERT INTO `Patient` VALUES ('12', '入径患者1', '0', '20', '2020-01-04', '0', null, '11');
INSERT INTO `Patient` VALUES ('14', '阿姨', '1', '40', '2020-05-11 12:00:', '2', '2020-05-10 17:56:', '10');

-- ----------------------------
-- Table structure for Ptitem
-- ----------------------------
DROP TABLE IF EXISTS `Ptitem`;
CREATE TABLE `Ptitem` (
  `ptitemID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `itemID` int(10) unsigned NOT NULL,
  `ptpathID` int(10) unsigned NOT NULL,
  `ptitemName` varchar(200) NOT NULL,
  `ptitemExeccond` tinyint(1) unsigned DEFAULT NULL,
  `ptitemExecrem` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ptitemID`),
  KEY `ptpathsegID` (`itemID`),
  KEY `ptpathID` (`ptpathID`),
  CONSTRAINT `Ptitem_ibfk_1` FOREIGN KEY (`itemID`) REFERENCES `Item` (`itemID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Ptitem_ibfk_2` FOREIGN KEY (`ptpathID`) REFERENCES `Ptpath` (`ptpathID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Ptitem
-- ----------------------------
INSERT INTO `Ptitem` VALUES ('2', '14', '8', '', '1', null);
INSERT INTO `Ptitem` VALUES ('3', '11', '8', '', '0', null);
INSERT INTO `Ptitem` VALUES ('4', '11', '8', '', '1', null);
INSERT INTO `Ptitem` VALUES ('9', '12', '8', '', '1', null);
INSERT INTO `Ptitem` VALUES ('10', '14', '11', '', '1', null);
INSERT INTO `Ptitem` VALUES ('11', '11', '11', '', '1', null);
INSERT INTO `Ptitem` VALUES ('12', '12', '11', '', '1', null);

-- ----------------------------
-- Table structure for Ptpath
-- ----------------------------
DROP TABLE IF EXISTS `Ptpath`;
CREATE TABLE `Ptpath` (
  `ptpathID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ptID` int(10) unsigned NOT NULL,
  `pathID` int(10) unsigned NOT NULL,
  `pathVer` varchar(4) NOT NULL,
  `ptpathEntrdate` varchar(17) DEFAULT NULL,
  `ptpathEntrdept` varchar(6) NOT NULL,
  `ptpathName` varchar(20) DEFAULT NULL,
  `ptpathDeptdate` varchar(255) NOT NULL,
  `ptpathDepttype` varchar(4) NOT NULL,
  `ptpathVardate` varchar(255) DEFAULT NULL,
  `ptpathVarrsn` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ptpathID`),
  KEY `ptID` (`ptID`),
  KEY `pathID` (`pathID`),
  CONSTRAINT `Ptpath_ibfk_1` FOREIGN KEY (`ptID`) REFERENCES `Patient` (`ptID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Ptpath_ibfk_2` FOREIGN KEY (`pathID`) REFERENCES `Path` (`pathID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Ptpath
-- ----------------------------
INSERT INTO `Ptpath` VALUES ('7', '10', '16', '1', '2020-01-03', '内科', '支气管炎', '2020-05-10 00:58:57', '变异', '2020-05-10 00:48:22', '此患者已变异!');
INSERT INTO `Ptpath` VALUES ('8', '11', '16', '1', null, '内科', '支气管炎', '', '', null, null);
INSERT INTO `Ptpath` VALUES ('9', '12', '18', '1', '2020-01-04', '内科', '肺炎', '', '', null, null);
INSERT INTO `Ptpath` VALUES ('11', '14', '16', '1', '2020-05-11 12:00:', '内科', '支气管炎', '2020-05-10 17:56:37', '变异', '2020-05-10 17:56:33', '该病人已变异');

-- ----------------------------
-- Table structure for Ptpathseg
-- ----------------------------
DROP TABLE IF EXISTS `Ptpathseg`;
CREATE TABLE `Ptpathseg` (
  `ptpathsegID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ptpathID` int(10) unsigned NOT NULL,
  `pathsegID` int(10) unsigned NOT NULL,
  `ptpathsegTemp` varchar(255) DEFAULT NULL,
  `ptitemExecrem` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ptpathsegID`),
  KEY `ptpathID` (`ptpathID`),
  KEY `pathsegID` (`pathsegID`),
  CONSTRAINT `Ptpathseg_ibfk_1` FOREIGN KEY (`ptpathID`) REFERENCES `Ptpath` (`ptpathID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Ptpathseg_ibfk_2` FOREIGN KEY (`pathsegID`) REFERENCES `Pathseg` (`pathsegID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of Ptpathseg
-- ----------------------------
INSERT INTO `Ptpathseg` VALUES ('2', '11', '8', '37.5', '测试12');
INSERT INTO `Ptpathseg` VALUES ('3', '11', '9', '', '');

-- ----------------------------
-- Table structure for User
-- ----------------------------
DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
  `userID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userName` varchar(12) NOT NULL,
  `userType` tinyint(1) unsigned NOT NULL,
  `userPwd` varchar(255) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `userName` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of User
-- ----------------------------
INSERT INTO `User` VALUES ('16', 'text', '0', 'text');
