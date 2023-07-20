-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 05:01 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterlt`
--

-- --------------------------------------------------------

--
-- Table structure for table `info_items`
--

CREATE TABLE `info_items` (
  `item_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `descrip` varchar(200) NOT NULL,
  `value` float NOT NULL,
  `lat` float NOT NULL,
  `longt` float NOT NULL,
  `state` varchar(20) NOT NULL,
  `locality` varchar(20) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `info_items`
--

INSERT INTO `info_items` (`item_id`, `id`, `name`, `descrip`, `value`, `lat`, `longt`, `state`, `locality`, `date`, `phone`) VALUES
(24, 3, 'Bucket', 'Unused', 9, 6.04986, 100.53, 'Kedah', 'Pendang', '2023-06-12 22:04:29', '0175712599'),
(27, 3, 'Sofa', 'Does not match my color', 9, 6.12631, 100.367, 'Kedah', 'Alor Setar', '2023-06-28 16:31:04', '0175712599'),
(28, 3, 'Chair', 'not use anymore', 6, 6.12631, 100.367, 'Kedah', 'Alor Setar', '2023-07-01 11:13:22', '0175712599'),
(29, 3, 'Table', 'A brand new table ', 8, 6.12631, 100.367, 'Kedah', 'Alor Setar', '2023-07-01 11:15:22', '0175712599'),
(30, 3, 'Television', 'Old television. made in 2013', 5, 6.12631, 100.367, 'Kedah', 'Alor Setar', '2023-07-01 11:16:16', '0175712599');

-- --------------------------------------------------------

--
-- Table structure for table `info_users`
--

CREATE TABLE `info_users` (
  `id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(30) NOT NULL,
  `password` varchar(40) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `otp` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `info_users`
--

INSERT INTO `info_users` (`id`, `email`, `name`, `password`, `phone`, `datereg`, `otp`) VALUES
(3, 'ooi@gmail.com', 'yau ming', 'b7ed088190c204b31cd71484e6a1c538986b5f77', '0175712599', '2023-05-17 17:12:34.706465', 51589),
(5, 'jackie@gmail.com', 'jackie', 'b7ed088190c204b31cd71484e6a1c538986b5f77', '0194135061', '2023-05-19 15:23:34.635842', 11759),
(7, 'jun@gmail.com', 'Jun ta', 'b7ed088190c204b31cd71484e6a1c538986b5f77', '0125624183', '2023-05-21 13:46:42.488690', 43819),
(10, 'keh@gmail.com', 'Keh Yang', '5347c8d36f07b8c333b2c40272d3269b38ed810a', '0124648677', '2023-07-20 10:22:11.029662', 16378);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `cart_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

CREATE TABLE `tbl_order` (
  `order_id` int(11) NOT NULL,
  `buyer_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `order_status` varchar(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `buyer_phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_order`
--

INSERT INTO `tbl_order` (`order_id`, `buyer_id`, `seller_id`, `order_date`, `order_status`, `item_id`, `phone`, `buyer_phone`) VALUES
(7, 7, 3, '2023-07-20 02:40:09', 'Completed', 28, '0175712599', '0125624183'),
(8, 10, 3, '2023-07-20 03:00:41', 'Completed', 29, '0175712599', '0124648677'),
(9, 7, 3, '2023-07-20 14:50:47', 'New', 27, '0175712599', '0125624183');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `info_items`
--
ALTER TABLE `info_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `info_users`
--
ALTER TABLE `info_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `info_items`
--
ALTER TABLE `info_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `info_users`
--
ALTER TABLE `info_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_order`
--
ALTER TABLE `tbl_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
