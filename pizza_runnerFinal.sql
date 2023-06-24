-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 24, 2023 at 04:28 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pizza_runner`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancellationsReport` ()   BEGIN 
SELECT * FROM cancelled_orders;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_ordered_pizzas_in_day` (IN `day_date` DATE)   BEGIN
  SELECT COUNT(*) AS total_pizzas
  FROM customer_orders
  WHERE DATE(order_time) = day_date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customerOrdersReport` ()   BEGIN
	SELECT DISTINCT * FROM  customer_orders
	ORDER BY customer_orders.order_id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mostOrderedPizzaInDate` (IN `dateInput` DATE)   BEGIN
SET @formattedDate = DATE_FORMAT(dateInput, '%m/%d/%Y');
SELECT customer_orders.pizza_id, COUNT(customer_orders.order_time) AS "Order Count" FROM customer_orders WHERE @formattedDate = DATE_FORMAT(customer_orders.order_time, '%m/%d/%Y') 
GROUP BY customer_orders.pizza_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pizzaOrderedInDate` (IN `dateInput` DATE)   BEGIN
SET @formattedDateInput = DATE_FORMAT(dateInput, '%m/%d/%Y');
SELECT customer_orders.order_time, COUNT(customer_orders.order_id) AS "Pizzas Ordered" FROM customer_orders WHERE @formattedDateInput = DATE_FORMAT(customer_orders.order_time, '%m/%d/%Y') ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `canceled_orders_audit`
--

