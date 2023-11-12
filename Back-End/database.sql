SET time_zone = '-3:00';
DROP DATABASE IF EXISTS sisviansa_techin_v1;
-- Elimina la base de datos sisviansa_techin_v1 si ya existe
CREATE DATABASE IF NOT EXISTS sisviansa_techin_v1;
-- Crea la base de datos sisviansa_techin_v1
USE sisviansa_techin_v1;
-- Utiliza la base de datos sisviansa_techin_v1
-- Creación de la tabla Cliente
CREATE TABLE Cliente (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'ID único de cliente el cual es autogenerado',
  Contrasenia VARCHAR(100) NOT NULL COMMENT 'Contraseña de la cuenta correspondiente al cliente',
  Autorizacion ENUM('Autorizado', 'En espera', 'No autorizado') NOT NULL COMMENT 'Estado del pedido de autorizacion del administrador',
  Email VARCHAR(50) NOT NULL COMMENT 'ID único correspondiente al cliente'
);
-- Creación de la tabla Tarjeta
CREATE TABLE Tarjeta (
  Numero VARCHAR(30) NOT NULL COMMENT 'Número de la tarjeta de crédito a usarse',
  Digitos_verificadores VARCHAR(4) NOT NULL COMMENT 'Últimos 4 digitos numeros de la tarjeta de crédito a usarse',
  Fecha_de_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta de crédito a usarse',
  Nombre_de_titular VARCHAR(30) NOT NULL COMMENT 'Nombre del titular que figura en la tarjeta de crédito correspondiente',
  Cliente_ID INT(11) COMMENT 'ID que pertenece a un cliente, el poseedor de esta tarjeta de crédito',
  PRIMARY KEY(Cliente_ID, Numero),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Cliente_telefono
CREATE TABLE Cliente_telefono (
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente dueño poseedor de teléfono',
  Telefono VARCHAR(15) NOT NULL COMMENT 'Teléfono correspondiente al cliente',
  PRIMARY KEY(Cliente_ID, Telefono),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Empresa
CREATE TABLE Empresa (
  Cliente_ID INT(11) PRIMARY KEY COMMENT 'ID de la empresa dentro de la tabla de clientes',
  RUT VARCHAR(12) NOT NULL COMMENT 'RUT de la empresa',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la empresa oficial',
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Web
CREATE TABLE Web (
  Cliente_ID INT(11) PRIMARY KEY COMMENT 'ID del cliente web dentro de la tabla de clientes',
  Documento_tipo VARCHAR(20) NOT NULL COMMENT 'Tipo de documento de identificacion del cliente web',
  Documento_numero INT(11) NOT NULL COMMENT 'Numero correspondiente al tipo de documento del cliente web',
  Primer_nombre VARCHAR(30) NOT NULL COMMENT 'Primer nombre del cliente correspondiente',
  Segundo_nombre VARCHAR(30) DEFAULT NULL COMMENT 'Segundo nombre del cliente correspondiente',
  Primer_apellido VARCHAR(30) NOT NULL COMMENT 'Primer apellido del cliente correspondiente',
  Segundo_apellido VARCHAR(30) DEFAULT NULL COMMENT 'Segundo apellido del cliente correspondiente',
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Sesion
CREATE TABLE Sesion (
  Token VARCHAR(15) PRIMARY KEY COMMENT 'Código único conocido como token el cual se usa para identificar una sesión',
  Inicio_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora en la cual se inicio la sesión',
  Ultima_sesion DATETIME NOT NULL COMMENT 'Fecha y hora del último inicio de sesión',
  Final_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora donde la sesión se terminará sesión',
  Estado ENUM('Activa', 'Finalizada') NOT NULL COMMENT 'Estado de la sesión a la que se hace referencia'
);
-- Creación de la tabla Menu
CREATE TABLE Menu (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del menú el cual es autogenerado',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre del menú que hace referencia a las viandas que lo contienen',
  Frecuencia INT(11) COMMENT 'Frecuencia con la que el menu se entregue el menú',
  Descripcion TEXT COMMENT 'La descripcion del menu',
  Categoria ENUM('Estandar', 'Personalizado', 'Descartado') NOT NULL COMMENT 'La categoria a la que pertenece el menu, donde puede ser creado por un cliente, el sistema o ser un menu descartado'
);
-- Creación de la tabla Vianda
CREATE TABLE Vianda (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la vianda que se crea automáticamente',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la vianda, hace referencia a la comida que tiene dentro',
  Tiempo_de_coccion INT(11) COMMENT 'Su tiempo de cocción estimado en minutos',
  Productos VARCHAR(150) NOT NULL COMMENT 'Productos que componen la vianda',
  Calorias INT(11) NOT NULL COMMENT 'Calorías totales correspondientes a la vianda',
  Precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio propio de la vianda'
);
-- Creacion de la tabla Pedido
CREATE TABLE Pedido(
  ID INT(11) AUTO_INCREMENT COMMENT 'Número del pedido correspondiente',
  Fecha_del_pedido DATETIME NOT NULL COMMENT 'Fecha del pedido',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha efectuado el pedido',
  Direccion VARCHAR(8) NOT NULL COMMENT "Direccion de la persona, ya sea el numero de puerta, o el solar",
  Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
  Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
  Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
  PRIMARY KEY(ID, Cliente_ID),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Paquete
CREATE TABLE Paquete (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del paquete el cual se crea automáticamente',
  Fecha_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento del paquete'
);
-- Creación de la tabla Vianda_Dieta
CREATE TABLE Vianda_Dieta (
  Vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda que tiene ésta dieta',
  Dieta VARCHAR(100) NOT NULL COMMENT 'Nombre de la dieta, el cual normalmente hace alusión a un conjunto de comidas que tienen una misma cualidad',
  PRIMARY KEY(Vianda_ID, Dieta),
  FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID)
);
-- Creación de la tabla Stock
CREATE TABLE Stock (
  Menu_ID INT(11) COMMENT 'ID del menu en stock',
  Minimo INT(11) COMMENT 'Stock mínimo de cajas',
  Maximo INT(11) COMMENT 'Stock máximo de cajas',
  Actual INT(11) COMMENT 'Stock actual de cajas',
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID)
);
-- Creación de la tabla Inicia
CREATE TABLE Inicia (
  Sesion_token VARCHAR(15) NOT NULL COMMENT 'Token correspondiente a la sesión',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que inició la sesión',
  FOREIGN KEY (Sesion_token) REFERENCES Sesion(Token),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
-- Creación de la tabla Favorito
CREATE TABLE Favorito (
  Menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente al favorito',
  Web_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha marcado como favorito el menú',
  PRIMARY KEY(Menu_ID, Web_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Web_ID) REFERENCES Web(Cliente_ID)
);
-- Creación de la tabla Conforma
CREATE TABLE Conforma (
  Menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente a la caja',
  Vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda correspondiente a la caja',
  PRIMARY KEY(Menu_ID, Vianda_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID)
);
-- Creación de la tabla Recibe
CREATE TABLE Recibe (
  Paquete_ID INT(11) PRIMARY KEY NOT NULL COMMENT 'ID del paquete que recibira el cliente',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que recibe el paquete',
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
CREATE TABLE Direccion (
  ID INT(11) NOT NULL COMMENT "El ID unico de la direccion correspondiente",
  Cliente_ID INT(11) NOT NULL COMMENT "ID unico del cliente",
  Direccion VARCHAR(8) NOT NULL COMMENT "Direccion de la persona, ya sea el numero de puerta, o el solar",
  Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
  Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
  Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
  Predeterminado BOOLEAN NOT NULL COMMENT "Determina si la vianda correspondiente es la predeterminada",
  PRIMARY KEY(Cliente_ID, ID),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);
CREATE TABLE Compone(
  Pedido_ID INT(11) NOT NULL COMMENT 'ID del pedido correspondiente al menú',
  Menu_ID INT(11) NOT NULL COMMENT 'ID del menú que está en el pedido',
  Cantidad INT(11) NOT NULL COMMENT 'Cantidad de veces que se compro éste menu en éste pedido',
  PRIMARY KEY(Pedido_ID, Menu_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID)
);
CREATE TABLE Estado (
  ID INT(11) PRIMARY KEY AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente a un paquete o pedido',
  Estado ENUM(
    'Solicitado',
    'Entregado',
    'En stock',
    'En produccion',
    'Envasado',
    'Devuelto',
    'Desechado',
    'Confirmado',
    'En camino',
    'Rechazado'
  ) NOT NULL COMMENT "Estado en si del paquete o pedido" -- Los estados de Paquete son desde En Stock hasta Desechado, y desde Confirmado hasta Rechazado es de Pedido, se comparte "Solicitado" y "Entregado"
);
CREATE TABLE Paquete_esta (
  Estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al paquete ',
  Paquete_ID INT(11) NOT NULL COMMENT "ID del paquete",
  Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del paquete inicio",
  Final_del_estado DATETIME COMMENT "Fecha en donde el estado del paquete finalizó",
  PRIMARY KEY(Estado_ID, Paquete_ID),
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
  FOREIGN KEY (Estado_ID) REFERENCES Estado(ID)
);
CREATE TABLE Pedido_esta (
  Estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al pedido',
  Pedido_ID INT(11) NOT NULL COMMENT "ID del pedido",
  Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del pedido inicio",
  Final_del_estado DATETIME COMMENT "Fecha en donde el estado del pedido finalizó",
  PRIMARY KEY(Estado_ID, Pedido_ID),
  FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID),
  FOREIGN KEY (Estado_ID) REFERENCES Estado(ID)
);
CREATE TABLE Asigna(
  Paquete_ID INT(11) PRIMARY KEY COMMENT "ID correspondiente al paquete",
  Pedido_ID INT(11) NOT NULL COMMENT "ID correspondiente al pedido",
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
  FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID)
);
CREATE TABLE Genera(
  Menu_ID INT(11) NOT NULL COMMENT 'Menu que representa el paquete',
  Paquete_ID INT(11) NOT NULL COMMENT 'Paquete que consta del menu',
  Fecha_de_creacion DATE NOT NULL COMMENT 'Fecha de la creacion del paquete en si',
  PRIMARY KEY(Menu_ID, Paquete_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID)
);
-- Inserciones para la tabla Cliente
INSERT INTO Cliente (`Contrasenia`, `Autorizacion`, `Email`)
VALUES ('clave123', 'Autorizado', 'cliente1@example.com'),
  (
    'password456',
    'En espera',
    'cliente2@example.com'
  ),
  (
    'securepass',
    'No autorizado',
    'cliente3@example.com'
  );
-- Inserciones para la tabla Tarjeta
INSERT INTO Tarjeta (
    `Numero`,
    `Digitos_verificadores`,
    `Fecha_de_vencimiento`,
    `Nombre_de_titular`,
    `Cliente_ID`
  )
VALUES (
    '1234567890123456',
    '7890',
    '2025-12-31',
    'Juan Pérez',
    1
  ),
  (
    '9876543210987654',
    '4321',
    '2024-10-31',
    'María González',
    2
  ),
  (
    '1111222233334444',
    '5678',
    '2023-08-31',
    'Carlos Rodríguez',
    3
  );
-- Inserciones para la tabla Cliente_telefono
INSERT INTO Cliente_telefono (`Cliente_ID`, `Telefono`)
VALUES (1, '+54123456789'),
  (2, '+54987654321'),
  (3, '+55011223344');
-- Inserciones para la tabla Empresa
INSERT INTO Empresa (`Cliente_ID`, `RUT`, `Nombre`)
VALUES (1, '12345678901', 'Empresa A'),
  (3, '98765432109', 'Empresa B');
-- Inserciones para la tabla Web
INSERT INTO Web (
    `Cliente_ID`,
    `Documento_tipo`,
    `Documento_numero`,
    `Primer_nombre`,
    `Segundo_nombre`,
    `Primer_apellido`,
    `Segundo_apellido`
  )
VALUES (
    1,
    'DNI',
    12345678,
    'Juan',
    'Carlos',
    'Gómez',
    'Pérez'
  ),
  (
    2,
    'CI',
    8765432,
    'María',
    NULL,
    'López',
    'González'
  ),
  (
    3,
    'DNI',
    11223344,
    'Carlos',
    NULL,
    'Rodríguez',
    NULL
  );
-- Inserciones para la tabla Sesion
INSERT INTO Sesion (
    `Token`,
    `Inicio_de_sesion`,
    `Ultima_sesion`,
    `Final_de_sesion`,
    `Estado`
  )
VALUES (
    'abc123xyz456789',
    '2023-09-30 10:00:00',
    '2023-09-30 15:30:00',
    '2023-09-30 17:00:00',
    'Activa'
  ),
  (
    'def456uvw789012',
    '2023-09-30 12:30:00',
    '2023-09-30 16:45:00',
    '2023-09-30 18:30:00',
    'Finalizada'
  ),
  (
    'ghi789rst012345',
    '2023-09-30 14:45:00',
    '2023-09-30 18:00:00',
    '2023-09-30 20:30:00',
    'Activa'
  );
-- Inserciones para la tabla Menu
INSERT INTO Menu (
    `Nombre`,
    `Frecuencia`,
    `Descripcion`,
    `Categoria`
  )
VALUES (
    'Menu Clásico',
    7,
    'Selección de platos tradicionales',
    'Estandar'
  ),
  (
    'Menu Fitness',
    14,
    'Platos saludables y bajos en calorías',
    'Personalizado'
  ),
  (
    'Menu Vegano',
    10,
    'Completamente basado en ingredientes veganos',
    'Estandar'
  );
-- Inserciones para la tabla Vianda
INSERT INTO Vianda (
    `Nombre`,
    `Tiempo_de_coccion`,
    `Productos`,
    `Calorias`,
    `Precio`
  )
VALUES (
    'Lomo a la pimienta',
    30,
    'Lomo, Pimienta, Sal',
    450,
    25.5
  ),
  (
    'Ensalada de quinoa',
    15,
    'Quinoa, Tomate, Pepino',
    200,
    15.8
  ),
  (
    'Tofu stir-fry',
    20,
    'Tofu, Verduras, Salsa de soja',
    300,
    18.2
  ),
  (
    'Guiso',
    20,
    'Un guiso de carne estofado',
    550,
    15
  );
-- Inserciones para la tabla Paquete
INSERT INTO Paquete (`Fecha_vencimiento`)
VALUES ('2023-10-15'),
  ('2023-11-05'),
  ('2023-12-01');
-- Inserciones para la tabla Vianda_Dieta
INSERT INTO Vianda_Dieta (`Vianda_ID`, `Dieta`)
VALUES (1, 'Vegetariana'),
  (2, 'Vegetariana'),
  (2, 'Vegana'),
  (3, 'Sin gluten');
-- Inserciones para la tabla Stock
INSERT INTO Stock (`Menu_ID`, `Minimo`, `Maximo`, `Actual`)
VALUES (1, 5, 20, 15),
  (2, 8, 25, 12),
  (3, 10, 30, 18);
-- Inserciones para la tabla Inicia
INSERT INTO Inicia (`Sesion_token`, `Cliente_ID`)
VALUES ('abc123xyz456789', 1),
  ('def456uvw789012', 2),
  ('ghi789rst012345', 3);
-- Inserciones para la tabla Favorito
INSERT INTO Favorito (`Menu_ID`, `Web_ID`)
VALUES (1, 1),
  (2, 2),
  (3, 3);
-- Inserciones para la tabla Conforma
INSERT INTO Conforma (`Menu_ID`, `Vianda_ID`)
VALUES (1, 1),
  (1, 2),
  (2, 2),
  (2, 3),
  (3, 1),
  (3, 3);
-- Inserciones para la tabla Recibe
INSERT INTO Recibe (`Paquete_ID`, `Cliente_ID`)
VALUES (1, 1),
  (2, 2),
  (3, 3);
-- Inserciones para la tabla Estado
INSERT INTO Estado (`Estado`)
VALUES ('Solicitado'),
  ('Entregado'),
  ('En stock'),
  ('En produccion'),
  ('Envasado'),
  ('Devuelto'),
  ('Desechado'),
  ('Confirmado'),
  ('En camino'),
  ('Rechazado');
-- Inserciones para la tabla Paquete_esta
INSERT INTO Paquete_esta (
    `Estado_ID`,
    `Paquete_ID`,
    `Inicio_del_estado`,
    `Final_del_estado`
  )
VALUES (
    1,
    1,
    '2023-09-30 12:00:00',
    '2023-09-30 15:00:00'
  ),
  (
    4,
    1,
    '2023-09-30 12:00:00',
    '2023-09-30 15:00:00'
  ),
  (
    2,
    1,
    '2023-09-30 15:00:00',
    '2023-09-30 16:30:00'
  ),
  (
    3,
    2,
    '2023-09-30 10:00:00',
    '2023-09-30 13:00:00'
  ),
  (
    4,
    2,
    '2023-09-30 13:00:00',
    '2023-09-30 15:30:00'
  ),
  (
    5,
    3,
    '2023-09-30 14:00:00',
    '2023-09-30 16:00:00'
  ),
  (
    6,
    3,
    '2023-09-30 16:00:00',
    '2023-09-30 18:30:00'
  );
-- Inserciones adicionales para la tabla Cliente
INSERT INTO Cliente (`Contrasenia`, `Autorizacion`, `Email`)
VALUES ('pass123', 'Autorizado', 'cliente4@example.com'),
  (
    'securepass567',
    'En espera',
    'cliente5@example.com'
  ),
  (
    'mypassword',
    'No autorizado',
    'cliente6@example.com'
  ),
  (
    'strongpass789',
    'Autorizado',
    'cliente7@example.com'
  ),
  ('pass456', 'En espera', 'cliente8@example.com'),
  (
    'password890',
    'No autorizado',
    'cliente9@example.com'
  ),
  (
    'securepass123',
    'Autorizado',
    'cliente10@example.com'
  ),
  ('pass789', 'En espera', 'cliente11@example.com'),
  (
    'mypass123',
    'No autorizado',
    'cliente12@example.com'
  ),
  (
    'strongpassword',
    'Autorizado',
    'cliente13@example.com'
  ),
  ('pass890', 'En espera', 'cliente14@example.com'),
  (
    'securepassword',
    'No autorizado',
    'cliente15@example.com'
  ),
  ('pass567', 'Autorizado', 'cliente16@example.com'),
  (
    'securepass890',
    'En espera',
    'cliente17@example.com'
  ),
  (
    'mypassword567',
    'No autorizado',
    'cliente18@example.com'
  ),
  (
    'pass890abc',
    'Autorizado',
    'cliente19@example.com'
  ),
  (
    'strongpass567',
    'En espera',
    'cliente20@example.com'
  );
-- Inserciones adicionales para la tabla Cliente_telefono
INSERT INTO Cliente_telefono (`Cliente_ID`, `Telefono`)
VALUES (4, '+554433221100'),
  (5, '+554433221122'),
  (6, '+554433221133'),
  (7, '+554433221144'),
  (8, '+554433221155'),
  (9, '+554433221166'),
  (10, '+554433221177'),
  (11, '+554433221188'),
  (12, '+554433221199'),
  (13, '+554433221200'),
  (14, '+554433221211'),
  (15, '+554433221222'),
  (16, '+554433221233'),
  (17, '+554433221244'),
  (18, '+554433221255'),
  (19, '+554433221266'),
  (20, '+554433221277');
-- Inserciones adicionales para la tabla Empresa
INSERT INTO Empresa (`Cliente_ID`, `RUT`, `Nombre`)
VALUES (4, '1122334455', 'Empresa C'),
  (6, '9988776655', 'Empresa D'),
  (8, '6677889900', 'Empresa E'),
  (10, '5544332211', 'Empresa F'),
  (12, '4455667788', 'Empresa G'),
  (14, '2233445566', 'Empresa H'),
  (16, '3322114455', 'Empresa I'),
  (18, '5566778899', 'Empresa J'),
  (20, '7788990011', 'Empresa K');
-- Inserciones adicionales para la tabla Web
INSERT INTO Web (
    `Cliente_ID`,
    `Documento_tipo`,
    `Documento_numero`,
    `Primer_nombre`,
    `Segundo_nombre`,
    `Primer_apellido`,
    `Segundo_apellido`
  )
VALUES (
    4,
    'DNI',
    87654321,
    'Pablo',
    'Andrés',
    'Fernández',
    'López'
  ),
  (
    5,
    'CI',
    54321678,
    'Valentina',
    NULL,
    'Gutierrez',
    'Mendoza'
  ),
  (
    6,
    'DNI',
    98765432,
    'Laura',
    NULL,
    'Díaz',
    'Rodríguez'
  ),
  (
    7,
    'CI',
    12345678,
    'Gustavo',
    'Alejandro',
    'Martínez',
    'Suárez'
  ),
  (
    8,
    'DNI',
    45678901,
    'Camila',
    NULL,
    'Ramírez',
    'Pérez'
  ),
  (
    9,
    'CI',
    23456789,
    'Joaquín',
    NULL,
    'García',
    'Gómez'
  ),
  (
    10,
    'DNI',
    76543210,
    'Catalina',
    NULL,
    'Fernández',
    'López'
  ),
  (
    11,
    'CI',
    32109876,
    'Diego',
    NULL,
    'Díaz',
    'Rodríguez'
  ),
  (
    12,
    'DNI',
    54321098,
    'Ana',
    NULL,
    'Martínez',
    'Suárez'
  ),
  (
    13,
    'CI',
    78901234,
    'Fernando',
    NULL,
    'Ramírez',
    'Pérez'
  );
-- Inserciones adicionales para la tabla Direccion
INSERT INTO Direccion (
    `Cliente_ID`,
    `ID`,
    `Direccion`,
    `Calle`,
    `Barrio`,
    `Ciudad`,
    `Predeterminado`
  )
VALUES (
    1,
    1,
    '789',
    '18 de Julio',
    'Centro',
    'Montevideo',
    TRUE
  ),
  (
    2,
    1,
    '987',
    'Rambla Sur',
    'Pocitos',
    'Montevideo',
    TRUE
  ),
  (
    2,
    2,
    '654',
    'Ellauri',
    'Carrasco',
    'Montevideo',
    FALSE
  ),
  (
    3,
    1,
    '321',
    'Luis Alberto de Herrera',
    'Parque Rodó',
    'Montevideo',
    TRUE
  ),
  (
    3,
    2,
    '654',
    'Avenida Brasil',
    'Punta Carretas',
    'Montevideo',
    FALSE
  ),
  (
    3,
    3,
    '987',
    'Echevarriarza',
    'Villa Muñoz',
    'Montevideo',
    FALSE
  ),
  (
    4,
    1,
    '321',
    'Arenal Grande',
    'La Comercial',
    'Montevideo',
    TRUE
  ),
  (
    4,
    2,
    '654',
    'Cerrito',
    'Ciudad Vieja',
    'Montevideo',
    FALSE
  ),
  (
    4,
    3,
    '987',
    'Juan Paullier',
    'La Blanqueada',
    'Montevideo',
    FALSE
  ),
  (
    5,
    1,
    '321',
    'Santiago de Chile',
    'Malvín',
    'Montevideo',
    TRUE
  ),
  (
    5,
    2,
    '654',
    'Espinosa',
    'Paso de la Arena',
    'Montevideo',
    FALSE
  ),
  (
    5,
    3,
    '987',
    'Larravide',
    'Peñarol',
    'Montevideo',
    FALSE
  ),
  (
    6,
    1,
    '654',
    'Soriano',
    'Barrio Sur',
    'Montevideo',
    TRUE
  ),
  (
    6,
    2,
    '987',
    'Reconquista',
    'Ciudadela',
    'Montevideo',
    FALSE
  ),
  (
    7,
    1,
    '321',
    'Maldonado',
    'Palermo',
    'Montevideo',
    TRUE
  ),
  (
    7,
    2,
    '654',
    'Sarmiento',
    'Bella Vista',
    'Montevideo',
    FALSE
  ),
  (
    8,
    1,
    '987',
    'Yaguarón',
    'Jacinto Vera',
    'Montevideo',
    TRUE
  ),
  (
    8,
    2,
    '321',
    'Miguelete',
    'La Teja',
    'Montevideo',
    FALSE
  ),
  (
    9,
    1,
    '654',
    'Luis de la Torre',
    'Atahualpa',
    'Montevideo',
    TRUE
  ),
  (
    9,
    2,
    '987',
    'Tristan Narvaja',
    'La Figurita',
    'Montevideo',
    FALSE
  ),
  (
    10,
    1,
    '321',
    'Paraguay',
    'Paso Molino',
    'Montevideo',
    TRUE
  ),
  (
    10,
    2,
    '654',
    'Bulevar España',
    'Brazo Oriental',
    'Montevideo',
    FALSE
  ),
  (
    11,
    1,
    '987',
    'Colonia',
    'La Paloma',
    'Montevideo',
    TRUE
  ),
  (
    11,
    2,
    '321',
    'Tacuarembó',
    'Tres Cruces',
    'Montevideo',
    FALSE
  ),
  (
    12,
    1,
    '654',
    'Soriano',
    'Aires Puros',
    'Montevideo',
    TRUE
  ),
  (
    12,
    2,
    '987',
    'Echevarriarza',
    'Casavalle',
    'Montevideo',
    FALSE
  ),
  (
    13,
    1,
    '321',
    '8 de Octubre',
    'Sayago',
    'Montevideo',
    TRUE
  ),
  (
    13,
    2,
    '654',
    'Maldonado',
    'Manga',
    'Montevideo',
    FALSE
  ),
  (
    14,
    1,
    '987',
    'Miguelete',
    'Reducto',
    'Montevideo',
    TRUE
  ),
  (
    14,
    2,
    '321',
    'Gral. Flores',
    'Tres Ombúes',
    'Montevideo',
    FALSE
  ),
  (
    15,
    1,
    '654',
    'Ituzaingó',
    'Flor de Maroñas',
    'Montevideo',
    TRUE
  ),
  (
    15,
    2,
    '987',
    'San Martin',
    'Peñarol',
    'Montevideo',
    FALSE
  ),
  (
    16,
    1,
    '321',
    'Rambla Sur',
    'Buceo',
    'Montevideo',
    TRUE
  ),
  (
    16,
    2,
    '654',
    'Espinosa',
    'Paso Molino',
    'Montevideo',
    FALSE
  ),
  (
    17,
    1,
    '987',
    'Bulevar Artigas',
    'Cordón',
    'Montevideo',
    TRUE
  ),
  (
    17,
    2,
    '321',
    '18 de Julio',
    'Centro',
    'Montevideo',
    FALSE
  ),
  (
    18,
    1,
    '654',
    'Luis Alberto de Herrera',
    'Parque Rodó',
    'Montevideo',
    TRUE
  ),
  (
    18,
    2,
    '987',
    'José L. Terra',
    'La Teja',
    'Montevideo',
    FALSE
  ),
  (
    19,
    1,
    '321',
    'Yaguarón',
    'Jacinto Vera',
    'Montevideo',
    TRUE
  ),
  (
    19,
    2,
    '654',
    'Avenida Italia',
    'La Comercial',
    'Montevideo',
    FALSE
  ),
  (
    19,
    3,
    '987',
    'Rambla Sur',
    'Pocitos',
    'Montevideo',
    FALSE
  );
-- Inserciones adicionales para la tabla Pedido
INSERT INTO Pedido (
    `Fecha_del_pedido`,
    `Cliente_ID`,
    `Direccion`,
    `Calle`,
    `Barrio`,
    `Ciudad`
  )
VALUES (
    now(),
    1,
    '123',
    'Avenida Siempreverde',
    'Centro',
    'Ciudad A'
  ),
  (
    now(),
    2,
    '456',
    'Calle del Progreso',
    'Barrio Norte',
    'Ciudad B'
  ),
  (
    now(),
    3,
    '789',
    'Avenida de la Paz',
    'Villa Tranquila',
    'Ciudad C'
  ),
  (
    now(),
    4,
    '987',
    'Avenida del Sol',
    'Centro',
    'Ciudad D'
  ),
  (
    now(),
    5,
    '321',
    'Avenida del Oeste',
    'Villa Tranquila',
    'Ciudad E'
  ),
  (
    now(),
    6,
    '654',
    'Calle del Bosque',
    'Barrio Boscoso',
    'Ciudad F'
  ),
  (
    now(),
    7,
    '321',
    'Avenida del Río',
    'Villa Riberña',
    'Ciudad G'
  ),
  (
    '2023-09-30 16:30:00',
    8,
    '654',
    'Calle del Pueblo',
    'Barrio del Pueblo',
    'Ciudad H'
  ),
  (
    '2023-09-30 17:00:00',
    9,
    '321',
    'Avenida del Lago',
    'Villa Lago',
    'Ciudad I'
  ),
  (
    '2023-09-30 17:45:00',
    10,
    '654',
    'Calle de la Montaña',
    'Barrio Montañoso',
    'Ciudad J'
  ),
  (
    '2023-09-30 18:15:00',
    11,
    '321',
    'Avenida del Desierto',
    'Villa Desierto',
    'Ciudad K'
  ),
  (
    '2023-09-30 19:00:00',
    12,
    '654',
    'Calle de la Playa',
    'Barrio Playa',
    'Ciudad L'
  ),
  (
    '2023-09-30 20:30:00',
    13,
    '321',
    'Avenida del Viento',
    'Villa Ventosa',
    'Ciudad M'
  ),
  (
    '2023-09-30 21:00:00',
    14,
    '654',
    'Calle de la Nube',
    'Barrio Nuboso',
    'Ciudad N'
  ),
  (
    '2023-09-30 21:45:00',
    15,
    '321',
    'Avenida del Trueno',
    'Villa Tormenta',
    'Ciudad O'
  ),
  (
    '2023-09-30 22:15:00',
    16,
    '654',
    'Calle de la Neblina',
    'Barrio Neblinoso',
    'Ciudad P'
  ),
  (
    '2023-09-30 23:00:00',
    17,
    '321',
    'Avenida del Rayo',
    'Villa Relámpago',
    'Ciudad Q'
  ),
  (
    '2023-09-30 23:30:00',
    18,
    '654',
    'Calle de la Aurora',
    'Barrio Amanecer',
    'Ciudad R'
  ),
  (
    '2023-09-30 23:45:00',
    19,
    '321',
    'Avenida del Crepúsculo',
    'Villa Crepúsculo',
    'Ciudad S'
  ),
  (
    '2023-09-30 00:15:00',
    20,
    '654',
    'Calle de la Estrella',
    'Barrio Estelar',
    'Ciudad T'
  );
-- Inserciones para la tabla Pedido_esta
INSERT INTO Pedido_esta (
    `Estado_ID`,
    `Pedido_ID`,
    `Inicio_del_estado`,
    `Final_del_estado`
  )
VALUES -- 1
  (1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
  (
    8,
    1,
    DATE_ADD(NOW(), INTERVAL 2 DAY),
    DATE_ADD(NOW(), INTERVAL 3 DAY)
  ),
  (
    9,
    1,
    DATE_ADD(NOW(), INTERVAL 4 DAY),
    DATE_ADD(NOW(), INTERVAL 5 DAY)
  ),
  (
    2,
    1,
    DATE_ADD(NOW(), INTERVAL 6 DAY),
    DATE_ADD(NOW(), INTERVAL 7 DAY)
  ),
  -- 2
  (1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
  (
    10,
    2,
    DATE_ADD(NOW(), INTERVAL 2 DAY),
    DATE_ADD(NOW(), INTERVAL 3 DAY)
  ),
  -- 3
  (1, 3, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
  (
    10,
    3,
    DATE_ADD(NOW(), INTERVAL 2 DAY),
    DATE_ADD(NOW(), INTERVAL 3 DAY)
  ),
  -- 4
  (1, 4, NOW(), NULL),
  -- 5
  (1, 5, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
  (
    8,
    5,
    DATE_ADD(NOW(), INTERVAL 2 DAY),
    DATE_ADD(NOW(), INTERVAL 3 DAY)
  ),
  (
    9,
    5,
    DATE_ADD(NOW(), INTERVAL 4 DAY),
    NULL
  ),
  -- 6
  (1, 6, NOW(), NULL),
  -- 7
  (1, 7, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
  (8, 7, NOW(), NULL),
  (1, 8, NOW(), NULL),
  (1, 9, NOW(), NULL),
  (1, 10, NOW(), NULL),
  (1, 11, NOW(), NULL),
  (1, 12, NOW(), NULL),
  (1, 13, NOW(), NULL),
  (1, 14, NOW(), NULL),
  (1, 15, NOW(), NULL),
  (1, 16, NOW(), NULL),
  (1, 17, NOW(), NULL),
  (1, 18, NOW(), NULL),
  (1, 19, NOW(), NULL),
  (1, 20, NOW(), NULL);
-- Inserciones adicionales para la tabla Paquete
INSERT INTO Paquete (`Fecha_vencimiento`)
VALUES ('2023-10-15'),
  ('2023-10-18'),
  ('2023-10-20'),
  ('2023-10-22'),
  ('2023-10-25'),
  ('2023-10-28'),
  ('2023-10-30'),
  ('2023-11-02'),
  ('2023-11-05'),
  ('2023-11-08'),
  ('2023-11-10'),
  ('2023-11-12'),
  ('2023-11-15'),
  ('2023-11-18'),
  ('2023-11-20'),
  ('2023-11-22'),
  ('2023-11-25'),
  ('2023-11-28'),
  ('2023-11-30'),
  ('2023-12-02');
-- Inserciones para la tabla Compone
INSERT INTO Compone (`Pedido_ID`, `Menu_ID`, `Cantidad`)
VALUES (1, 1, 2),
  (2, 2, 1),
  (3, 3, 3),
  (4, 1, 2),
  (5, 2, 1),
  (6, 3, 3);
-- Inserciones adicionales para la tabla Asigna
INSERT INTO Asigna (`Paquete_ID`, `Pedido_ID`)
VALUES (1, 4),
  (2, 7),
  (3, 10),
  (4, 13),
  (5, 16),
  (6, 19),
  (7, 2),
  (8, 5),
  (9, 8),
  (10, 11),
  (11, 14),
  (12, 17),
  (13, 20),
  (14, 3),
  (15, 6),
  (16, 9),
  (17, 12),
  (18, 15),
  (19, 18),
  (20, 1);
INSERT INTO Genera (`Menu_ID`, `Paquete_ID`, `Fecha_de_creacion`)
VALUES (1, 1, '2023-09-30'),
  (2, 2, '2023-09-30'),
  (3, 3, '2023-09-30'),
  (1, 4, '2023-09-30'),
  (2, 5, '2023-09-30'),
  (1, 6, '2023-09-30'),
  (3, 7, '2023-09-30'),
  (2, 8, '2023-09-30'),
  (2, 9, '2023-09-30'),
  (3, 10, '2023-09-30'),
  (1, 11, '2023-09-30'),
  (2, 12, '2023-09-30'),
  (2, 13, '2023-09-30'),
  (1, 14, '2023-09-30'),
  (3, 15, '2023-09-30'),
  (3, 16, '2023-09-30'),
  (1, 17, '2023-09-30'),
  (2, 18, '2023-09-30'),
  (2, 19, '2023-09-30'),
  (3, 20, '2023-09-30');
/*
 SET
 time_zone = '-3:00';
 
 DROP DATABASE IF EXISTS sisviansa_techin_v1;
 
 -- Elimina la base de datos sisviansa_techin_v1 si ya existe
 CREATE DATABASE IF NOT EXISTS sisviansa_techin_v1;
 
 -- Crea la base de datos sisviansa_techin_v1
 USE sisviansa_techin_v1;
 
 -- Utiliza la base de datos sisviansa_techin_v1
 -- Creación de la tabla Cliente
 CREATE TABLE Cliente (
 ID INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'ID único de cliente el cual es autogenerado',
 Contrasenia VARCHAR(100) NOT NULL COMMENT 'Contraseña de la cuenta correspondiente al cliente',
 Autorizacion ENUM('Autorizado', 'En espera', 'No autorizado') NOT NULL COMMENT 'Estado del pedido de autorizacion del administrador',
 Email VARCHAR(50) NOT NULL COMMENT 'ID único correspondiente al cliente'
 );
 
 -- Creación de la tabla Tarjeta
 CREATE TABLE Tarjeta (
 Numero VARCHAR(30) NOT NULL COMMENT 'Número de la tarjeta de crédito a usarse',
 Digitos_verificadores VARCHAR(4) NOT NULL COMMENT 'Últimos 4 digitos numeros de la tarjeta de crédito a usarse',
 Fecha_de_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta de crédito a usarse',
 Nombre_de_titular VARCHAR(30) NOT NULL COMMENT 'Nombre del titular que figura en la tarjeta de crédito correspondiente',
 Cliente_ID INT(11) COMMENT 'ID que pertenece a un cliente, el poseedor de esta tarjeta de crédito',
 PRIMARY KEY(Cliente_ID,Numero),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Cliente_telefono
 CREATE TABLE Cliente_telefono (
 Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente dueño poseedor de teléfono',
 Telefono VARCHAR(15) NOT NULL COMMENT 'Teléfono correspondiente al cliente',
 PRIMARY KEY(Cliente_ID, Telefono),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Empresa
 CREATE TABLE Empresa (
 Cliente_ID INT(11) PRIMARY KEY COMMENT 'ID de la empresa dentro de la tabla de clientes',
 RUT VARCHAR(12) NOT NULL COMMENT 'RUT de la empresa',
 Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la empresa oficial',
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Web
 CREATE TABLE Web (
 Cliente_ID INT(11) PRIMARY KEY COMMENT 'ID del cliente web dentro de la tabla de clientes',
 Documento_tipo VARCHAR(20) NOT NULL COMMENT 'Tipo de documento de identificacion del cliente web',
 Documento_numero INT(11) NOT NULL COMMENT 'Numero correspondiente al tipo de documento del cliente web',
 Primer_nombre VARCHAR(30) NOT NULL COMMENT 'Primer nombre del cliente correspondiente',
 Segundo_nombre VARCHAR(30) DEFAULT NULL COMMENT 'Segundo nombre del cliente correspondiente',
 Primer_apellido VARCHAR(30) NOT NULL COMMENT 'Primer apellido del cliente correspondiente',
 Segundo_apellido VARCHAR(30) DEFAULT NULL COMMENT 'Segundo apellido del cliente correspondiente',
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Sesion
 CREATE TABLE Sesion (
 Token VARCHAR(15) PRIMARY KEY COMMENT 'Código único conocido como token el cual se usa para identificar una sesión',
 Inicio_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora en la cual se inicio la sesión',
 Ultima_sesion DATETIME NOT NULL COMMENT 'Fecha y hora del último inicio de sesión',
 Final_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora donde la sesión se terminará sesión',
 Estado ENUM('Activa', 'Finalizada') NOT NULL COMMENT 'Estado de la sesión a la que se hace referencia'
 );
 
 -- Creación de la tabla Menu
 CREATE TABLE Menu (
 ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del menú el cual es autogenerado',
 Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre del menú que hace referencia a las viandas que lo contienen',
 Frecuencia INT(11) COMMENT 'Frecuencia con la que el menu se entregue el menú',
 Descripcion TEXT COMMENT 'La descripcion del menu',
 Categoria ENUM('Estandar', 'Personalizado', 'Descartado') NOT NULL COMMENT 'La categoria a la que pertenece el menu, donde puede ser creado por un cliente, el sistema o ser un menu descartado'
 );
 
 -- Creación de la tabla Vianda
 CREATE TABLE Vianda (
 ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la vianda que se crea automáticamente',
 Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la vianda, hace referencia a la comida que tiene dentro',
 Tiempo_de_coccion INT(11) COMMENT 'Su tiempo de cocción estimado en minutos',
 Productos VARCHAR(150) NOT NULL COMMENT 'Productos que componen la vianda',
 Calorias INT(11) NOT NULL COMMENT 'Calorías totales correspondientes a la vianda',
 Precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio propio de la vianda'
 );
 
 -- Creacion de la tabla Pedido
 CREATE TABLE Pedido(
 ID INT(11) AUTO_INCREMENT COMMENT 'Número del pedido correspondiente',
 Fecha_del_pedido DATETIME NOT NULL COMMENT 'Fecha del pedido',
 Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha efectuado el pedido',
 Direccion VARCHAR(8) NOT NULL COMMENT "Direccion de la persona, ya sea el numero de puerta, o el solar",
 Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
 Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
 Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
 PRIMARY KEY(ID, Cliente_ID),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Paquete
 CREATE TABLE Paquete (
 ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del paquete el cual se crea automáticamente',
 Fecha_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento del paquete'
 );
 
 -- Creación de la tabla Vianda_Dieta
 CREATE TABLE Vianda_Dieta (
 Vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda que tiene ésta dieta',
 Dieta VARCHAR(100) NOT NULL COMMENT 'Nombre de la dieta, el cual normalmente hace alusión a un conjunto de comidas que tienen una misma cualidad',
 PRIMARY KEY(Vianda_ID, Dieta),
 FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID)
 );
 
 -- Creación de la tabla Stock
 CREATE TABLE Stock (
 Menu_ID INT(11) COMMENT 'ID del menu en stock',
 Minimo INT(11) COMMENT 'Stock mínimo de cajas',
 Maximo INT(11) COMMENT 'Stock máximo de cajas',
 Actual INT(11) COMMENT 'Stock actual de cajas',
 FOREIGN KEY (Menu_ID) REFERENCES Menu(ID)
 );
 
 -- Creación de la tabla Inicia
 CREATE TABLE Inicia (
 Sesion_token VARCHAR(15) NOT NULL COMMENT 'Token correspondiente a la sesión',
 Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que inició la sesión',
 FOREIGN KEY (Sesion_token) REFERENCES Sesion(Token),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 -- Creación de la tabla Favorito
 CREATE TABLE Favorito (
 Menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente al favorito',
 Web_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha marcado como favorito el menú',
 PRIMARY KEY(Menu_ID, Web_ID),
 FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
 FOREIGN KEY (Web_ID) REFERENCES Web(Cliente_ID)
 );
 
 -- Creación de la tabla Conforma
 CREATE TABLE Conforma (
 Menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente a la caja',
 Vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda correspondiente a la caja',
 PRIMARY KEY(Menu_ID, Vianda_ID),
 FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
 FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID)
 );
 
 -- Creación de la tabla Recibe
 CREATE TABLE Recibe (
 Paquete_ID INT(11) PRIMARY KEY NOT NULL COMMENT 'ID del paquete que recibira el cliente',
 Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que recibe el paquete',
 FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 CREATE TABLE Direccion (
 ID INT(11) NOT NULL COMMENT "El ID unico de la direccion correspondiente",
 Cliente_ID INT(11) NOT NULL COMMENT "ID unico del cliente",
 Direccion VARCHAR(8) NOT NULL COMMENT "Direccion de la persona, ya sea el numero de puerta, o el solar",
 Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
 Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
 Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
 Predeterminado BOOLEAN NOT NULL COMMENT "Determina si la vianda correspondiente es la predeterminada",
 PRIMARY KEY(Cliente_ID, ID),
 FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
 );
 
 CREATE TABLE Compone(
 Pedido_ID INT(11) NOT NULL COMMENT 'ID del pedido correspondiente al menú',
 Menu_ID INT(11) NOT NULL COMMENT 'ID del menú que está en el pedido',
 Cantidad INT(11) NOT NULL COMMENT 'Cantidad de veces que se compro éste menu en éste pedido',
 PRIMARY KEY(Pedido_ID, Menu_ID),
 FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
 FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID)
 );
 
 CREATE TABLE Estado (
 ID INT(11) PRIMARY KEY AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente a un paquete o pedido',
 Estado ENUM(
 'Solicitado',
 'Entregado',
 'En stock',
 'En produccion',
 'Envasado',
 'Devuelto',
 'Desechado',
 'Confirmado',
 'En camino',
 'Rechazado'
 ) NOT NULL COMMENT "Estado en si del paquete o pedido" -- Los estados de Paquete son desde En Stock hasta Desechado, y desde Confirmado hasta Rechazado es de Pedido, se comparte "Solicitado" y "Entregado"
 );
 
 CREATE TABLE Paquete_esta (
 Estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al paquete ',
 Paquete_ID INT(11) NOT NULL COMMENT "ID del paquete",
 Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del paquete inicio",
 Final_del_estado DATETIME COMMENT "Fecha en donde el estado del paquete finalizó",
 PRIMARY KEY(Estado_ID, Paquete_ID),
 FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
 FOREIGN KEY (Estado_ID) REFERENCES Estado(ID)
 );
 
 CREATE TABLE Pedido_esta (
 Estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al pedido',
 Pedido_ID INT(11) NOT NULL COMMENT "ID del pedido",
 Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del pedido inicio",
 Final_del_estado DATETIME COMMENT "Fecha en donde el estado del pedido finalizó",
 PRIMARY KEY(Estado_ID, Pedido_ID),
 FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID),
 FOREIGN KEY (Estado_ID) REFERENCES Estado(ID)
 );
 
 CREATE TABLE Asigna(
 Paquete_ID INT(11) PRIMARY KEY COMMENT "ID correspondiente al paquete",
 Pedido_ID INT(11) NOT NULL COMMENT "ID correspondiente al pedido",
 FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
 FOREIGN KEY (Pedido_ID) REFERENCES Pedido(ID)
 );
 
 CREATE TABLE Genera(
 Menu_ID INT(11) NOT NULL COMMENT 'Menu que representa el paquete',
 Paquete_ID INT(11) NOT NULL COMMENT 'Paquete que consta del menu',
 Fecha_de_creacion DATE NOT NULL COMMENT 'Fecha de la creacion del paquete en si',
 PRIMARY KEY(Menu_ID, Paquete_ID),
 FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
 FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID)
 );
 
 -- INSERTS
 INSERT INTO
 Cliente (
 `ID`,
 `Contrasenia`,
 `Autorizacion`,
 `Email`
 )
 VALUES
 (
 NULL,
 '926ceed06e0560a1f6db2dcf67b0e12d',
 'Autorizado',
 'email1@gmail.com'
 ),
 (
 NULL,
 '262b42c57dc9f63e61ea0a70268139f4',
 'En espera',
 'email9@hotmail.com'
 ),
 (
 NULL,
 'c5bc3ad101bf0535b06e9bafee75e592',
 'No autorizado',
 'email17@gmail.com'
 ),
 (
 NULL,
 '8edcd243db920a7728e81e37376beace',
 'Autorizado',
 'email4@gmail.com'
 ),
 (
 NULL,
 '2c08cbcf38ae224f49bdd4fff7d7b353',
 'En espera',
 'email10@hotmail.com'
 ),
 (
 NULL,
 '80f9549011dc59503d5470c1ab53f94e',
 'No autorizado',
 'email18@gmail.com'
 );
 
 INSERT INTO
 Tarjeta (
 `Numero`,
 `Digitos_verificadores`,
 `Fecha_de_vencimiento`,
 `Nombre_de_titular`,
 `Cliente_ID`
 )
 VALUES
 (
 '112312331123121233123',
 '3123',
 '2023-09-30',
 'Titular Tarjeta 1',
 1
 ),
 (
 '686868678678678678678',
 '8678',
 '2023-09-30',
 'Titular Tarjeta 2',
 2
 ),
 (
 '17171717171717171717',
 '1717',
 '2023-09-30',
 'Titular Tarjeta 3',
 3
 );
 
 INSERT INTO
 Cliente_telefono (`Cliente_ID`, `Telefono`)
 VALUES
 (1, '09123456'),
 (2, '09123456'),
 (3, '09123456'),
 (4, '09123456'),
 (5, '09123456'),
 (6, '09123456');
 
 INSERT INTO
 Empresa (`Cliente_ID`, `RUT`, `Nombre`)
 VALUES
 (4, 'RUT_empresa1', 'Nombre Empresa 1'),
 (5, 'RUT_empresa2', 'Nombre Empresa 2'),
 (6, 'RUT_empresa3', 'Nombre Empresa 3');
 
 INSERT INTO
 Web (
 `Cliente_ID`,
 `Documento_tipo`,
 `Documento_numero`,
 `Primer_nombre`,
 `Segundo_nombre`,
 `Primer_apellido`,
 `Segundo_apellido`
 )
 VALUES
 (
 1,
 'Cedula',
 12345678,
 'Primer Nombre1',
 'Segundo Nombre1',
 'Primer Apellido1',
 'Segundo Apellido1'
 ),
 (
 2,
 'Pasaporte',
 67890123,
 'Primer Nombre2',
 'Segundo Nombre2',
 'Primer Apellido2',
 'Segundo Apellido2'
 ),
 (
 3,
 'Visa',
 87654321,
 'Primer Nombre3',
 'Segundo Nombre3',
 'Primer Apellido3',
 'Segundo Apellido3'
 );
 
 INSERT INTO
 Sesion (
 `Token`,
 `Inicio_de_sesion`,
 `Ultima_sesion`,
 `Final_de_sesion`,
 `Estado`
 )
 VALUES
 (
 'x2312x23d2d2',
 NOW(),
 NOW(),
 DATE_ADD(NOW(), INTERVAL 15 MINUTE),
 'Activa'
 ),
 (
 '23ec23d23r4t',
 NOW(),
 NOW(),
 DATE_ADD(NOW(), INTERVAL 15 MINUTE),
 'Activa'
 ),
 (
 '12312334f234',
 NOW(),
 NOW(),
 DATE_ADD(NOW(), INTERVAL 15 MINUTE),
 'Activa'
 );
 
 INSERT INTO
 Menu (
 `Nombre`,
 `Frecuencia`,
 `Descripcion`,
 `Categoria`
 )
 VALUES
 (
 'Menu1',
 1,
 'Descripcion Menu 1',
 'Personalizado'
 ),
 (
 'Menu2',
 7,
 'Descripcion Menu 2',
 'Estandar'
 ),
 (
 'Menu3',
 15,
 'Descripcion Menu 3',
 'Estandar'
 ),
 (
 'Menu4',
 30,
 'Descripcion Menu 5',
 'Estandar'
 ),
 (
 'Menu5',
 11,
 'Descripcion Menu 5',
 'Estandar'
 ),
 (
 'Menu6',
 7,
 'Descripcion Menu 6',
 'Estandar'
 );
 
 INSERT INTO
 Vianda (
 `ID`,
 `Nombre`,
 `Tiempo_de_coccion`,
 `Productos`,
 `Calorias`,
 `Precio`
 )
 VALUES
 (
 1,
 'Vianda1',
 30,
 'Productos1',
 200,
 10.0
 ),
 (
 2,
 'Vianda2',
 40,
 'Productos2',
 300,
 30.0
 ),
 (
 3,
 'Vianda3',
 50,
 'Productos3',
 400,
 20.2
 ),
 (
 4,
 'Vianda4',
 30,
 'Productos1',
 200,
 10.1
 ),
 (
 5,
 'Vianda5',
 40,
 'Productos2',
 300,
 30.1
 ),
 (
 6,
 'Vianda6',
 50,
 'Productos3',
 400,
 20.2
 );
 
 INSERT INTO
 Vianda_Dieta (`Vianda_ID`, `Dieta`)
 VALUES
 (3, 'Sin Gluten'),
 (2, 'Vegetariano'),
 (3, 'Vegano'),
 (4, 'Sin Gluten'),
 (5, 'Sin Gluten'),
 (6, 'Vegano'),
 (4, 'Vegano'),
 (5, 'Vegano'),
 (6, 'Vegetariano');
 
 INSERT INTO
 Stock (`Menu_ID`, `Minimo`, `Maximo`, `Actual`)
 VALUES
 (1, 5, 10, 8),
 (2, 5, 10, 10),
 (3, 5, 10, 5);
 
 INSERT INTO
 Inicia (`Sesion_token`, `Cliente_ID`)
 VALUES
 ('x2312x23d2d2', 1),
 ('23ec23d23r4t', 2),
 ('12312334f234', 3);
 
 INSERT INTO
 Favorito (`Menu_ID`, `Web_ID`)
 VALUES
 (2, 2),
 (3, 3);
 
 INSERT INTO
 Conforma (`Menu_ID`, `Vianda_ID`)
 VALUES
 (1, 1),
 (2, 2),
 (3, 3),
 (1, 4),
 (2, 5),
 (3, 6),
 (1, 5),
 (2, 6),
 (3, 4),
 (1, 3),
 (2, 1),
 (3, 2),
 (4, 3),
 (5, 1),
 (6, 2);
 
 INSERT INTO
 Pedido (
 `ID`,
 `Direccion`,
 `Calle`,
 `Barrio`,
 `Ciudad`,
 `Fecha_del_pedido`,
 `Cliente_ID`
 )
 VALUES
 (
 1,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 DATE_ADD(NOW(), INTERVAL -1 MONTH),
 1
 ),
 (
 2,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 2
 ),
 (
 3,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 3
 ),
 (
 4,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 4
 ),
 (
 5,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 5
 ),
 (
 6,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 1
 ),
 (
 7,
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 NOW(),
 2
 );
 
 INSERT INTO
 Paquete (`ID`, `Fecha_vencimiento`)
 VALUES
 (1, DATE_ADD(NOW(), INTERVAL 41 DAY)),
 (2, DATE_ADD(NOW(), INTERVAL 10 DAY)),
 (3, DATE_ADD(NOW(), INTERVAL 41 DAY)),
 (4, DATE_ADD(NOW(), INTERVAL 41 DAY)),
 (5, DATE_ADD(NOW(), INTERVAL 41 DAY));
 
 INSERT INTO
 Recibe (`Paquete_ID`, `Cliente_ID`)
 VALUES
 (1, 1),
 (2, 2),
 (3, 3);
 
 INSERT INTO
 Compone (`Pedido_ID`, `Menu_ID`, `Cantidad`)
 VALUES
 (1, 1, 2),
 (2, 2, 3),
 (3, 3, 12);
 
 INSERT INTO
 Asigna (`Pedido_ID`, `Paquete_ID`)
 VALUES
 (1, 1),
 (2, 2),
 (3, 3),
 (3, 4);
 
 INSERT INTO
 Genera (`Menu_ID`, `Paquete_ID`, `Fecha_de_creacion`)
 VALUES
 (1, 1, NOW()),
 (2, 2, DATE_ADD(NOW(), INTERVAL 10 DAY)),
 (3, 3, NOW()),
 (3, 5, NOW());
 
 INSERT INTO
 Direccion (
 `Cliente_ID`,
 `ID`,
 `Direccion`,
 `Calle`,
 `Barrio`,
 `Ciudad`,
 `Predeterminado`
 )
 VALUES
 (
 '1',
 '1',
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 TRUE
 ),
 (
 '1',
 '2',
 '4',
 'calle1',
 'barrio1',
 'ciudad1',
 FALSE
 ),
 (
 '2',
 '1',
 '12',
 'calle9',
 'barrio9',
 'ciudad9',
 TRUE
 ),
 (
 '3',
 '1',
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 TRUE
 ),
 (
 '4',
 '1',
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 TRUE
 ),
 (
 '4',
 '2',
 '4',
 'calle1',
 'barrio1',
 'ciudad1',
 FALSE
 ),
 (
 '5',
 '1',
 '12',
 'calle9',
 'barrio9',
 'ciudad9',
 TRUE
 ),
 (
 '6',
 '1',
 '20',
 'calle17',
 'barrio17',
 'ciudad17',
 TRUE
 );
 
 INSERT INTO
 Estado (`Estado`)
 VALUES
 ('Solicitado'),
 ('Entregado'),
 ('En stock'),
 ('En produccion'),
 ('Envasado'),
 ('Devuelto'),
 ('Desechado'),
 ('Confirmado'),
 ('En camino'),
 ('Rechazado');
 
 INSERT INTO
 Paquete_esta (
 `Estado_ID`,
 `Paquete_ID`,
 `Inicio_del_estado`,
 `Final_del_estado`
 )
 VALUES
 -- 1
 (1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 3,
 1,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 4,
 1,
 DATE_ADD(NOW(), INTERVAL 4 DAY),
 DATE_ADD(NOW(), INTERVAL 5 DAY)
 ),
 (
 5,
 1,
 DATE_ADD(NOW(), INTERVAL 6 DAY),
 DATE_ADD(NOW(), INTERVAL 7 DAY)
 ),
 (
 2,
 1,
 DATE_ADD(NOW(), INTERVAL 6 DAY),
 DATE_ADD(NOW(), INTERVAL 7 DAY)
 ),
 -- 2
 (1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 4,
 2,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 6,
 2,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 7,
 2,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 -- 3
 (1, 3, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 3,
 3,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 4,
 3,
 DATE_ADD(NOW(), INTERVAL 4 DAY),
 DATE_ADD(NOW(), INTERVAL 5 DAY)
 ),
 (
 6,
 3,
 DATE_ADD(NOW(), INTERVAL 6 DAY),
 DATE_ADD(NOW(), INTERVAL 7 DAY)
 ),
 (
 7,
 3,
 DATE_ADD(NOW(), INTERVAL 6 DAY),
 DATE_ADD(NOW(), INTERVAL 7 DAY)
 );
 
 INSERT INTO
 Pedido_esta (
 `Estado_ID`,
 `Pedido_ID`,
 `Inicio_del_estado`,
 `Final_del_estado`
 )
 VALUES
 -- 1
 (1, 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 8,
 1,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 9,
 1,
 DATE_ADD(NOW(), INTERVAL 4 DAY),
 DATE_ADD(NOW(), INTERVAL 5 DAY)
 ),
 (
 2,
 1,
 DATE_ADD(NOW(), INTERVAL 6 DAY),
 DATE_ADD(NOW(), INTERVAL 7 DAY)
 ),
 -- 2
 (1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 10,
 2,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 -- 3
 (1, 3, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 10,
 3,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (1, 4, NOW(), NULL),
 (1, 5, NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
 (
 8,
 5,
 DATE_ADD(NOW(), INTERVAL 2 DAY),
 DATE_ADD(NOW(), INTERVAL 3 DAY)
 ),
 (
 9,
 5,
 DATE_ADD(NOW(), INTERVAL 4 DAY),
 NULL
 ),
 (1, 6, NOW(), NULL),
 (1, 7, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
 (8, 7, NOW(), NULL);
 */
-- Permisos de usuarios y roles
-- Elimino las vistas
DROP VIEW IF EXISTS Cliente_simplificado;
DROP VIEW IF EXISTS Datos_de_cliente_web;
-- Creación de las vistas
CREATE VIEW Cliente_simplificado AS
SELECT ID,
  Autorizacion,
  Email
FROM Cliente;
-- Elimino los usuarios
DROP USER IF EXISTS 'pagina' @'localhost';
DROP USER IF EXISTS 'gerente_1' @'localhost';
DROP USER IF EXISTS 'atencion_1' @'localhost';
DROP USER IF EXISTS 'admin_1' @'localhost';
DROP USER IF EXISTS 'jefe_de_cocina_1' @'localhost';
-- Elimino los roles
DROP ROLE IF EXISTS Gerente;
DROP ROLE IF EXISTS Administracion;
DROP ROLE IF EXISTS Atencion;
DROP ROLE IF EXISTS Jefe_de_cocina;
-- Creo el usuario único para la página web
CREATE USER 'pagina' @'localhost' IDENTIFIED BY '12345';
-- Creo los roles
CREATE ROLE Gerente;
CREATE ROLE Administracion;
CREATE ROLE Atencion;
CREATE ROLE Jefe_de_cocina;
-- Asignación de permisos a los roles (grupos)
-- Gerente
GRANT ALL PRIVILEGES ON SISVIANSA_TECHIN_V1.* TO Gerente;
-- Administración
GRANT ALL PRIVILEGES ON *.* TO Administracion;
-- Cocina
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Stock TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Estado TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Vianda TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Paquete TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Recibe TO Jefe_de_cocina;
-- Atención
GRANT SELECT ON SISVIANSA_TECHIN_V1.Paquete TO Atencion;
GRANT SELECT,
  UPDATE ON SISVIANSA_TECHIN_V1.Estado TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Pedido TO Jefe_de_cocina;
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Pedido TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Recibe TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Stock TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Menu TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Vianda TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Conforma TO Atencion;
GRANT SELECT ON SISVIANSA_TECHIN_V1.Cliente_simplificado TO Atencion;
-- Página
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Cliente TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Web TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Empresa TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Pedido TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Pedido_esta TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON SISVIANSA_TECHIN_V1.Cliente_telefono TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON SISVIANSA_TECHIN_V1.Inicia TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Tarjeta TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON SISVIANSA_TECHIN_V1.Pedido_esta TO 'pagina' @'localhost';
GRANT SELECT ON SISVIANSA_TECHIN_V1.Menu TO 'pagina' @'localhost';
GRANT SELECT ON SISVIANSA_TECHIN_V1.Vianda TO 'pagina' @'localhost';
GRANT SELECT ON SISVIANSA_TECHIN_V1.Vianda_dieta TO 'pagina' @'localhost';
GRANT SELECT ON SISVIANSA_TECHIN_V1.Conforma TO 'pagina' @'localhost';
-- Creo usuarios de prueba
CREATE USER 'gerente_1' @'localhost' IDENTIFIED BY '12345';
GRANT Gerente TO 'gerente_1' @'localhost';
CREATE USER 'atencion_1' @'localhost' IDENTIFIED BY '12345';
GRANT Atencion TO 'atencion_1' @'localhost';
CREATE USER 'admin_1' @'localhost' IDENTIFIED BY '12345';
GRANT Administracion TO 'admin_1' @'localhost';
CREATE USER 'jefe_de_cocina_1' @'localhost' IDENTIFIED BY '12345';
GRANT Jefe_de_cocina TO 'jefe_de_cocina_1' @'localhost';