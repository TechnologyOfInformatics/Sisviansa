DROP DATABASE IF EXISTS sisviansa_techin_v1;

-- Elimina la base de datos sisviansa_techin_v1 si ya existe
CREATE DATABASE IF NOT EXISTS sisviansa_techin_v1;

-- Crea la base de datos sisviansa_techin_v1
USE sisviansa_techin_v1;

-- Utiliza la base de datos sisviansa_techin_v1
-- Creación de la tabla Cliente
CREATE TABLE Cliente (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'ID único de cliente el cual es autogenerado',
  Contrasenia VARCHAR(40) NOT NULL COMMENT 'Contraseña de la cuenta correspondiente al cliente',
  Autorizacion ENUM('Autorizado', 'En espera', 'No autorizado') NOT NULL COMMENT 'Estado del pedido de autorizacion del administrador',
  Email VARCHAR(50) NOT NULL COMMENT 'ID único correspondiente al cliente'
);

-- Creación de la tabla Tarjeta
CREATE TABLE Tarjeta (
  Numero VARCHAR(30) PRIMARY KEY NOT NULL COMMENT 'Número de la tarjeta de crédito a usarse',
  Fecha_de_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta de crédito a usarse',
  Nombre_de_titular VARCHAR(30) NOT NULL COMMENT 'Nombre del titular que figura en la tarjeta de crédito correspondiente',
  Cliente_ID INT(11) COMMENT 'ID que pertenece a un cliente, el poseedor de esta tarjeta de crédito',
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);

-- Creación de la tabla Cliente_Telefono
CREATE TABLE Cliente_Telefono (
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
  Tipo VARCHAR(20) NOT NULL COMMENT 'Tipo de documento de identificacion del cliente web',
  Numero INT(11) NOT NULL COMMENT 'Numero correspondiente al tipo de documento del cliente web',
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
  Calorias INT(11) COMMENT 'Calorías totales correspondientes al menú',
  Frecuencia INT(11) COMMENT 'Frecuencia con la que el menu se entregue el menú',
  Descripcion TEXT COMMENT 'La descripcion del menu',
  Precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio del menu',
  Estado ENUM(
    'Solicitado',
    'Confirmado',
    'Enviado',
    'Entregado',
    'Rechazado'
  ) COMMENT 'Estado del menú en específico'
);

-- Creación de la tabla Paquete
CREATE TABLE Paquete (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del paquete el cual se crea automáticamente',
  Menu_ID INT(11) NOT NULL COMMENT 'Menu que conforma el pedido',
  Fecha_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento del paquete',
  Fecha_de_creacion DATE NOT NULL COMMENT 'Fecha de la creacion del paquete en si',
  Estado ENUM(
    'Solicitada',
    'En stock',
    'En producción',
    'Envasada',
    'Entregada',
    'Devuelta',
    'Desechada'
  ) NOT NULL COMMENT 'Estado actual del paquete',
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID)
);

-- Creación de la tabla Vianda
CREATE TABLE Vianda (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la vianda que se crea automáticamente',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la vianda, hace referencia a la comida que tiene dentro',
  Tiempo_de_coccion INT(11) COMMENT 'Su tiempo de cocción estimado',
  Productos VARCHAR(150) NOT NULL COMMENT 'Productos que componen la vianda',
  Stock INT(11) NOT NULL COMMENT 'Stock actual de la vianda',
  Calorias INT(11) NOT NULL COMMENT 'Calorías totales correspondientes a la vianda'
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
  Menu_ID INT(11) PRIMARY KEY COMMENT 'ID del menu que determina el stock',
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
  Demora_total INT(11) NOT NULL COMMENT 'Tiempo que demora en totalidad el pedido en hacerse',
  PRIMARY KEY(Menu_ID, Vianda_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID)
);

