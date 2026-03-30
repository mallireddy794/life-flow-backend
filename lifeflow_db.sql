-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2026 at 06:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lifeflow_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `blood_requests`
--

CREATE TABLE `blood_requests` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `units_required` int(11) NOT NULL,
  `urgency_level` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `city` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `patient_name` varchar(255) DEFAULT NULL,
  `hospital_name` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `donor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_requests`
--

INSERT INTO `blood_requests` (`id`, `patient_id`, `blood_group`, `units_required`, `urgency_level`, `status`, `city`, `created_at`, `patient_name`, `hospital_name`, `contact_number`, `donor_id`) VALUES
(1, 1, 'O+', 2, 'Emergency', 'Rejected', 'Chennai', '2026-02-24 04:36:22', NULL, NULL, NULL, NULL),
(2, 1, 'O+', 2, 'Emergency', 'Pending', 'Chennai', '2026-02-24 04:36:28', NULL, NULL, NULL, NULL),
(3, 4, 'A+', 2, 'High', 'Pending', 'Hyderabad', '2026-03-09 09:21:34', NULL, NULL, NULL, NULL),
(4, 7, 'o', 1, '', 'Pending', 'thadalam', '2026-03-26 06:08:47', NULL, NULL, NULL, NULL),
(5, 7, 'A+', 1, '', 'Pending', 'thadalam', '2026-03-26 06:53:10', NULL, NULL, NULL, NULL),
(9, 7, 'o+', 1, '', 'Pending', 'thadalam', '2026-03-26 07:12:12', NULL, NULL, NULL, NULL),
(10, 7, 'o+', 1, '', 'ACCEPTED', 'thadalam', '2026-03-26 07:18:55', NULL, NULL, NULL, NULL),
(11, 7, 'o', 1, '', 'SCHEDULED', 'shshsh', '2026-03-26 07:21:46', NULL, NULL, NULL, NULL),
(12, 7, 'o', 1, '', 'Pending', 'sbsbsb', '2026-03-26 07:30:16', NULL, NULL, NULL, NULL),
(19, 7, 'o', 1, '', 'Pending', 'thadalam', '2026-03-26 08:50:15', NULL, NULL, NULL, NULL),
(22, 7, 'o+', 1, '', 'Pending', 'sshsh', '2026-03-26 09:11:47', NULL, NULL, NULL, NULL),
(23, 7, 'o+', 1, '', 'Pending', 'abab', '2026-03-26 09:24:36', NULL, NULL, NULL, NULL),
(24, 7, 'o+', 1, '', 'Pending', 'thadalam', '2026-03-26 12:10:45', NULL, NULL, NULL, NULL),
(31, 1, 'O+', 2, 'Emergency', 'Pending', 'Chennai', '2026-03-27 03:40:10', NULL, NULL, NULL, NULL),
(33, 1, 'O+', 2, 'Emergency', 'Pending', 'Chennai', '2026-03-27 03:53:31', NULL, NULL, NULL, NULL),
(34, 1, 'O+', 2, 'Emergency', 'Pending', 'Chennai', '2026-03-27 03:53:56', NULL, NULL, NULL, NULL),
(35, 7, 'o', 1, '', 'Accepted', 'd', '2026-03-27 04:08:39', NULL, NULL, NULL, 26),
(37, 7, 'O+', 1, 'NORMAL', 'Accepted', 'thadalam', '2026-03-27 04:50:46', NULL, NULL, NULL, 26),
(38, 7, 'O+', 1, 'NORMAL', 'Pending', 'thadalam', '2026-03-27 04:51:21', NULL, NULL, NULL, NULL),
(39, 7, 'O+', 1, 'NORMAL', 'Pending', 'location', '2026-03-27 04:52:12', NULL, NULL, NULL, NULL),
(40, 7, 'B+', 2, 'NORMAL', 'Pending', 'thadalam', '2026-03-27 04:56:22', NULL, NULL, NULL, NULL),
(41, 7, 'B+', 1, 'NORMAL', 'Pending', 'thadalam', '2026-03-27 04:57:59', NULL, NULL, NULL, NULL),
(42, 7, 'A+', 1, 'NORMAL', 'Pending', 'wgzvz', '2026-03-27 05:00:20', NULL, NULL, NULL, NULL),
(43, 7, 'A+', 8, 'NORMAL', 'Pending', 'ffh', '2026-03-27 05:04:50', NULL, NULL, NULL, NULL),
(44, 7, 'A+', 4, 'NORMAL', 'Pending', 'thadalam', '2026-03-27 05:21:11', NULL, NULL, NULL, NULL),
(45, 7, 'A+', 1, 'NORMAL', 'Pending', 'zvzbzb', '2026-03-27 05:22:24', NULL, NULL, NULL, NULL),
(46, 7, 'A+', 1, 'NORMAL', 'Pending', 'shshsh', '2026-03-27 05:24:15', NULL, NULL, NULL, NULL),
(47, 7, 'A+', 1, 'NORMAL', 'Pending', 'gdgsy', '2026-03-27 05:32:50', NULL, NULL, NULL, NULL),
(48, 7, 'A+', 1, 'URGENT', 'Pending', 'thadalam', '2026-03-27 07:16:16', NULL, NULL, NULL, NULL),
(49, 7, 'A+', 5, 'URGENT', 'Pending', 'hssbsb', '2026-03-27 07:25:05', NULL, NULL, NULL, NULL),
(50, 7, 'A+', 2, 'NORMAL', 'Pending', 'thadalam', '2026-03-27 07:41:48', NULL, NULL, NULL, NULL),
(51, 7, 'B-', 8, 'URGENT', 'Pending', 'sndjs', '2026-03-27 07:57:27', NULL, NULL, NULL, NULL),
(52, 7, 'B+', 10, 'URGENT', 'Pending', 'thadalam.', '2026-03-27 07:59:12', NULL, NULL, NULL, NULL),
(53, 7, 'B+', 898, 'URGENT', 'Pending', 'vzzbzb', '2026-03-27 08:01:42', NULL, NULL, NULL, NULL),
(54, 7, 'B-', 10, 'URGENT', 'Pending', 'thadala.', '2026-03-27 08:19:39', NULL, NULL, NULL, NULL),
(55, 7, 'B-', 10, 'NORMAL', 'Pending', 'thadalm', '2026-03-27 08:21:11', NULL, NULL, NULL, NULL),
(56, 7, 'O+', 2, 'URGENT', 'Pending', 'thadalam', '2026-03-27 12:20:41', NULL, NULL, NULL, NULL),
(57, 7, 'O+', 1, 'URGENT', 'Pending', 'wvzvz', '2026-03-27 12:22:50', NULL, NULL, NULL, NULL),
(58, 7, 'O+', 5, 'URGENT', 'PENDING', 'saveetha', '2026-03-27 12:40:58', 'malli', 'saveetha', '245787873', NULL),
(59, 7, 'O+', 2, 'URGENT', 'PENDING', 'thadalam', '2026-03-27 12:54:01', 'malli', 'saveetha', '589350', NULL),
(60, 7, 'O+', 2, 'NORMAL', 'PENDING', 'fghj', '2026-03-27 12:55:19', 'xbhxhx', 'sabbn', '98986868', NULL),
(61, 7, 'O+', 8, 'URGENT', 'PENDING', 'BBQ', '2026-03-27 13:00:32', 'malli', 'aha', '19*#*#*#', NULL),
(62, 7, 'yeye', 2453, 'NORMAL', 'PENDING', 'yet', '2026-03-27 13:05:40', 'gsyd', 'gsst', '2475455', NULL),
(63, 7, 'O+', 88, 'NORMAL', 'PENDING', 'cg', '2026-03-27 13:06:08', 'ndf', 'fc', '5', NULL),
(64, 7, 'O+', 1, 'NORMAL', 'PENDING', 'sbsb', '2026-03-27 13:13:20', 'malli', 'saveetha', '797979', NULL),
(65, 7, 'O+', 8, 'URGENT', 'PENDING', 'dvdv', '2026-03-27 13:57:53', 'malli', 'vdv', '47878787', NULL),
(66, 7, 'O+', 5, 'URGENT', 'PENDING', 'dhdh', '2026-03-27 14:03:19', 'Malala', 'dhsh', '9797', NULL),
(67, 7, 'O+', 2, 'URGENT', 'PENDING', 'thadalam', '2026-03-27 14:11:28', 'malli', 'saveetha', '2580369445', NULL),
(68, 7, 'O+', 1, 'HIGH', 'Pending', 'sss', '2026-03-27 18:08:05', 'malli', 'saveetha', '123456789', NULL),
(69, 7, 'O+', 1, 'URGENT', 'Pending', 'thadalam', '2026-03-28 04:24:17', 'malli', 'saveetha', '745464644346', NULL),
(70, 7, 'B-', 1, 'HIGH', 'Pending', 'sss', '2026-03-28 04:29:05', 'malli', 'saveetha', '1234567890', NULL),
(71, 7, 'B-', 1, 'HIGH', 'Pending', 'sss', '2026-03-28 04:29:28', 'malli', 'saveetha', '2345768', NULL),
(72, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 04:41:21', 'malli', 'saveetha', '2345768', NULL),
(73, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 04:42:34', 'malli', 'saveetha', '2345768', NULL),
(74, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 04:45:49', 'malli', 'saveetha', '2345768', NULL),
(75, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:02:28', 'malli', 'saveetha', '2345768', NULL),
(76, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:12:55', 'malli', 'saveetha', '2345768', NULL),
(77, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:18:23', 'malli', 'saveetha', '2345768', NULL),
(78, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:22:47', 'malli', 'saveetha', '2345768', NULL),
(79, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:23:33', 'malli', 'saveetha', '2345768', NULL),
(80, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:30:36', 'malli', 'saveetha', '2345768', NULL),
(81, 7, 'B-', 1, 'HIGH', 'PENDING', 'sss', '2026-03-28 05:37:21', 'malli', 'saveetha', '2345768', NULL),
(82, 57, 'B-', 1, 'NORMAL', 'PENDING', 'sss', '2026-03-28 05:45:18', 'Mallikarjuna Reddy', 'saveetha', NULL, 26),
(83, 7, 'O+', 1, 'URGENT', 'Pending', 'thadalam', '2026-03-28 07:16:23', 'malli', 'saveetha', '7013740820', NULL),
(84, 7, 'A+', 1, 'NORMAL', 'Pending', 'thadalam', '2026-03-28 07:18:00', 'malli', 'saveetha', '7013740820', NULL),
(85, 7, 'O+', 1, 'URGENT', 'Pending', 'tadal.', '2026-03-28 07:42:26', 'malli', 'saveetha', '949494949', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` int(11) NOT NULL,
  `chat_id` varchar(50) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chat_messages`
--

INSERT INTO `chat_messages` (`id`, `chat_id`, `sender_id`, `receiver_id`, `message`, `created_at`, `is_read`) VALUES
(1, '1_2', 1, 2, 'Hi, I can donate now.', '2026-02-25 08:01:23', 0),
(2, '1_2', 2, 1, 'Okay, please come fast.', '2026-02-25 08:22:56', 1),
(3, '1_2', 1, 2, 'hi', '2026-02-26 03:53:25', 0),
(4, '1_2', 1, 2, 'hi', '2026-02-26 03:53:25', 0),
(5, '1_2', 1, 2, 'hi', '2026-02-26 03:53:25', 0),
(6, '1_2', 1, 2, 'hi', '2026-02-26 03:53:26', 0),
(7, '1_2', 1, 2, 'hi', '2026-02-26 03:53:26', 0),
(8, '1_2', 1, 2, 'hi', '2026-02-26 03:53:26', 0),
(9, '1_2', 1, 2, 'hi', '2026-02-26 03:53:26', 0),
(10, '1_2', 1, 2, 'hi', '2026-02-26 03:53:38', 0),
(11, '1_2', 1, 2, 'hi', '2026-02-26 03:54:37', 0),
(12, '1_2', 1, 2, 'hi', '2026-02-26 03:54:44', 0),
(13, '1_2', 2, 1, 'Okay, please come fast.', '2026-02-26 03:55:28', 1),
(14, '1_2', 1, 2, 'hi', '2026-02-26 03:57:17', 0),
(16, '1_2', 1, 2, 'huu', '2026-02-26 03:59:00', 0),
(17, '1_2', 1, 2, 'hi', '2026-02-26 04:03:20', 0),
(18, '1_2', 1, 2, 'next', '2026-02-26 04:04:07', 0),
(19, '1_2', 1, 2, 'hi', '2026-02-26 04:12:12', 0),
(20, '1_2', 1, 2, 'dj', '2026-02-26 04:12:18', 0),
(21, '1_2', 1, 2, 'hi', '2026-02-26 04:12:45', 0),
(22, '1_2', 1, 2, 'hi', '2026-02-26 04:23:33', 0),
(23, '1_2', 2, 1, 'Okay, please come fast.', '2026-02-26 04:34:55', 1),
(24, '1_2', 2, 1, 'Okay, please come fast.', '2026-02-26 04:34:59', 1),
(25, '1_2', 1, 2, 'hi', '2026-02-26 04:39:07', 0),
(26, '2_27', 27, 2, 'hi', '2026-02-26 04:40:16', 0),
(27, '1_2', 1, 2, 'hi', '2026-02-26 04:45:46', 0),
(28, '1_2', 1, 2, 'hi', '2026-02-26 05:11:20', 0),
(29, '2_27', 27, 2, 'hi', '2026-02-26 05:11:47', 0),
(30, '2_27', 27, 2, 'hi', '2026-02-26 05:12:29', 0),
(31, '1_2', 1, 2, 'hi', '2026-02-26 05:15:09', 0),
(32, '1_2', 1, 2, 'vhj', '2026-02-26 06:57:09', 0),
(33, '1_2', 1, 2, 'hii', '2026-02-26 06:57:57', 0),
(34, '1_1', 1, 1, 'hi', '2026-02-26 08:39:50', 0),
(35, '1_26', 1, 26, 'hi', '2026-02-26 08:40:26', 0),
(36, '2_27', 27, 2, 'hi', '2026-02-26 08:40:36', 0),
(37, '1_202', 1, 202, 'hi', '2026-02-26 08:42:08', 0),
(38, '1_2', 1, 2, 'hi', '2026-02-26 08:42:27', 0),
(39, '1_101', 1, 101, 'hi', '2026-02-26 09:22:26', 0),
(40, '2_27', 27, 2, 'hi', '2026-02-26 09:23:07', 0),
(41, '1_101', 1, 101, 'hi', '2026-02-26 09:24:42', 0),
(42, '1_26', 1, 26, 'hi', '2026-02-26 09:25:48', 0),
(43, '1_26', 1, 26, 'hi', '2026-02-26 09:26:19', 0),
(44, '2_27', 27, 2, 'hi', '2026-02-26 09:26:29', 0),
(45, '1_26', 1, 26, 'hii', '2026-02-26 09:27:20', 0),
(46, '1_101', 1, 101, 'hi', '2026-02-26 09:28:01', 0),
(47, '1_101', 1, 101, 'hi', '2026-02-27 03:01:57', 0),
(48, '1_1', 1, 1, 'bjj', '2026-02-27 03:02:57', 0),
(49, '1_1', 1, 1, 'hi', '2026-02-27 05:42:28', 0),
(50, '1_1', 1, 1, 'ghi', '2026-02-27 05:42:46', 0),
(51, '1_26', 1, 26, 'hi', '2026-02-27 05:58:13', 0),
(52, '1_101', 1, 101, 'ggh', '2026-02-27 06:01:47', 0),
(53, '1_101', 1, 101, 'hi', '2026-02-27 06:12:38', 0),
(54, '1_101', 1, 101, 'ffh', '2026-02-27 07:41:57', 0),
(55, '1_101', 1, 101, 'gui', '2026-02-27 09:03:40', 0),
(56, '1_1', 1, 1, 'hhi', '2026-02-27 09:10:25', 0),
(57, '1_1', 1, 1, 'vji', '2026-02-27 09:10:40', 0),
(58, '2_27', 27, 2, 'hi', '2026-02-28 05:26:53', 0),
(59, '1_26', 1, 26, 'jii', '2026-02-28 05:27:23', 0),
(60, '1_1', 1, 1, 'hi', '2026-02-28 05:28:13', 0),
(61, '1_1', 1, 1, 'hi', '2026-02-28 05:29:05', 0),
(62, '1_1', 1, 1, 'hi', '2026-02-28 05:29:48', 0),
(63, '1_1', 1, 1, 'hi', '2026-02-28 05:29:53', 0),
(64, '2_27', 27, 2, 'hi', '2026-02-28 05:30:06', 0),
(65, '2_27', 27, 2, 'scsvsvs', '2026-02-28 05:30:10', 0),
(66, '1_26', 1, 26, 'gui', '2026-02-28 05:32:35', 0),
(67, '1_1', 1, 1, 'hi', '2026-02-28 05:43:51', 0),
(68, '2_27', 27, 2, 'hi', '2026-02-28 05:44:13', 0),
(69, '1_1', 1, 1, 'hi', '2026-02-28 05:44:39', 0),
(70, '1_2', 1, 2, 'hi', '2026-02-28 05:45:25', 0),
(71, '2_27', 27, 2, 'hi', '2026-02-28 05:45:37', 0),
(72, '2_27', 27, 2, 'ftyuu', '2026-02-28 05:45:38', 0),
(73, '1_26', 1, 26, 'vhi', '2026-02-28 05:45:45', 0),
(74, '1_1', 1, 1, 'hi', '2026-02-28 05:53:32', 0),
(75, '2_27', 27, 2, 'hi', '2026-02-28 05:53:51', 0),
(76, '1_1', 1, 1, 'hi', '2026-02-28 06:09:00', 0),
(77, '1_1', 1, 1, 'hii', '2026-02-28 06:09:13', 0),
(78, '2_27', 27, 2, 'hi', '2026-02-28 06:09:30', 0),
(79, '1_26', 26, 1, 'hi', '2026-02-28 06:15:58', 0),
(80, '26_27', 27, 26, 'hii', '2026-02-28 06:25:48', 0),
(81, '26_27', 27, 26, 'hi', '2026-02-28 06:25:52', 0),
(82, '26_27', 27, 26, 'vhi', '2026-02-28 06:26:01', 0),
(83, '1_26', 26, 1, 'hii', '2026-02-28 06:26:24', 0),
(84, '1_26', 26, 1, 'ji', '2026-02-28 06:31:11', 0),
(85, '26_27', 26, 27, 'hi', '2026-02-28 07:16:32', 0),
(86, '26_27', 26, 27, 'hi', '2026-02-28 07:16:45', 0),
(87, '2_27', 27, 2, 'hi', '2026-02-28 07:17:01', 0),
(88, '26_27', 26, 27, 'hi', '2026-02-28 07:17:25', 0),
(89, '26_27', 26, 27, 'ji', '2026-02-28 07:46:11', 0),
(90, '26_27', 26, 27, 'hi', '2026-02-28 08:00:55', 0),
(91, '26_27', 26, 27, 'hi', '2026-02-28 08:01:01', 0),
(92, '26_27', 27, 26, 'hi', '2026-02-28 08:01:15', 0),
(93, '26_27', 27, 26, 'hi', '2026-02-28 08:01:50', 0),
(94, '26_27', 27, 26, 'hi', '2026-02-28 08:02:05', 0),
(95, '26_27', 26, 27, 'hi', '2026-02-28 08:11:27', 0),
(96, '26_27', 26, 27, 'chhi', '2026-02-28 08:11:34', 0),
(97, '26_27', 26, 27, 'ycuf', '2026-02-28 08:11:36', 0),
(98, '26_27', 27, 26, 'hi', '2026-02-28 08:11:54', 0),
(99, '26_27', 26, 27, 'hi', '2026-02-28 08:25:11', 0),
(100, '26_27', 26, 27, 'hjjj', '2026-02-28 08:25:14', 0),
(101, '26_27', 26, 27, 'hi', '2026-02-28 08:25:42', 0),
(102, '26_27', 27, 26, 'hi', '2026-02-28 08:25:59', 0),
(103, '26_27', 26, 27, 'hi', '2026-02-28 08:32:26', 0),
(104, '26_27', 27, 26, 'hi', '2026-02-28 08:32:42', 0),
(105, '26_27', 26, 27, 'hi', '2026-02-28 08:36:55', 0),
(106, '26_27', 26, 27, 'hi', '2026-02-28 08:37:02', 0),
(107, '26_27', 27, 26, 'ji', '2026-02-28 08:37:23', 0),
(108, '26_27', 27, 26, 'hfh', '2026-02-28 08:37:25', 0),
(109, '26_27', 27, 26, 'uo', '2026-02-28 08:37:49', 0),
(110, '26_27', 26, 27, 'hi', '2026-02-28 08:42:25', 0),
(111, '26_27', 27, 26, 'hi', '2026-02-28 08:42:43', 0),
(112, '26_27', 26, 27, 'hi', '2026-02-28 08:43:06', 0),
(113, '26_27', 26, 27, 'hi', '2026-02-28 08:53:44', 0),
(114, '26_27', 27, 26, 'hi', '2026-02-28 08:54:03', 0),
(115, '26_27', 27, 26, 'hi', '2026-02-28 08:54:08', 0),
(116, '26_27', 26, 27, 'ghi', '2026-02-28 08:54:50', 0),
(117, '26_27', 26, 27, 'hiii', '2026-02-28 08:56:01', 0),
(118, '26_27', 26, 27, 'hi', '2026-02-28 09:01:03', 0),
(119, '26_27', 26, 27, 'hi', '2026-02-28 09:01:05', 0),
(120, '26_27', 26, 27, 'gi', '2026-02-28 09:01:06', 0),
(121, '26_27', 26, 27, 'hiii', '2026-02-28 09:02:12', 0),
(122, '26_27', 26, 27, 'hiii', '2026-02-28 09:02:16', 0),
(123, '26_27', 26, 27, 'hi', '2026-02-28 09:02:24', 0),
(124, '26_27', 27, 26, 'hi', '2026-02-28 09:02:37', 0),
(125, '26_27', 26, 27, 'hi', '2026-02-28 09:06:06', 0),
(126, '26_27', 26, 27, 'hiiii', '2026-02-28 09:06:11', 0),
(127, '26_27', 26, 27, 'hi', '2026-02-28 09:06:12', 0),
(128, '26_27', 26, 27, 'hi', '2026-02-28 09:06:14', 0),
(129, '26_27', 26, 27, 'hi', '2026-02-28 09:10:31', 0),
(130, '26_27', 26, 27, 'hi', '2026-02-28 09:10:33', 0),
(131, '26_27', 26, 27, 'hii', '2026-02-28 09:10:35', 0),
(132, '26_27', 26, 27, 'hj', '2026-02-28 09:10:36', 0),
(133, '26_27', 26, 27, 'ckjgkg', '2026-02-28 09:10:38', 0),
(134, '26_27', 26, 27, 'ifjfjfjfjg', '2026-02-28 09:10:40', 0),
(135, '26_27', 26, 27, 'jfjfjf', '2026-02-28 09:10:42', 0),
(136, '26_27', 26, 27, 'hi', '2026-02-28 09:15:21', 0),
(137, '26_27', 26, 27, 'hi', '2026-02-28 09:17:10', 0),
(138, '26_27', 26, 27, 'vvhh', '2026-02-28 09:17:13', 0),
(139, '26_27', 26, 27, 'vhhi', '2026-02-28 09:17:17', 0),
(140, '26_27', 27, 26, 'hi', '2026-02-28 09:18:09', 0),
(141, '26_27', 26, 27, 'hi', '2026-02-28 09:20:04', 0),
(142, '26_27', 26, 27, 'shsu', '2026-02-28 09:20:06', 0),
(143, '26_27', 26, 27, 'shsh', '2026-02-28 09:20:07', 0),
(144, '26_27', 26, 27, 'shsh', '2026-02-28 09:20:09', 0),
(145, '26_27', 26, 27, 'ho', '2026-03-02 03:27:46', 0),
(146, '26_27', 27, 26, 'hi', '2026-03-02 03:28:03', 0),
(147, '26_27', 27, 26, 'hi', '2026-03-02 03:28:17', 0),
(148, '26_27', 26, 27, 'hi', '2026-03-02 03:28:44', 0),
(149, '26_27', 26, 27, 'hii', '2026-03-02 04:01:37', 0),
(150, '26_27', 26, 27, 'hi', '2026-03-02 04:01:40', 0),
(151, '26_27', 27, 26, 'hi', '2026-03-02 05:28:14', 0),
(152, '26_27', 26, 27, 'hi', '2026-03-02 07:06:37', 0),
(153, '26_27', 27, 26, 'hii', '2026-03-02 07:07:28', 0),
(154, '26_27', 26, 27, 'hi', '2026-03-02 07:24:55', 0),
(155, '26_27', 27, 26, 'hi', '2026-03-02 07:32:40', 0),
(156, '26_27', 27, 26, 'hii', '2026-03-02 07:40:17', 0),
(157, '26_27', 26, 27, 'hii', '2026-03-02 07:41:03', 0),
(158, '26_27', 26, 27, 'hii', '2026-03-02 07:46:55', 0),
(159, '26_27', 26, 27, 'high', '2026-03-02 07:46:58', 0),
(160, '26_27', 26, 27, 'hi', '2026-03-02 07:48:15', 0),
(161, '26_29', 26, 29, 'hi', '2026-03-02 08:23:56', 0),
(162, '26_29', 26, 29, 'hi', '2026-03-02 08:40:02', 0),
(163, '26_27', 27, 26, 'hi', '2026-03-02 09:00:20', 0),
(164, '26_27', 27, 26, 'hi', '2026-03-02 09:00:23', 0),
(165, '26_27', 27, 26, 'hii', '2026-03-05 03:18:28', 0),
(166, '27_34', 34, 27, 'hi', '2026-03-05 03:23:45', 0),
(167, '27_34', 34, 27, 'hi', '2026-03-05 03:28:06', 0),
(168, '27_34', 34, 27, 'hi', '2026-03-05 03:28:18', 0),
(169, '27_34', 34, 27, 'hi', '2026-03-05 03:30:17', 0),
(170, '27_34', 34, 27, 'hii', '2026-03-05 03:53:03', 0),
(171, '27_34', 27, 34, 'hi', '2026-03-05 03:53:37', 0),
(172, '27_34', 34, 27, 'hi', '2026-03-05 03:56:40', 0),
(173, '27_34', 34, 27, 'hi', '2026-03-05 04:04:52', 0),
(174, '26_27', 27, 26, 'hi', '2026-03-05 04:05:22', 0),
(175, '27_201', 27, 201, 'hi', '2026-03-05 04:09:02', 0),
(176, '26_27', 27, 26, 'hi', '2026-03-05 04:09:18', 0),
(177, '27_201', 27, 201, 'hi', '2026-03-05 04:26:40', 0),
(178, '27_34', 27, 34, 'hi', '2026-03-05 04:27:04', 0),
(179, '27_34', 34, 27, 'his', '2026-03-05 04:31:14', 0),
(180, '27_34', 27, 34, 'hi', '2026-03-05 04:46:20', 0),
(181, '34_101', 34, 101, 'hi', '2026-03-05 04:52:49', 0),
(182, '27_34', 34, 27, 'hii', '2026-03-05 08:38:55', 0),
(183, '27_34', 27, 34, 'hii', '2026-03-05 08:40:10', 0),
(184, '27_34', 34, 27, 'hi', '2026-03-05 08:53:16', 0),
(185, '27_34', 34, 27, 'hi', '2026-03-05 08:58:50', 0),
(186, '27_35', 35, 27, 'hi', '2026-03-06 04:10:03', 0),
(187, '27_35', 27, 35, 'hi', '2026-03-06 04:10:42', 0),
(188, '27_35', 35, 27, 'hi', '2026-03-06 08:11:47', 0),
(189, '26_27', 27, 26, 'hi', '2026-03-06 08:13:02', 0),
(190, '26_27', 27, 26, 'I need blood', '2026-03-06 08:13:07', 0),
(191, '27_35', 35, 27, 'hi', '2026-03-06 08:14:32', 0),
(192, '35_102', 35, 102, 'hi', '2026-03-06 08:32:26', 0),
(193, '43_45', 45, 43, 'hi', '2026-03-10 07:28:49', 0),
(194, '44_45', 44, 45, 'hi', '2026-03-12 07:51:13', 0),
(195, '39_45', 45, 39, 'hi', '2026-03-12 07:54:22', 0),
(196, '26_101', 26, 101, 'hi', '2026-03-12 09:07:46', 0),
(197, '39_45', 45, 39, 'hi', '2026-03-16 04:03:37', 0),
(198, '45_50', 45, 50, 'hi', '2026-03-16 04:03:42', 0),
(199, '26_45', 26, 45, 'hi', '2026-03-16 04:04:16', 0),
(200, '44_45', 45, 44, 'hi', '2026-03-16 04:04:58', 0),
(201, '26_57', 57, 26, 'hi', '2026-03-16 04:51:39', 0),
(202, '26_57', 57, 26, 'hi', '2026-03-16 04:51:43', 0),
(203, '26_57', 26, 57, 'hi', '2026-03-16 04:52:17', 0),
(204, '26_58', 26, 58, 'hii', '2026-03-16 05:00:32', 0),
(205, '57_201', 57, 201, 'hi', '2026-03-16 05:05:46', 0),
(206, '26_101', 26, 101, 'ji', '2026-03-17 03:45:12', 0),
(207, '26_57', 57, 26, 'hi', '2026-03-17 03:46:43', 0),
(208, '26_57', 57, 26, 'hi', '2026-03-17 07:11:02', 0),
(209, '26_101', 26, 101, 'hi', '2026-03-17 07:41:39', 0),
(210, '26_103', 26, 103, 'hi', '2026-03-17 08:17:39', 0),
(211, '26_101', 26, 101, 'hi', '2026-03-17 09:30:18', 0),
(212, '57_59', 57, 59, 'hi', '2026-03-17 09:31:56', 0),
(213, '26_101', 26, 101, 'hi', '2026-03-18 04:50:33', 0),
(214, '57_59', 57, 59, 'hi', '2026-03-18 04:52:20', 0),
(215, '73_101', 73, 101, 'ufff xyd,', '2026-03-23 05:21:34', 0),
(216, '26_57', 26, 57, 'hi', '2026-03-25 05:00:13', 0),
(217, '57_74', 57, 74, 'hi', '2026-03-26 06:09:06', 0),
(218, '26_101', 26, 101, 'hi', '2026-03-26 13:48:12', 0),
(219, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for o+ (1 units). Are you available to help right now?', '2026-03-27 04:51:33', 0),
(220, '26_57', 26, 57, 'yes', '2026-03-27 04:54:51', 0),
(221, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for B+ (1 units). Are you available to help right now?', '2026-03-27 04:58:20', 0),
(222, '26_57', 26, 57, 'yes', '2026-03-27 05:07:02', 0),
(223, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for A+ (1 units). Are you available to help right now?', '2026-03-27 05:22:39', 0),
(224, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for A+ (1 units). Are you available to help right now?', '2026-03-27 05:24:30', 0),
(225, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for A+ (1 units). Are you available to help right now?', '2026-03-27 05:33:08', 0),
(226, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for A+ (1 units). Are you available to help right now?', '2026-03-27 07:17:00', 0),
(227, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for B- (1 units). Are you available to help right now?', '2026-03-27 07:57:45', 0),
(228, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for B+ (1 units). Are you available to help right now?', '2026-03-27 08:01:57', 0),
(229, '26_57', 26, 57, 'hi', '2026-03-27 08:22:12', 0),
(230, '26_57', 26, 57, 'hi', '2026-03-27 09:21:29', 0),
(231, '26_57', 26, 57, 'hi', '2026-03-27 11:53:47', 0),
(232, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for O+ (1 units). Are you available to help right now?', '2026-03-27 12:54:25', 0),
(233, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for O+ (17units). Are you available to help right now?', '2026-03-27 13:04:40', 0),
(234, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for O+ (1 units). Are you available to help right now?', '2026-03-27 13:13:37', 0),
(235, '26_57', 57, 26, 'Hello Mallikarjuna Reddy, I have an emergency blood request for O+ (1 units). Are you available to help right now?', '2026-03-27 14:03:33', 0),
(236, '26_57', 57, 26, 'hi', '2026-03-28 03:17:25', 0),
(237, '26_57', 57, 26, 'hi', '2026-03-28 04:42:10', 0);

-- --------------------------------------------------------

--
-- Table structure for table `donation_history`
--

CREATE TABLE `donation_history` (
  `id` int(11) NOT NULL,
  `donor_id` int(11) DEFAULT NULL,
  `hospital_name` varchar(255) DEFAULT NULL,
  `units` int(11) DEFAULT NULL,
  `donation_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `donors`
--

CREATE TABLE `donors` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 0,
  `is_eligible` tinyint(1) DEFAULT 1,
  `last_donation_date` date DEFAULT NULL,
  `last_status_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donors`
--

INSERT INTO `donors` (`id`, `user_id`, `phone`, `blood_group`, `age`, `city`, `is_available`, `is_eligible`, `last_donation_date`, `last_status_update`) VALUES
(6, 26, '', 'O+', 0, 'Update Required', 1, 1, NULL, '2026-03-28 07:04:59'),
(25, 59, '2583697410', 'B-', NULL, NULL, 0, 1, NULL, NULL),
(26, 60, '5896321478', 'A-', NULL, NULL, 0, 1, NULL, NULL),
(35, 69, '7013740820', 'O+', NULL, NULL, 0, 1, NULL, NULL),
(36, 72, '1236547890', 'O+', NULL, NULL, 0, 1, NULL, NULL),
(37, 73, '1234568970', 'O-', NULL, NULL, 0, 1, NULL, NULL),
(38, 74, '8765432190', 'O+', NULL, NULL, 0, 1, NULL, NULL),
(39, 75, '2345768', 'B+', 22, 'thadalam', 0, 1, NULL, NULL),
(40, 77, '', 'A+', 0, 'Update Required', 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `donor_donations`
--

CREATE TABLE `donor_donations` (
  `id` int(11) NOT NULL,
  `donor_id` int(11) NOT NULL,
  `donation_date` datetime NOT NULL,
  `units` int(11) DEFAULT 1,
  `blood_group` varchar(5) NOT NULL,
  `location` varchar(150) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donor_donations`
--

INSERT INTO `donor_donations` (`id`, `donor_id`, `donation_date`, `units`, `blood_group`, `location`, `notes`, `created_at`) VALUES
(4, 26, '2026-02-27 10:30:00', 2, 'O+', 'Chennai GH', 'Regular donation', '2026-02-27 11:51:06'),
(7, 26, '2026-03-27 10:30:00', 1, 'O+', 'Chennai GH', 'Regular donation', '2026-03-27 17:44:20'),
(8, 26, '2026-03-27 15:00:00', 2, 'O+', 'LifeFlow Center', 'Scheduled appointment', '2026-03-27 17:59:32'),
(9, 26, '2026-03-27 10:00:00', 1, 'O+', 'LifeFlow Center', 'Scheduled appointment', '2026-03-27 18:07:03'),
(10, 26, '2026-03-28 09:00:00', 1, 'A+', 'LifeFlow Center', 'Scheduled appointment', '2026-03-28 13:11:37');

-- --------------------------------------------------------

--
-- Table structure for table `donor_requests`
--

CREATE TABLE `donor_requests` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `donor_id` int(11) NOT NULL,
  `blood_group` varchar(5) NOT NULL,
  `units_needed` int(11) NOT NULL,
  `urgency` varchar(20) DEFAULT 'NORMAL',
  `message` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donor_requests`
--

INSERT INTO `donor_requests` (`id`, `patient_id`, `donor_id`, `blood_group`, `units_needed`, `urgency`, `message`, `status`, `created_at`) VALUES
(10, 57, 26, 'O+', 2, 'HIGH', 'Emergency need blood', 'PENDING', '2026-03-27 09:36:59'),
(11, 57, 26, 'O+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:22:24'),
(12, 57, 26, 'O+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:22:31'),
(13, 57, 26, 'O+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:22:37'),
(14, 57, 26, 'B+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:28:15'),
(15, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:35:02'),
(16, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:52:42'),
(17, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 10:54:24'),
(18, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 11:03:10'),
(19, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 12:46:40'),
(20, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 12:46:44'),
(21, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 12:46:46'),
(22, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 12:55:21'),
(23, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:18:35'),
(24, 57, 26, 'A+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:18:49'),
(25, 57, 26, 'B-', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:27:48'),
(26, 57, 26, 'B-', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:27:50'),
(27, 57, 26, 'B+', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:31:59'),
(28, 57, 26, 'B-', 1, 'NORMAL', NULL, 'PENDING', '2026-03-27 13:51:23'),
(29, 57, 26, 'O+', 2, 'HIGH', 'Emergency need blood', 'PENDING', '2026-03-27 17:48:15'),
(30, 57, 26, 'O+', 2, 'HIGH', 'Emergency need blood', 'PENDING', '2026-03-27 18:33:09'),
(31, 57, 26, 'O+', 2, 'HIGH', 'Emergency need blood', 'PENDING', '2026-03-27 18:42:05'),
(32, 57, 26, 'O+', 2, 'HIGH', 'Emergency need blood', 'PENDING', '2026-03-27 18:59:44'),
(34, 57, 26, 'O+', 1, 'EMERGENCY', 'Emergency need blood - Direct Request from Map', 'PENDING', '2026-03-27 19:33:23'),
(35, 57, 26, 'O+', 1, 'EMERGENCY', 'Emergency need blood - Direct Request from Map', 'PENDING', '2026-03-27 19:33:28'),
(36, 57, 26, 'O+', 1, 'EMERGENCY', 'Emergency need blood - Direct Request from Map', 'PENDING', '2026-03-27 19:41:32'),
(37, 57, 26, 'O+', 1, 'EMERGENCY', 'Emergency need blood - Direct Request from Map', 'PENDING', '2026-03-28 09:54:27'),
(38, 57, 26, 'B-', 1, 'NORMAL', 'Direct Request from Map', 'PENDING', '2026-03-28 11:15:18');

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `hospital_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `hospital_name` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `units_needed` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `user_id`, `phone`, `blood_group`, `hospital_name`, `city`, `created_at`, `units_needed`) VALUES
(1, 5, NULL, NULL, NULL, NULL, '2026-02-24 04:03:42', 0),
(2, 27, NULL, NULL, NULL, NULL, '2026-02-26 03:58:45', 0),
(3, 29, NULL, NULL, NULL, NULL, '2026-03-02 08:19:57', 0),
(4, 42, NULL, 'A+', 'City Hospital', 'Hyderabad', '2026-03-09 09:21:34', 0),
(5, 45, '7013740820', 'B-', NULL, NULL, '2026-03-10 07:28:12', 0),
(6, 56, '7013740820', 'O-', NULL, NULL, '2026-03-16 04:34:58', 0),
(7, 57, 'rbebeb', 'O+', 'sbsbsb', 'sbsbsb', '2026-03-16 04:37:05', 0),
(8, 58, '6374258264', 'O+', NULL, NULL, '2026-03-16 04:55:50', 0),
(9, 70, '1234567890', 'AB-', NULL, NULL, '2026-03-23 04:55:17', 0),
(10, 71, '3337892324', 'O+', NULL, NULL, '2026-03-23 04:59:51', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('donor','patient','hospital') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `otp` varchar(6) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `otp`, `otp_expiry`, `latitude`, `longitude`, `phone`, `blood_group`) VALUES
(26, 'Mallikarjuna Reddy', 'mallireddy794@gmail.com', 'scrypt:32768:8:1$NtpC9CqPRPSBMYlO$3f10dce7fd68483080a55d23e79b55052b94b51ee78863f63c3897cb9a7bac3c608f1e42682c13f97ea8a3d7ae2e11de55c6a8c324942cf88730d76228e55fcb', 'donor', '2026-02-26 03:40:31', NULL, NULL, 13.0262942, 80.0152391, NULL, NULL),
(57, 'Mallikarjuna Reddy', 'mr1602209@gmail.com', 'scrypt:32768:8:1$9CL8DGRvuOk3ziWB$af5e08b09520079282bf170eee1dd0c75cecf5e0148cd086d8ac6de0606cf7622fa1a273b5c4e01b89fb5990af2b6768d673e6d2f85b65f12897fd2da5b1bc93', 'patient', '2026-03-16 04:37:05', '743984', '2026-03-28 10:09:20', 13.0287153, 80.0346524, NULL, NULL),
(58, 'layna', 'layna4115@gmail.com', 'scrypt:32768:8:1$vzQrUFOwPaKJk50r$e5455961336f3c8b84a0c08985baf0ab1b505cc9e4b72014a9d6d29ed8f94af3d3d713cee1143ef168e460ebb9089f372ad40a7843e9db64a3ecdb56a9b2468c', 'patient', '2026-03-16 04:55:50', NULL, NULL, NULL, NULL, NULL, NULL),
(59, 'Malli', 'vinithamallikarjunareddy0342.sse@saveetha.com', 'scrypt:32768:8:1$H0HlG6ld1gBZKQXQ$75d94f13cefde47ce5380c9afeb66dd2374892ce40d3f23b24b3bdf4f0f5b89d8ef540be9b4c14e2a634f6a280a42d807e2570b675cc9f569620095ee49bf2f2', 'donor', '2026-03-17 08:39:43', NULL, NULL, NULL, NULL, NULL, NULL),
(60, 'p', 'p@gmail.com', 'scrypt:32768:8:1$HIJMiQGC4pSKPIm8$9e0fce88697a1a66a192e2d9ca8f10ae55a2916cdad9e76baec75b4346e8a0181a76fb5d7ca146b298c62cf8eda6143fb9cdb76345d5ae452aca197fd6e3170b', 'donor', '2026-03-18 09:03:24', NULL, NULL, NULL, NULL, NULL, NULL),
(69, 'Mallikarjuna Reddy', 'test_123@business.co.in', 'scrypt:32768:8:1$b3x3L0S4C0CJp4cw$99571f37fc4ff145fa3073f76718e828e03c89de85bf82fc6cececa408e77f82f6ec76b19a08e0b3c049238531ff64fa0acca1ecfffda04c0e46f43c69b5efa3', 'donor', '2026-03-23 04:13:05', NULL, NULL, NULL, NULL, NULL, NULL),
(70, 'sai', 'chsaikalyan12@gmail.co', 'scrypt:32768:8:1$lyMX9xkOulDThhhk$01d754c8e24ca5cef71a3d32d0188059c720102e0de5974edb208306cb00d7f97fe144bffdbfb7f59c2a1e461af979f9ac490a25c4adaf2e725fe9fd015d4b22', 'patient', '2026-03-23 04:55:17', NULL, NULL, NULL, NULL, NULL, NULL),
(71, '47222222684y', '1@gmail.com', 'scrypt:32768:8:1$U4zeOb25qmLJEQnV$b3f445675b1b5a0525ad324fed2f005a858127866277e2695a37cb243b8a54ccde4f9e802ab7a4fccd0b6e4928c6f8e3be6743c866bbc822f8d0a440162f269f', 'patient', '2026-03-23 04:59:51', NULL, NULL, NULL, NULL, NULL, NULL),
(72, '1', 'q@gmail.com', 'scrypt:32768:8:1$iOQQmwL5tLFIOojg$6b6a6a0e9cbfd8a2835828165f62c4648eb54f39d0cc1a94f8c9d3f224ad651e23111e1785aebb475344dd272c34c73f573c5dfdbe8cd213fa2b893a3f9d422c', 'donor', '2026-03-23 05:09:13', NULL, NULL, NULL, NULL, NULL, NULL),
(73, '1', '2@gmail.com', 'scrypt:32768:8:1$TAJyRJ4ZPiF6DqXN$4a21b1cda42a561e17dbc3862f0c7c3cd3dfad7018562dd9aeb373343eb7dd3be0f60d4588efbae96895b8ba7e53139527c6b6d79d6368ec9bf6f3ccc6b12647', 'donor', '2026-03-23 05:10:51', NULL, NULL, NULL, NULL, NULL, NULL),
(74, 'malli', 'malli794@gmail.com', 'scrypt:32768:8:1$aEkf3YPs1utxfPUr$fcf89d265d0fee847567001829a577c6ef14d64cb689ca842d49faf74ce7dcfc1bfd34d701c852a77310ee0aa1a3b34421bfffc1b0f16069a0def456fe3b09c7', 'donor', '2026-03-25 03:38:31', NULL, NULL, NULL, NULL, NULL, NULL),
(75, 'Mallikarjuna Reddy', 'chsaikalyan12@gmail.com', 'scrypt:32768:8:1$rPg40uchtnQ6kqqW$93d3db4d6c3cd8c22335f8c96eb6c2cd20a0925fc5bfc168991c5741bf92d65f06186ccaee376a4926125fcb84cd466f76f2ba0d1e11b34c5e61103fea6a9f6a', 'donor', '2026-03-28 07:08:04', NULL, NULL, NULL, NULL, NULL, NULL),
(77, 'Mallikarjuna', '8@gmail.com', 'scrypt:32768:8:1$3gDNvgJT3w9NJon1$e0ab6f511fe41904f27c13762cf0b99f0604ecd6dd1b2f4d7f9e22461013f8ca0f31729c843e432f4529a84c51593abf1b5249b7eb6c2544ea2c5bd3d9f7756b', 'donor', '2026-03-28 07:12:37', NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donor_fk` (`donor_id`);

--
-- Indexes for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `donation_history`
--
ALTER TABLE `donation_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donor_id` (`donor_id`);

--
-- Indexes for table `donors`
--
ALTER TABLE `donors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `idx_donors_blood_group` (`blood_group`);

--
-- Indexes for table `donor_donations`
--
ALTER TABLE `donor_donations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donor_id` (`donor_id`);

--
-- Indexes for table `donor_requests`
--
ALTER TABLE `donor_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_donor_requests_donor` (`donor_id`,`status`,`created_at`),
  ADD KEY `idx_donor_requests_patient` (`patient_id`,`status`,`created_at`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ix_hospitals_id` (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_patients_blood_group` (`blood_group`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_location` (`latitude`,`longitude`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT for table `donation_history`
--
ALTER TABLE `donation_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `donor_donations`
--
ALTER TABLE `donor_donations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `donor_requests`
--
ALTER TABLE `donor_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD CONSTRAINT `donor_fk` FOREIGN KEY (`donor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `donation_history`
--
ALTER TABLE `donation_history`
  ADD CONSTRAINT `donation_history_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `donors`
--
ALTER TABLE `donors`
  ADD CONSTRAINT `donors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `donor_donations`
--
ALTER TABLE `donor_donations`
  ADD CONSTRAINT `donor_donations_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `donor_requests`
--
ALTER TABLE `donor_requests`
  ADD CONSTRAINT `donor_requests_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `donor_requests_ibfk_2` FOREIGN KEY (`donor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD CONSTRAINT `hospitals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
