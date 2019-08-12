-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- 主機: 127.0.0.1
-- 產生時間： 2019 年 08 月 12 日 12:56
-- 伺服器版本: 10.1.32-MariaDB
-- PHP 版本： 7.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `dbtext`
--

-- --------------------------------------------------------

--
-- 資料表結構 `all-worktime`
--

CREATE TABLE `all-worktime` (
  `#` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `year` text NOT NULL,
  `month` text NOT NULL,
  `day` text NOT NULL,
  `orderWork` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `boss-account`
--

CREATE TABLE `boss-account` (
  `user` int(15) NOT NULL,
  `account` text NOT NULL,
  `password` text NOT NULL,
  `email` text NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `boss-account`
--

INSERT INTO `boss-account` (`user`, `account`, `password`, `email`, `name`) VALUES
(3, 'x8522207x', 'baia8053', 'x8522207x@gmail.com', '賴忠志');

-- --------------------------------------------------------

--
-- 資料表結構 `staff-account`
--

CREATE TABLE `staff-account` (
  `user` int(10) NOT NULL,
  `account` text NOT NULL,
  `password` text NOT NULL,
  `email` text NOT NULL,
  `name` text NOT NULL,
  `workTime` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 資料表的匯出資料 `staff-account`
--

INSERT INTO `staff-account` (`user`, `account`, `password`, `email`, `name`, `workTime`) VALUES
(1, 'handsomelai', 'baia8053', 'x8522207x@gmail.com', '賴小志', 'morning'),
(4, 'handsomelai1', 'baia8053', 'x8522207x@gmail.com', '1', 'morning'),
(5, 'handsomelai2', 'baia8053', 'x8522207x@gmail.com', '2', 'noon'),
(7, 'handsomelai3', 'baia8053', 'x8522207x@gmail.com', '3', 'noon'),
(9, 'handsomelai4', 'baia8053', 'x8522207x@gmail.com', '4', 'noon'),
(11, 'handsomelai5', 'baia8053', 'x8522207x@gmail.com', '5', 'night'),
(13, 'handsomelai6', 'baia8053', 'x8522207x@gmail.com', '6', 'night'),
(15, 'handsomelai7', 'baia8053', 'x8522207x@gmail.com', '7', 'night');

-- --------------------------------------------------------

--
-- 資料表結構 `staff-arrange`
--

CREATE TABLE `staff-arrange` (
  `#` int(11) NOT NULL,
  `user` text NOT NULL,
  `name` text NOT NULL,
  `year` text NOT NULL,
  `month` text NOT NULL,
  `day` text NOT NULL,
  `orderWork` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `staff-worktime`
--

CREATE TABLE `staff-worktime` (
  `#` int(11) NOT NULL,
  `user` text NOT NULL,
  `name` text NOT NULL,
  `year` text NOT NULL,
  `month` text NOT NULL,
  `day` text NOT NULL,
  `orderWork` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `all-worktime`
--
ALTER TABLE `all-worktime`
  ADD PRIMARY KEY (`#`);

--
-- 資料表索引 `boss-account`
--
ALTER TABLE `boss-account`
  ADD PRIMARY KEY (`user`);

--
-- 資料表索引 `staff-account`
--
ALTER TABLE `staff-account`
  ADD PRIMARY KEY (`user`);

--
-- 資料表索引 `staff-arrange`
--
ALTER TABLE `staff-arrange`
  ADD PRIMARY KEY (`#`);

--
-- 資料表索引 `staff-worktime`
--
ALTER TABLE `staff-worktime`
  ADD PRIMARY KEY (`#`);

--
-- 在匯出的資料表使用 AUTO_INCREMENT
--

--
-- 使用資料表 AUTO_INCREMENT `all-worktime`
--
ALTER TABLE `all-worktime`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `boss-account`
--
ALTER TABLE `boss-account`
  MODIFY `user` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用資料表 AUTO_INCREMENT `staff-account`
--
ALTER TABLE `staff-account`
  MODIFY `user` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- 使用資料表 AUTO_INCREMENT `staff-arrange`
--
ALTER TABLE `staff-arrange`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表 AUTO_INCREMENT `staff-worktime`
--
ALTER TABLE `staff-worktime`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