-- Creación de la tabla Pide
CREATE TABLE Pide (
  Menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente al pedido',
  Vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda correspondiente al pedido',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha efectuado el pedido',
  Fecha_pedido DATE NOT NULL COMMENT 'Fecha del pedido',
  Numero_de_pedido INT(11) NOT NULL COMMENT 'Número de pedido',
  PRIMARY KEY(Menu_ID, Vianda_ID, Cliente_ID),
  FOREIGN KEY (Menu_ID) REFERENCES Menu(ID),
  FOREIGN KEY (Vianda_ID) REFERENCES Vianda(ID),
  FOREIGN KEY (Cliente_ID) REFERENCES Web(Cliente_ID)
);

-- Creación de la tabla Recibe
CREATE TABLE Recibe (
  Paquete_ID INT(11) PRIMARY KEY NOT NULL COMMENT 'ID del paquete que recibira el cliente',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que recibe el paquete',
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);

CREATE TABLE Direccion (
  Cliente_ID INT(11) NOT NULL COMMENT "ID unico del cliente",
  Direccion VARCHAR(8) NOT NULL COMMENT "Direccion de la persona, ya sea el numero de puerta, o el solar",
  Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
  Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
  Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
  PRIMARY KEY(Cliente_ID, Direccion, Calle, Barrio, Ciudad),
  FOREIGN KEY (Cliente_ID) REFERENCES Cliente(ID)
);

-- Elimino las vistas
DROP VIEW IF EXISTS Cliente_simplificado;

DROP VIEW IF EXISTS Datos_de_cliente_web;

-- Creación de las vistas
CREATE VIEW Cliente_simplificado AS
SELECT
  ID,
  Autorizacion,
  Email
FROM
  Cliente;

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
GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Stock TO Jefe_de_cocina;

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Vianda TO Jefe_de_cocina;

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Paquete TO Jefe_de_cocina;

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Recibe TO Jefe_de_cocina;

-- Atención
GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Paquete TO Atencion;

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Pide TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Recibe TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Stock TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Menu TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Vianda TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Conforma TO Atencion;

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Cliente_simplificado TO Atencion;

-- Página
GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Cliente TO 'pagina' @'localhost';

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Web TO 'pagina' @'localhost';

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Empresa TO 'pagina' @'localhost';

GRANT
SELECT
,
INSERT
,
UPDATE
  ON SISVIANSA_TECHIN_V1.Pide TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Menu TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Vianda TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Conforma TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Paquete TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Recibe TO 'pagina' @'localhost';

GRANT
SELECT
  ON SISVIANSA_TECHIN_V1.Cliente_simplificado TO 'pagina' @'localhost';

-- Creo usuarios de prueba
CREATE USER 'gerente_1' @'localhost' IDENTIFIED BY '12345';

GRANT Gerente TO 'gerente_1' @'localhost';

CREATE USER 'atencion_1' @'localhost' IDENTIFIED BY '12345';

GRANT Atencion TO 'atencion_1' @'localhost';

CREATE USER 'admin_1' @'localhost' IDENTIFIED BY '12345';

GRANT Administracion TO 'admin_1' @'localhost';

CREATE USER 'jefe_de_cocina_1' @'localhost' IDENTIFIED BY '12345';

GRANT Jefe_de_cocina TO 'jefe_de_cocina_1' @'localhost';

INSERT INTO
  Cliente (`ID`, `Contrasenia`, `Autorizacion`, `Email`)
VALUES
  (
    1,
    'contrasenia1',
    'Autorizado',
    'email1@gmail.com'
  ),
  (
    2,
    'contrasenia9',
    'En espera',
    'email9@hotmail.com'
  ),
  (
    3,
    'contrasenia17',
    'No autorizado',
    'email17@gmail.com'
  );

INSERT INTO
  Tarjeta (
    `Numero`,
    `Fecha_de_vencimiento`,
    `Nombre_de_titular`,
    `Cliente_ID`
  )
VALUES
  (
    '112312331123121233123',
    '2023-09-30',
    'Titular Tarjeta 1',
    1
  ),
  (
    '686868678678678678678',
    '2023-09-30',
    'Titular Tarjeta 2',
    2
  ),
  (
    '17171717171717171717',
    '2023-09-30',
    'Titular Tarjeta 3',
    3
  );

