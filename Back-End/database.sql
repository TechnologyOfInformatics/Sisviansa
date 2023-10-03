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
  Numero VARCHAR(40) COMMENT 'Número correspondiente al cliente',
  Calle VARCHAR(50) COMMENT 'Calle frontal del lugar donde el cliente recibe los pedidos',
  Barrio VARCHAR(50) COMMENT 'Barrio donde el cliente recibe los pedidos',
  Ciudad VARCHAR(50) COMMENT 'Ciudad donde el cliente recibe los pedidos',
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

-- Creación de la tabla Paquete
CREATE TABLE Paquete (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del paquete el cual se crea automáticamente',
  Fecha_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento del paquete',
  Fecha_de_creacion DATE NOT NULL COMMENT 'Fecha de creacion del paquete',
  Estado ENUM(
    'Solicitada',
    'En stock',
    'En producción',
    'Envasada',
    'Entregada',
    'Devuelta',
    'Desechada'
  ) NOT NULL COMMENT 'Estado actual del paquete'
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
  Token VARCHAR(15) NOT NULL COMMENT 'Token correspondiente a la sesión',
  Cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que inició la sesión',
  FOREIGN KEY (Token) REFERENCES Sesion(Token),
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

-- Creación de la tabla Genera
CREATE TABLE Genera (
  Paquete_ID INT(11) PRIMARY KEY NOT NULL COMMENT 'ID único del paquete correspondiente al pedido',
  Menu_ID INT(11) NOT NULL COMMENT 'Menu que conforma el pedido',
  Vianda_ID INT(11) NOT NULL COMMENT 'Vianda o viandas que conforman el pedido',
  FOREIGN KEY (Paquete_ID) REFERENCES Paquete(ID),
  FOREIGN KEY (Menu_ID) REFERENCES Conforma(Menu_ID),
  FOREIGN KEY (Vianda_ID) REFERENCES Conforma(Vianda_ID)
);

-- Elimino las vistas
DROP VIEW IF EXISTS Cliente_simplificado;

DROP VIEW IF EXISTS Datos_de_cliente_web;

-- Creación de las vistas
CREATE VIEW Cliente_simplificado AS
SELECT
  ID,
  Autorizacion,
  Numero,
  Calle,
  Barrio,
  Ciudad,
  Email
FROM
  Cliente;

CREATE VIEW Datos_de_cliente_web AS
SELECT
  CONCAT(Web.tipo, ': ', Web.numero) AS Documento,
  Web.Primer_nombre,
  Web.Primer_apellido,
  Telefono.Telefono,
  Cliente_simplificado.Numero,
  Cliente_simplificado.Calle,
  Cliente_simplificado.Barrio,
  Cliente_simplificado.Ciudad,
  Pide.Fecha_pedido,
  Menu.Nombre AS Nombre_Menu,
  Menu.Calorias,
  Menu.Frecuencia,
  Menu.Descripcion AS Descripcion_Menu,
  Stock.Actual AS Stock_Menu,
  Paquete.Fecha_de_creacion,
  Paquete.Fecha_vencimiento
FROM
  Cliente_simplificado
  JOIN Cliente_Telefono AS Telefono ON Cliente_simplificado.ID = Telefono.Cliente_ID
  JOIN Web ON Cliente_simplificado.ID = Web.Cliente_ID
  JOIN Pide ON Cliente_simplificado.ID = Pide.Cliente_ID
  JOIN Conforma ON Pide.Vianda_ID = Conforma.Vianda_ID
  AND Pide.Vianda_ID = Conforma.Vianda_ID
  JOIN Genera ON Genera.Vianda_ID = Conforma.Vianda_ID
  AND Genera.Vianda_ID = Conforma.Vianda_ID
  JOIN Paquete ON Paquete.ID = Genera.Paquete_ID
  JOIN Menu ON Genera.Menu_ID = Menu.ID
  JOIN Recibe ON Paquete.ID = Recibe.Paquete_ID
  JOIN Stock ON Menu.ID = Stock.Menu_ID;

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
  ON SISVIANSA_TECHIN_V1.Genera TO Jefe_de_cocina;

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
  ON SISVIANSA_TECHIN_V1.Genera TO Atencion;

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
  ON SISVIANSA_TECHIN_V1.Genera TO 'pagina' @'localhost';

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