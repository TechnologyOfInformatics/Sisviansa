-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 25, 2023 at 01:25 AM
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
-- Database: `awarena meinu`
--
CREATE DATABASE IF NOT EXISTS `awarena meinu` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `awarena meinu`;

-- --------------------------------------------------------

--
-- Table structure for table `actividad`
--

DROP TABLE IF EXISTS `actividad`;
CREATE TABLE `actividad` (
  `id` int(15) NOT NULL COMMENT 'ID único de la actividad el cual se usa para identificarla',
  `inicio_de_actividad` datetime NOT NULL COMMENT 'Fecha y hora en la cual se inicio la actividad',
  `usuario_ci` varchar(8) NOT NULL COMMENT 'CI que pertenece a un usuario el cual inicio esta actividad',
  `estado` enum('Activa','Finalizada') NOT NULL COMMENT 'Estado de la actividad a la que se hace referencia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id` int(11) NOT NULL COMMENT 'ID único del cliente el cual es autogenerado',
  `calle` varchar(30) DEFAULT NULL COMMENT 'Calle frontal del lugar donde el cliente recibe los pedidos',
  `barrio` varchar(30) DEFAULT NULL COMMENT 'Barrio donde el cliente recibe los pedidos',
  `ciudad` varchar(30) DEFAULT NULL COMMENT 'Ciudad donde el cliente recibe los pedidos',
  `email` varchar(40) NOT NULL COMMENT 'ID único correspondiente al cliente',
  `contrasenia` varchar(40) NOT NULL COMMENT 'Contraseña de la cuenta correspondiente al cliente',
  `autorizacion` enum('Autorizado','En espera','No autorizado') NOT NULL COMMENT 'Estado del pedido de autorizacion del administrador'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cliente`
--

INSERT INTO `cliente` (`id`, `calle`, `barrio`, `ciudad`, `email`, `contrasenia`, `autorizacion`) VALUES
(1, 'Calle 1', 'Barrio A', 'Ciudad X', 'cliente1@example.com', 'contrasenia1', 'Autorizado'),
(2, 'Calle 2', 'Barrio B', 'Ciudad Y', 'cliente2@example.com', 'contrasenia2', 'Autorizado'),
(3, 'Calle 3', 'Barrio C', 'Ciudad Z', 'cliente3@example.com', 'contrasenia3', 'Autorizado'),
(4, 'Calle 4', 'Barrio D', 'Ciudad W', 'cliente4@example.com', 'contrasenia4', 'Autorizado'),
(5, 'Calle 5', 'Barrio E', 'Ciudad X', 'cliente5@example.com', 'contrasenia5', 'Autorizado'),
(6, 'Calle 6', 'Barrio F', 'Ciudad Y', 'cliente6@example.com', 'contrasenia6', 'Autorizado'),
(7, 'Calle 7', 'Barrio G', 'Ciudad Z', 'cliente7@example.com', 'contrasenia7', 'Autorizado'),
(8, 'Calle 8', 'Barrio H', 'Ciudad W', 'cliente8@example.com', 'contrasenia8', 'Autorizado'),
(9, 'Calle 9', 'Barrio I', 'Ciudad X', 'cliente9@example.com', 'contrasenia9', 'Autorizado'),
(10, 'Calle 10', 'Barrio J', 'Ciudad Y', 'cliente10@example.com', 'contrasenia10', 'Autorizado'),
(30, NULL, NULL, NULL, 'amsdassdsasda', 'asdasddasdas', 'En espera');

-- --------------------------------------------------------

--
-- Table structure for table `cliente_telefono`
--

DROP TABLE IF EXISTS `cliente_telefono`;
CREATE TABLE `cliente_telefono` (
  `telefono` varchar(15) NOT NULL COMMENT 'Telefono correspondiente al cliente',
  `cliente_id` int(11) NOT NULL COMMENT 'Cliente dueño poseedor de telefono'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `conforma`
--

DROP TABLE IF EXISTS `conforma`;
CREATE TABLE `conforma` (
  `menu_id` int(11) NOT NULL COMMENT 'ID del menu correspondiente a la caja',
  `vianda_id` int(11) NOT NULL COMMENT 'ID de la vianda correspondiente a la caja',
  `stock_actual` int(11) DEFAULT NULL COMMENT 'Stock actual de la caja',
  `stock_maximo` int(11) DEFAULT 10 COMMENT 'Stock maximo de la caja',
  `stock_minimo` int(11) DEFAULT 5 COMMENT 'Stock minimo de la caja',
  `fecha_vencimiento` date NOT NULL COMMENT 'Fecha de vencimiento de la caja',
  `estado` enum('Solicitada','En stock','En producción','Envasada','Entregada','Devuelta','Desechada') NOT NULL COMMENT 'Estado actual del pedido',
  `fecha_de_creacion` date NOT NULL COMMENT 'Fecha de creacion del menú',
  `demora_total` int(11) NOT NULL COMMENT 'Tiempo que demora en totalidad el producto en hacerse'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conforma`
--

INSERT INTO `conforma` (`menu_id`, `vianda_id`, `stock_actual`, `stock_maximo`, `stock_minimo`, `fecha_vencimiento`, `estado`, `fecha_de_creacion`, `demora_total`) VALUES
(1, 1, 7, 10, 5, '2023-08-01', 'Solicitada', '2023-07-23', 0),
(2, 2, 5, 10, 5, '2023-08-02', 'En stock', '2023-07-23', 0),
(3, 3, 8, 10, 5, '2023-08-03', 'En producción', '2023-07-23', 0),
(4, 4, 2, 10, 5, '2023-08-04', 'Envasada', '2023-07-23', 0),
(5, 5, 9, 10, 5, '2023-08-05', 'Entregada', '2023-07-23', 0),
(6, 6, 3, 10, 5, '2023-08-06', 'Devuelta', '2023-07-23', 0),
(7, 7, 0, 10, 5, '2023-08-07', 'Desechada', '2023-07-23', 0),
(8, 8, 6, 10, 5, '2023-08-08', 'Solicitada', '2023-07-23', 0),
(9, 9, 4, 10, 5, '2023-08-09', 'En stock', '2023-07-23', 0),
(10, 10, 1, 10, 5, '2023-08-10', 'En producción', '2023-07-23', 0);

-- --------------------------------------------------------

--
-- Table structure for table `empresa`
--

DROP TABLE IF EXISTS `empresa`;
CREATE TABLE `empresa` (
  `rut` varchar(12) NOT NULL COMMENT 'RUT de la empresa',
  `nombre` varchar(30) NOT NULL COMMENT 'Nombre de la empresa oficial',
  `cliente_id` int(11) NOT NULL COMMENT 'ID de la empresa dentro de la tabla de clientes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorito`
--

DROP TABLE IF EXISTS `favorito`;
CREATE TABLE `favorito` (
  `menu_id` int(11) NOT NULL COMMENT 'ID del correspondiente al favorito',
  `web_id` int(11) NOT NULL COMMENT 'ID del cliente que ha dado su favorito'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `favorito`
--

INSERT INTO `favorito` (`menu_id`, `web_id`) VALUES
(1, 1),
(1, 6),
(2, 2),
(2, 10),
(3, 3),
(3, 8),
(4, 1),
(4, 4),
(5, 5),
(5, 9),
(6, 6),
(6, 7),
(7, 5),
(7, 7),
(8, 3),
(8, 8),
(9, 2),
(9, 9),
(10, 4),
(10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `inicia`
--

DROP TABLE IF EXISTS `inicia`;
CREATE TABLE `inicia` (
  `sesion_token` varchar(15) NOT NULL COMMENT 'Token correspondiente a la sesion',
  `cliente_id` int(11) NOT NULL COMMENT 'ID del cliente que inicio la sesion'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL COMMENT 'ID único del menú el cual es autogenerado',
  `nombre` varchar(30) NOT NULL COMMENT 'Nombre del menú que hace referencia a las viandas que lo contienen',
  `calorias` int(11) DEFAULT NULL COMMENT 'Calorías totales correspondientes al menú',
  `frecuencia` int(11) DEFAULT NULL COMMENT 'Frecuencia con la que se entre éste menú',
  `descripcion` varchar(120) DEFAULT NULL COMMENT 'La descripcion del menu',
  `precio` int(11) NOT NULL COMMENT 'Precio del menu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `nombre`, `calorias`, `frecuencia`, `descripcion`, `precio`) VALUES
(1, 'Menu1', 500, 1, 'Menu del día 1', 11),
(2, 'Menu2', 700, 7, 'Menu del día 2', 13),
(3, 'Menu3', 400, 15, 'Menu del día 3', 10),
(4, 'Menu4', 600, 1, 'Menu del día 4', 11),
(5, 'Menu5', 800, 7, 'Menu del día 5', 14),
(6, 'Menu6', 550, 30, 'Menu del día 6', 12),
(7, 'Menu7', 450, 1, 'Menu del día 7', 10),
(8, 'Menu8', 650, 7, 'Menu del día 8', 13),
(9, 'Menu9', 700, 30, 'Menu del día 9', 14),
(10, 'Menu10', 500, 15, 'Menu del día 10', 11);

-- --------------------------------------------------------

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
CREATE TABLE `permisos` (
  `id` int(11) NOT NULL COMMENT 'ID único del permiso que es generado automáticamente',
  `nombre` varchar(30) NOT NULL COMMENT 'Nombre del permiso, éste es autodescriptivo como por ejemplo "Despedir" para tener el permiso para despedir a un usuario.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pide`
--

DROP TABLE IF EXISTS `pide`;
CREATE TABLE `pide` (
  `menu_id` int(11) NOT NULL COMMENT 'ID del menu correspondiente al pedido',
  `vianda_id` int(11) NOT NULL COMMENT 'ID de la vianda correspondiente al pedido',
  `cliente_id` int(11) NOT NULL COMMENT 'ID del cliente que ha efectuado el pedido',
  `fecha_pedido` date NOT NULL COMMENT 'Fecha del pedido'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sesion`
--

DROP TABLE IF EXISTS `sesion`;
CREATE TABLE `sesion` (
  `token` varchar(15) NOT NULL COMMENT 'Código único conocido como token el cual se usa para identificar una sesion',
  `inicio_de_sesion` datetime NOT NULL COMMENT 'Fecha y hora en la cual se inicio la sesíon',
  `ultima_sesion` datetime NOT NULL COMMENT 'Fecha y hora del ultmo inicio de sesíon',
  `final_de_sesion` datetime NOT NULL COMMENT 'Fecha y hora donde la sesion se terminará sesíon',
  `estado` enum('Activa','Finalizada') NOT NULL COMMENT 'Estado de la sesion a la que se hace referencia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sesion`
--

INSERT INTO `sesion` (`token`, `inicio_de_sesion`, `ultima_sesion`, `final_de_sesion`, `estado`) VALUES
('0WeGy5MYIpAryN', '2023-07-24 23:17:25', '2023-07-24 23:29:30', '2023-07-24 23:44:30', 'Finalizada'),
('3KEBd?tgdvdSzK', '2023-07-24 18:49:23', '2023-07-24 19:00:43', '2023-07-24 19:15:43', 'Finalizada'),
('GW865KXRL', '2023-07-24 23:17:08', '2023-07-24 23:32:08', '2023-07-24 23:32:08', 'Finalizada'),
('Ka8WYu8A5z', '2023-07-24 19:53:58', '2023-07-24 20:08:58', '2023-07-24 20:08:58', 'Finalizada'),
('ZM7jiFJxQ', '2023-07-24 22:40:42', '2023-07-24 22:46:51', '2023-07-24 23:01:51', 'Finalizada');

-- --------------------------------------------------------

--
-- Table structure for table `tarjeta`
--

DROP TABLE IF EXISTS `tarjeta`;
CREATE TABLE `tarjeta` (
  `numero` varchar(30) NOT NULL COMMENT 'Número de la tarjeta de crédito a usarse',
  `fecha_de_vencimiento` date NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta de crédito a usarse',
  `nombre_de_titular` varchar(30) NOT NULL COMMENT 'Nombre del titular que figura en la tarjeta de crédito correspondiente',
  `cliente_id` int(11) DEFAULT NULL COMMENT 'ID que pertenece a un cliente, el poseedor de ésta tarjeta de crédito'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tiene`
--

DROP TABLE IF EXISTS `tiene`;
CREATE TABLE `tiene` (
  `usuario_ci` varchar(8) NOT NULL COMMENT 'CI del usuario',
  `permisos_id` int(11) NOT NULL COMMENT 'Permiso dado al usuario correspondiente.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `ci` varchar(8) NOT NULL COMMENT 'CI del usuario el cual es ingresado a la hora de crearlo',
  `contrasenia` varchar(30) NOT NULL COMMENT 'Contraseña del usuario',
  `rol` enum('Jefe','Supervisar','Cocinar','Repartir','Encargar') DEFAULT NULL COMMENT 'Rol actual del usuario que se refiere al puesto del mismo en la empresa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vianda`
--

DROP TABLE IF EXISTS `vianda`;
CREATE TABLE `vianda` (
  `id` int(11) NOT NULL COMMENT 'ID único de la vianda que se crea automáticamente',
  `nombre` varchar(30) NOT NULL COMMENT 'Nombre de la vianda, hace referencia a la comida que tiene dentro',
  `tiempo_de_coccion` int(11) DEFAULT NULL COMMENT 'Su tiempo de cocción estimado',
  `productos` varchar(150) NOT NULL COMMENT 'Productos que componen la vianda',
  `stock` int(11) NOT NULL COMMENT 'Stock actual de la vianda',
  `calorias` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vianda`
--

INSERT INTO `vianda` (`id`, `nombre`, `tiempo_de_coccion`, `productos`, `stock`, `calorias`) VALUES
(1, 'Vianda1', 30, 'Arroz, pollo, brócoli', 50, 100),
(2, 'Vianda2', 20, 'Pasta, carne molida, tomate, queso', 40, 100),
(3, 'Vianda3', 40, 'Pescado, papas, espárragos', 30, 100),
(4, 'Vianda4', 25, 'Pollo, batatas, zanahorias', 60, 100),
(5, 'Vianda5', 35, 'Tofu, quinoa, espinacas', 70, 100),
(6, 'Vianda6', 30, 'Salmón, arroz integral, brócoli', 45, 100),
(7, 'Vianda7', 20, 'Carne de res, pimientos, cebolla', 55, 100),
(8, 'Vianda8', 40, 'Atún, fideos, maíz', 65, 100),
(9, 'Vianda9', 25, 'Pollo, arroz, zanahorias, guisantes', 75, 100),
(10, 'Vianda10', 35, 'Carne de cerdo, batatas, judías verdes', 50, 100);

-- --------------------------------------------------------

--
-- Table structure for table `vianda_dieta`
--

DROP TABLE IF EXISTS `vianda_dieta`;
CREATE TABLE `vianda_dieta` (
  `dieta` varchar(100) NOT NULL COMMENT 'Nombre de la dieta, el cual normalmente hace alucion a un conjunto de comidas que tienen una misma cualidad',
  `vianda_id` int(11) NOT NULL COMMENT 'ID de la vianda que tiene ésta dieta'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vianda_dieta`
--

INSERT INTO `vianda_dieta` (`dieta`, `vianda_id`) VALUES
('básica', 1),
('vegana', 2),
('vegetariana', 3),
('celiaca', 4),
('básica', 5),
('vegana', 6),
('vegetariana', 7),
('celiaca', 8),
('básica', 9),
('vegana', 10);

-- --------------------------------------------------------

--
-- Table structure for table `web`
--

DROP TABLE IF EXISTS `web`;
CREATE TABLE `web` (
  `tipo` varchar(20) NOT NULL COMMENT 'Tipo de documento de identificacion del cliente web',
  `numero` int(11) NOT NULL COMMENT 'Numero correspondiente al tipo de documento del cliente web',
  `primer_nombre` varchar(30) NOT NULL COMMENT 'Primer nombre del cliente correspondiente',
  `segundo_nombre` varchar(30) DEFAULT NULL COMMENT 'Segundo nombre del cliente correspondiente',
  `primer_apellido` varchar(30) NOT NULL COMMENT 'Primer apellido del cliente correspondiente',
  `segundo_apellido` varchar(30) DEFAULT NULL COMMENT 'Segundo apellido del cliente correspondiente',
  `cliente_id` int(11) NOT NULL COMMENT 'ID del cliente web dentro de la tabla de clientes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `web`
--

INSERT INTO `web` (`tipo`, `numero`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `cliente_id`) VALUES
('Tipo1', 12345678, 'Nombre1', 'SegundoNombre1', 'Apellido1', 'SegundoApellido1', 1),
('Tipo2', 23456789, 'Nombre2', 'SegundoNombre2', 'Apellido2', 'SegundoApellido2', 2),
('Tipo3', 34567890, 'Nombre3', 'SegundoNombre3', 'Apellido3', 'SegundoApellido3', 3),
('Tipo1', 45678901, 'Nombre4', 'SegundoNombre4', 'Apellido4', 'SegundoApellido4', 4),
('Tipo2', 56789012, 'Nombre5', 'SegundoNombre5', 'Apellido5', 'SegundoApellido5', 5),
('Tipo3', 67890123, 'Nombre6', 'SegundoNombre6', 'Apellido6', 'SegundoApellido6', 6),
('Tipo1', 78901234, 'Nombre7', 'SegundoNombre7', 'Apellido7', 'SegundoApellido7', 7),
('Tipo2', 89012345, 'Nombre8', 'SegundoNombre8', 'Apellido8', 'SegundoApellido8', 8),
('Tipo3', 90123456, 'Nombre9', 'SegundoNombre9', 'Apellido9', 'SegundoApellido9', 9),
('Tipo1', 1234567, 'Nombre10', 'SegundoNombre10', 'Apellido10', 'SegundoApellido10', 10),
('CI', 5088325, 'maxi', NULL, 'da silva', NULL, 30);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `actividad`
--
ALTER TABLE `actividad`
  ADD PRIMARY KEY (`usuario_ci`,`id`),
  ADD KEY `usuario_ci` (`usuario_ci`);

--
-- Indexes for table `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `cliente_telefono`
--
ALTER TABLE `cliente_telefono`
  ADD PRIMARY KEY (`cliente_id`,`telefono`);

--
-- Indexes for table `conforma`
--
ALTER TABLE `conforma`
  ADD PRIMARY KEY (`menu_id`,`vianda_id`),
  ADD KEY `menu_id` (`menu_id`),
  ADD KEY `vianda_id` (`vianda_id`);

--
-- Indexes for table `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`cliente_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indexes for table `favorito`
--
ALTER TABLE `favorito`
  ADD PRIMARY KEY (`menu_id`,`web_id`),
  ADD KEY `menu_id` (`menu_id`),
  ADD KEY `web_id` (`web_id`);

--
-- Indexes for table `inicia`
--
ALTER TABLE `inicia`
  ADD PRIMARY KEY (`cliente_id`,`sesion_token`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `sesion_token` (`sesion_token`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pide`
--
ALTER TABLE `pide`
  ADD PRIMARY KEY (`menu_id`,`vianda_id`,`cliente_id`),
  ADD KEY `menu_id` (`menu_id`),
  ADD KEY `vianda_id` (`vianda_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indexes for table `sesion`
--
ALTER TABLE `sesion`
  ADD PRIMARY KEY (`token`);

--
-- Indexes for table `tarjeta`
--
ALTER TABLE `tarjeta`
  ADD PRIMARY KEY (`numero`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indexes for table `tiene`
--
ALTER TABLE `tiene`
  ADD PRIMARY KEY (`usuario_ci`,`permisos_id`),
  ADD KEY `permisos_id` (`permisos_id`),
  ADD KEY `usuario_ci` (`usuario_ci`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`ci`);

--
-- Indexes for table `vianda`
--
ALTER TABLE `vianda`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vianda_dieta`
--
ALTER TABLE `vianda_dieta`
  ADD PRIMARY KEY (`vianda_id`,`dieta`),
  ADD KEY `vianda_id` (`vianda_id`);

--
-- Indexes for table `web`
--
ALTER TABLE `web`
  ADD PRIMARY KEY (`cliente_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID único del cliente el cual es autogenerado', AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID único del menú el cual es autogenerado', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID único del permiso que es generado automáticamente';

--
-- AUTO_INCREMENT for table `vianda`
--
ALTER TABLE `vianda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID único de la vianda que se crea automáticamente', AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `actividad`
--
ALTER TABLE `actividad`
  ADD CONSTRAINT `actividad_ibfk_1` FOREIGN KEY (`usuario_ci`) REFERENCES `usuario` (`ci`);

--
-- Constraints for table `cliente_telefono`
--
ALTER TABLE `cliente_telefono`
  ADD CONSTRAINT `cliente_telefono_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `conforma`
--
ALTER TABLE `conforma`
  ADD CONSTRAINT `conforma_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`),
  ADD CONSTRAINT `conforma_ibfk_2` FOREIGN KEY (`vianda_id`) REFERENCES `vianda` (`id`);

--
-- Constraints for table `empresa`
--
ALTER TABLE `empresa`
  ADD CONSTRAINT `empresa_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);

--
-- Constraints for table `favorito`
--
ALTER TABLE `favorito`
  ADD CONSTRAINT `favorito_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `conforma` (`menu_id`),
  ADD CONSTRAINT `favorito_ibfk_2` FOREIGN KEY (`web_id`) REFERENCES `web` (`cliente_id`);

--
-- Constraints for table `inicia`
--
ALTER TABLE `inicia`
  ADD CONSTRAINT `inicia_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`),
  ADD CONSTRAINT `inicia_ibfk_2` FOREIGN KEY (`sesion_token`) REFERENCES `sesion` (`token`);

--
-- Constraints for table `pide`
--
ALTER TABLE `pide`
  ADD CONSTRAINT `pide_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `conforma` (`menu_id`),
  ADD CONSTRAINT `pide_ibfk_2` FOREIGN KEY (`vianda_id`) REFERENCES `conforma` (`vianda_id`),
  ADD CONSTRAINT `pide_ibfk_3` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);

--
-- Constraints for table `tarjeta`
--
ALTER TABLE `tarjeta`
  ADD CONSTRAINT `tarjeta_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);

--
-- Constraints for table `tiene`
--
ALTER TABLE `tiene`
  ADD CONSTRAINT `tiene_ibfk_1` FOREIGN KEY (`usuario_ci`) REFERENCES `usuario` (`ci`),
  ADD CONSTRAINT `tiene_ibfk_2` FOREIGN KEY (`permisos_id`) REFERENCES `permisos` (`id`);

--
-- Constraints for table `vianda_dieta`
--
ALTER TABLE `vianda_dieta`
  ADD CONSTRAINT `vianda_dieta_ibfk_1` FOREIGN KEY (`vianda_id`) REFERENCES `vianda` (`id`);

--
-- Constraints for table `web`
--
ALTER TABLE `web`
  ADD CONSTRAINT `web_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