INSERT INTO
  Cliente_Telefono (`Cliente_ID`, `Telefono`)
VALUES
  (1, '09123456'),
  (2, '09123456'),
  (3, '09123456');

INSERT INTO
  Empresa (`Cliente_ID`, `RUT`, `Nombre`)
VALUES
  (1, 'RUT_empresa1', 'Nombre Empresa 1'),
  (2, 'RUT_empresa2', 'Nombre Empresa 2'),
  (3, 'RUT_empresa3', 'Nombre Empresa 3');

INSERT INTO
  Web (
    `Cliente_ID`,
    `Tipo`,
    `Numero`,
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
    '2023-09-07 00:00:00',
    '2023-09-08 00:00:00',
    '2023-09-09 00:00:00',
    'Activa'
  ),
  (
    '23ec23d23r4t',
    '2023-09-07 00:00:00',
    '2023-09-08 00:00:00',
    '2023-09-09 00:00:00',
    'Activa'
  ),
  (
    '12312334f234',
    '2023-09-10 00:00:00',
    '2023-09-11 00:00:00',
    '2023-09-12 00:00:00',
    'Activa'
  );

INSERT INTO
  Menu (
    `ID`,
    `Nombre`,
    `Calorias`,
    `Frecuencia`,
    `Descripcion`,
    `Precio`,
    `Estado`
  )
VALUES
  (
    1,
    'Menu1',
    500,
    1,
    'Descripcion Menu 1',
    10.00,
    'Solicitado'
  ),
  (
    2,
    'Menu2',
    600,
    7,
    'Descripcion Menu 2',
    15.00,
    'Confirmado'
  ),
  (
    3,
    'Menu3',
    700,
    15,
    'Descripcion Menu 3',
    20.00,
    'Enviado'
  );

INSERT INTO
  Vianda (
    `ID`,
    `Nombre`,
    `Tiempo_de_coccion`,
    `Productos`,
    `Stock`,
    `Calorias`
  )
VALUES
  (1, 'Vianda1', 30, 'Productos1', 100, 200),
  (2, 'Vianda2', 40, 'Productos2', 200, 300),
  (3, 'Vianda3', 50, 'Productos3', 300, 400),
  (4, 'Vianda4', 30, 'Productos1', 100, 200),
  (5, 'Vianda5', 40, 'Productos2', 200, 300),
  (6, 'Vianda6', 50, 'Productos3', 300, 400);

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

TRUNCATE TABLE Favorito;

INSERT INTO
  Favorito (`Menu_ID`, `Web_ID`)
VALUES
  (1, 1),
  (2, 2),
  (3, 3);

INSERT INTO
  Conforma (`Menu_ID`, `Vianda_ID`, `Demora_total`)
VALUES
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

INSERT INTO
  Pide (
    `Menu_ID`,
    `Vianda_ID`,
    `Cliente_ID`,
    `Fecha_pedido`,
    `Numero_de_pedido`
  )
VALUES
  (1, 1, 1, '2023-09-07', 1),
  (2, 2, 2, '2023-09-08', 2),
  (3, 3, 3, '2023-09-09', 3);

INSERT INTO
  Paquete (
    `ID`,
    `Fecha_vencimiento`,
    `Fecha_de_creacion`,
    `Estado`,
    `Menu_id`
  )
VALUES
  (1, '2023-10-01', '2023-09-07', 'Solicitada', 1),
  (2, '2023-10-02', '2023-09-08', 'En stock', 2),
  (3, '2023-10-03', '2023-09-09', 'En producción', 3);

INSERT INTO
  Recibe (`Paquete_ID`, `Cliente_ID`)
VALUES
  (1, 1),
  (2, 2),
  (3, 3);

INSERT INTO
  Direccion (
    `Cliente_ID`,
    `Direccion`,
    `Calle`,
    `Barrio`,
    `Ciudad`
  )
VALUES
  (1, '4', 'calle1', 'barrio1', 'ciudad1'),
  (2, '12', 'calle9', 'barrio9', 'ciudad9'),
  (3, '20', 'calle17', 'barrio17', 'ciudad17');