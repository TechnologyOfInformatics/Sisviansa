INSERT INTO Cliente (`ID`, `Contrasenia`, `Autorizacion`, `Numero`, `Calle`, `Barrio`, `Ciudad`, `Email`) VALUES
(1, 'contrasenia1', 'Autorizado', '4', 'calle1', 'barrio1', 'ciudad1', 'email1@gmail.com'),
(2, 'contrasenia9', 'En espera', '12', 'calle9', 'barrio9', 'ciudad9', 'email9@hotmail.com'),
(3, 'contrasenia17', 'No autorizado', '20', 'calle17', 'barrio17', 'ciudad17', 'email17@gmail.com');

INSERT INTO Tarjeta (`Numero`, `Fecha_de_vencimiento`, `Nombre_de_titular`, `Cliente_ID`) VALUES
('112312331123121233123', '2023-09-30', 'Titular Tarjeta 1', 1),
('686868678678678678678', '2023-09-30', 'Titular Tarjeta 2', 2),
('17171717171717171717', '2023-09-30', 'Titular Tarjeta 3', 3);

INSERT INTO Cliente_Telefono (`Cliente_ID`, `Telefono`) VALUES
(1, '09123456'),
(2, '09123456'),
(3, '09123456');

INSERT INTO Empresa (`Cliente_ID`, `RUT`, `Nombre`) VALUES
(1, 'RUT_empresa1', 'Nombre Empresa 1'),
(2, 'RUT_empresa2', 'Nombre Empresa 2'),
(3, 'RUT_empresa3', 'Nombre Empresa 3');

INSERT INTO Web (`Cliente_ID`, `Tipo`, `Numero`, `Primer_nombre`, `Segundo_nombre`, `Primer_apellido`, `Segundo_apellido`) VALUES
(1, 'Cedula', 12345678, 'Primer Nombre1', 'Segundo Nombre1', 'Primer Apellido1', 'Segundo Apellido1'),
(2, 'Pasaporte', 67890123, 'Primer Nombre2', 'Segundo Nombre2', 'Primer Apellido2', 'Segundo Apellido2'),
(3, 'Visa', 87654321, 'Primer Nombre3', 'Segundo Nombre3', 'Primer Apellido3', 'Segundo Apellido3');

INSERT INTO Sesion (`Token`, `Inicio_de_sesion`, `Ultima_sesion`, `Final_de_sesion`, `Estado`) VALUES
('x2312x23d2d2', '2023-09-07 00:00:00', '2023-09-08 00:00:00', '2023-09-09 00:00:00', 'Activa'),
('23ec23d23r4t', '2023-09-07 00:00:00', '2023-09-08 00:00:00', '2023-09-09 00:00:00', 'Activa'),
('12312334f234', '2023-09-10 00:00:00', '2023-09-11 00:00:00', '2023-09-12 00:00:00', 'Activa');

INSERT INTO Menu (`ID`, `Nombre`, `Calorias`, `Frecuencia`, `Descripcion`, `Precio`, `Estado`) VALUES
(1, 'Menu1', 500, 1, 'Descripcion Menu 1', 10.00, 'Solicitado'),
(2, 'Menu2', 600, 7, 'Descripcion Menu 2', 15.00, 'Confirmado'),
(3, 'Menu3', 700, 15, 'Descripcion Menu 3', 20.00, 'Enviado');

INSERT INTO Vianda (`ID`, `Nombre`, `Tiempo_de_coccion`, `Productos`, `Stock`, `Calorias`) VALUES
(1, 'Vianda1', 30, 'Productos1', 100, 200),
(2, 'Vianda2', 40, 'Productos2', 200, 300),
(3, 'Vianda3', 50, 'Productos3', 300, 400),
(4, 'Vianda4', 30, 'Productos1', 100, 200),
(5, 'Vianda5', 40, 'Productos2', 200, 300),
(6, 'Vianda6', 50, 'Productos3', 300, 400);

INSERT INTO Vianda_Dieta (`Vianda_ID`, `Dieta`) VALUES
(1, 'Vegetariano'),
(2, 'Vegano'),
(3, 'Sin Gluten'),
(1, 'Sin Gluten'),
(2, 'Vegetariano'),
(3, 'Vegano'),
(4, 'Sin Gluten'),
(5, 'Sin Gluten'),
(6, 'Vegano'),
(4, 'Vegano'),
(5, 'Vegano'),
(6, 'Vegetariano');

INSERT INTO Stock (`Menu_ID`, `Minimo`, `Maximo`, `Actual`) VALUES
(1, 5, 10, 8),
(2, 5, 10, 10),
(3, 5, 10, 5);

INSERT INTO Inicia (`Sesion_token`, `Cliente_ID`) VALUES
('x2312x23d2d2', 1),
('23ec23d23r4t', 2),
('12312334f234', 3);

TRUNCATE TABLE Favorito;
INSERT INTO Favorito (`Menu_ID`, `Web_ID`) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Conforma (`Menu_ID`, `Vianda_ID`, `Demora_total`) VALUES
(1, 1, 60),
(2, 2, 75),
(3, 3, 90),
(1, 4, 60),
(2, 5, 75),
(3, 6, 90),
(1, 5, 60),
(2, 6, 75),
(3, 4, 90),
(1, 3, 60),
(2, 1, 75),
(3, 2, 90);

INSERT INTO Pide (`Menu_ID`, `Vianda_ID`, `Cliente_ID`, `Fecha_pedido`, `Numero_de_pedido`) VALUES
(1, 1, 1, '2023-09-07', 1),
(2, 2, 2, '2023-09-08', 2),
(3, 3, 3, '2023-09-09', 3);

INSERT INTO Paquete (`ID`, `Fecha_vencimiento`, `Fecha_de_creacion`, `Estado`) VALUES
(1, '2023-10-01', '2023-09-07', 'Solicitada'),
(2, '2023-10-02', '2023-09-08', 'En stock'),
(3, '2023-10-03', '2023-09-09', 'En producción');

INSERT INTO Genera (`Paquete_ID`, `Menu_ID`, `Vianda_ID`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

INSERT INTO Recibe (`Paquete_ID`, `Cliente_ID`) VALUES
(1, 1),
(2, 2),
(3, 3);