CREATE TABLE `canceled_orders_audit` (
  `order_id` int(11) DEFAULT NULL,
  `runner_id` int(11) DEFAULT NULL,
  `pickup_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `canceled_orders_audit`
--

INSERT INTO `canceled_orders_audit` (`order_id`, `runner_id`, `pickup_time`) VALUES
(6, 3, 0),
(9, 2, 0),
(11, 2, 2147483647);

-- --------------------------------------------------------

--
-- Table structure for table `cancelled_orders`
--

CREATE TABLE `cancelled_orders` (
  `order_id` int(10) NOT NULL,
  `runner_id` int(10) NOT NULL,
  `date_and_time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cancelled_orders`
--

INSERT INTO `cancelled_orders` (`order_id`, `runner_id`, `date_and_time`) VALUES
(11, 2, '2023-06-10 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `age` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `name`, `email`, `age`) VALUES
(101, 'Peter Peterson', 'peterpeter@gmail.com', 21),
(102, 'Jeff Simons', 'simonsJeff@gmail.com', 22),
(103, 'Maria Reyna', 'MR@yahoo.com', 23),
(104, 'Ryan Reynolds', 'deadpoolRules@marvel.com', 32),
(105, 'River Jordan', 'jordanrivers@hotmail.com', 19);

-- --------------------------------------------------------

--
-- Table structure for table `customer_orders`
--

CREATE TABLE `customer_orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `pizza_id` int(11) NOT NULL,
  `exclusions` varchar(4) DEFAULT NULL,
  `extras` varchar(4) DEFAULT NULL,
  `order_time` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_orders`
--

INSERT INTO `customer_orders` (`order_id`, `customer_id`, `pizza_id`, `exclusions`, `extras`, `order_time`) VALUES
(1, 101, 1, NULL, NULL, '2020-01-01 10:05:02'),
(2, 101, 1, NULL, NULL, '2020-01-01 11:00:52'),
(3, 102, 1, NULL, NULL, '2020-01-02 15:51:23'),
(3, 102, 2, NULL, NULL, '2020-01-02 15:51:23'),
(4, 103, 1, '4', NULL, '2020-01-04 05:23:46'),
(4, 103, 1, '4', NULL, '2020-01-04 05:23:46'),
(4, 103, 2, '4', NULL, '2020-01-04 05:23:46'),
(5, 104, 1, NULL, '1', '2020-01-08 13:00:29'),
(6, 101, 2, NULL, NULL, '2020-01-08 13:03:13'),
(7, 105, 2, NULL, '1', '2020-01-08 13:20:29'),
(8, 102, 1, NULL, NULL, '2020-01-09 15:54:33'),
(9, 103, 1, '4', '1, 5', '2020-01-10 03:22:59'),
(10, 104, 1, NULL, NULL, '2020-01-11 10:34:49'),
(10, 104, 1, '2, 6', '1, 4', '2020-01-11 10:34:49');

-- --------------------------------------------------------

--
-- Table structure for table `pizza_names`
--

CREATE TABLE `pizza_names` (
  `pizza_id` int(11) NOT NULL,
  `pizza_name` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pizza_names`
--

INSERT INTO `pizza_names` (`pizza_id`, `pizza_name`) VALUES
(1, 'Meatlovers'),
(2, 'Vegetarian');

-- --------------------------------------------------------

--
-- Table structure for table `pizza_recipes`
--

CREATE TABLE `pizza_recipes` (
  `pizza_id` int(11) NOT NULL,
  `toppings` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pizza_recipes`
--

INSERT INTO `pizza_recipes` (`pizza_id`, `toppings`) VALUES
(1, '1, 2, 3, 4, 5, 6, 8, 10'),
(2, '4, 6, 7, 9, 11, 12');

-- --------------------------------------------------------

--
-- Table structure for table `pizza_toppings`
--

CREATE TABLE `pizza_toppings` (
  `topping_id` int(11) NOT NULL,
  `topping_name` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pizza_toppings`
--

INSERT INTO `pizza_toppings` (`topping_id`, `topping_name`) VALUES
(1, 'Bacon'),
(2, 'BBQ Sauce'),
(3, 'Beef'),
(4, 'Cheese'),
(5, 'Chicken'),
(6, 'Mushrooms'),
(7, 'Onions'),
(8, 'Pepperoni'),
(9, 'Peppers'),
(10, 'Salami'),
(11, 'Tomatoes'),
(12, 'Tomato Sauce');

-- --------------------------------------------------------

--
-- Table structure for table `runners`
--

CREATE TABLE `runners` (
  `runner_id` int(11) NOT NULL,
  `registration_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `runners`
--

INSERT INTO `runners` (`runner_id`, `registration_date`) VALUES
(1, '2021-01-01'),
(2, '2021-01-03'),
(3, '2021-01-08'),
(4, '2021-01-15');

-- --------------------------------------------------------

--
-- Table structure for table `runner_orders`
--

CREATE TABLE `runner_orders` (
  `order_id` int(11) NOT NULL,
  `runner_id` int(11) NOT NULL,
  `pickup_time` datetime DEFAULT NULL,
  `distance(km)` int(10) DEFAULT NULL,
  `duration(min)` int(10) DEFAULT NULL,
  `cancellation` varchar(23) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `runner_orders`
--

INSERT INTO `runner_orders` (`order_id`, `runner_id`, `pickup_time`, `distance(km)`, `duration(min)`, `cancellation`) VALUES
(1, 1, '2020-01-01 18:15:34', 20, 32, NULL),
(2, 1, '2020-01-01 19:10:54', 20, 27, NULL),
(3, 1, '2020-01-03 00:12:37', 13, 20, NULL),
(4, 2, '2020-01-04 13:53:03', 23, 40, NULL),
(5, 3, '2020-01-08 21:10:57', 10, 15, NULL),
(6, 3, '0000-00-00 00:00:00', 0, 0, 'Restaurant Cancellation'),
(7, 2, '2020-01-08 21:30:45', 25, 25, NULL),
(8, 2, '2020-01-10 00:15:02', 23, 15, NULL),
(9, 2, '0000-00-00 00:00:00', 0, 0, 'Customer Cancellation'),
(10, 1, '2020-01-11 18:50:20', 10, 10, NULL),
(11, 2, '2023-06-10 00:00:00', NULL, NULL, 'Customer cancellation');

--
-- Triggers `runner_orders`
--
DELIMITER $$
CREATE TRIGGER `updateCancellation` AFTER UPDATE ON `runner_orders` FOR EACH ROW BEGIN 
IF !(OLD.cancellation <=> NEW.cancellation) THEN
	INSERT INTO cancelled_orders (order_id, runner_id, date_and_time)
    VALUES (OLD.order_id, OLD.runner_id, CURRENT_DATE());
END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `customer_orders`
--
ALTER TABLE `customer_orders`
  ADD KEY `order_id` (`order_id`),
  ADD KEY `pizza_id` (`pizza_id`),
  ADD KEY `customer_orders_ibfk_4` (`customer_id`);

--
-- Indexes for table `pizza_names`
--
ALTER TABLE `pizza_names`
  ADD PRIMARY KEY (`pizza_id`);

--
-- Indexes for table `pizza_recipes`
--
ALTER TABLE `pizza_recipes`
  ADD PRIMARY KEY (`pizza_id`);

--
-- Indexes for table `pizza_toppings`
--
ALTER TABLE `pizza_toppings`
  ADD PRIMARY KEY (`topping_id`);

--
-- Indexes for table `runners`
--
ALTER TABLE `runners`
  ADD PRIMARY KEY (`runner_id`);

--
-- Indexes for table `runner_orders`
--
ALTER TABLE `runner_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `runner_id` (`runner_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_orders`
--
ALTER TABLE `customer_orders`
  ADD CONSTRAINT `customer_orders_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `runner_orders` (`order_id`),
  ADD CONSTRAINT `customer_orders_ibfk_2` FOREIGN KEY (`pizza_id`) REFERENCES `pizza_recipes` (`pizza_id`),
  ADD CONSTRAINT `customer_orders_ibfk_3` FOREIGN KEY (`pizza_id`) REFERENCES `pizza_names` (`pizza_id`),
  ADD CONSTRAINT `customer_orders_ibfk_4` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `runner_orders`
--
ALTER TABLE `runner_orders`
  ADD CONSTRAINT `runner_orders_ibfk_1` FOREIGN KEY (`runner_id`) REFERENCES `runners` (`runner_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
