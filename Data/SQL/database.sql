SET time_zone = '-3:00';
DROP DATABASE IF EXISTS sisviansa_techin_v1;
-- Elimina la base de datos sisviansa_techin_v1 si ya existe
CREATE DATABASE IF NOT EXISTS sisviansa_techin_v1;
-- Crea la base de datos sisviansa_techin_v1
USE sisviansa_techin_v1;
-- Utiliza la base de datos sisviansa_techin_v1
-- Creación de la tabla cliente
CREATE TABLE cliente (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT 'ID único de cliente el cual es autogenerado',
  Contrasenia VARCHAR(100) NOT NULL COMMENT 'Contraseña de la cuenta correspondiente al cliente',
  Autorizacion ENUM('Autorizado', 'En espera', 'No autorizado') NOT NULL COMMENT 'estado del pedido de autorizacion del administrador',
  Email VARCHAR(50) NOT NULL COMMENT 'ID único correspondiente al cliente'
);
-- Creación de la tabla tarjeta
CREATE TABLE tarjeta (
  Numero VARCHAR(30) NOT NULL COMMENT 'Número de la tarjeta de crédito a usarse',
  Digitos_verificadores VARCHAR(4) NOT NULL COMMENT 'Últimos 4 digitos numeros de la tarjeta de crédito a usarse',
  Fecha_de_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta de crédito a usarse',
  Nombre_de_titular VARCHAR(30) NOT NULL COMMENT 'Nombre del titular que figura en la tarjeta de crédito correspondiente',
  cliente_ID INT(11) COMMENT 'ID que pertenece a un cliente, el poseedor de esta tarjeta de crédito',
  PRIMARY KEY(cliente_ID, Numero),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla cliente_telefono
CREATE TABLE cliente_telefono (
  cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente dueño poseedor de teléfono',
  Telefono VARCHAR(15) NOT NULL COMMENT 'Teléfono correspondiente al cliente',
  PRIMARY KEY(cliente_ID, Telefono),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla empresa
CREATE TABLE empresa (
  cliente_ID INT(11) PRIMARY KEY COMMENT 'ID de la empresa dentro de la tabla de clientes',
  RUT VARCHAR(12) NOT NULL COMMENT 'RUT de la empresa',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la empresa oficial',
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla web
CREATE TABLE web (
  cliente_ID INT(11) PRIMARY KEY COMMENT 'ID del cliente web dentro de la tabla de clientes',
  Documento_tipo VARCHAR(20) NOT NULL COMMENT 'Tipo de documento de identificacion del cliente web',
  Documento_numero INT(11) NOT NULL COMMENT 'Numero correspondiente al tipo de documento del cliente web',
  Primer_nombre VARCHAR(30) NOT NULL COMMENT 'Primer nombre del cliente correspondiente',
  Segundo_nombre VARCHAR(30) DEFAULT NULL COMMENT 'Segundo nombre del cliente correspondiente',
  Primer_apellido VARCHAR(30) NOT NULL COMMENT 'Primer apellido del cliente correspondiente',
  Segundo_apellido VARCHAR(30) DEFAULT NULL COMMENT 'Segundo apellido del cliente correspondiente',
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla sesion
CREATE TABLE sesion (
  Token VARCHAR(15) PRIMARY KEY COMMENT 'Código único conocido como token el cual se usa para identificar una sesión',
  Inicio_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora en la cual se inicio la sesión',
  Ultima_sesion DATETIME NOT NULL COMMENT 'Fecha y hora del último inicio de sesión',
  Final_de_sesion DATETIME NOT NULL COMMENT 'Fecha y hora donde la sesión se terminará sesión',
  estado ENUM('Activa', 'Finalizada') NOT NULL COMMENT 'estado de la sesión a la que se hace referencia'
);
-- Creación de la tabla menu
CREATE TABLE menu (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del menú el cual es autogenerado',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre del menú que hace referencia a las viandas que lo contienen',
  Frecuencia INT(11) COMMENT 'Frecuencia con la que el menu se entregue el menú',
  Descripcion TEXT COMMENT 'La descripcion del menu',
  Categoria ENUM('Estandar', 'Personalizado', 'Descartado') NOT NULL COMMENT 'La categoria a la que pertenece el menu, donde puede ser creado por un cliente, el sistema o ser un menu descartado'
);
-- Creación de la tabla vianda
CREATE TABLE vianda (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único de la vianda que se crea automáticamente',
  Nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la vianda, hace referencia a la comida que tiene dentro',
  Tiempo_de_coccion INT(11) COMMENT 'Su tiempo de cocción estimado en minutos',
  Productos VARCHAR(150) NOT NULL COMMENT 'Productos que componen la vianda',
  Calorias INT(11) NOT NULL COMMENT 'Calorías totales correspondientes a la vianda',
  Precio DECIMAL(10, 2) NOT NULL COMMENT 'Precio propio de la vianda'
);
-- Creacion de la tabla pedido
CREATE TABLE pedido(
  ID INT(11) AUTO_INCREMENT COMMENT 'Número del pedido correspondiente',
  Fecha_del_pedido DATETIME NOT NULL COMMENT 'Fecha del pedido',
  cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha efectuado el pedido',
  direccion VARCHAR(8) NOT NULL COMMENT "direccion de la persona, ya sea el numero de puerta, o el solar",
  Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
  Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
  Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
  PRIMARY KEY(ID, cliente_ID),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla paquete
CREATE TABLE paquete (
  ID INT(11) AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único del paquete el cual se crea automáticamente',
  Fecha_vencimiento DATE NOT NULL COMMENT 'Fecha de vencimiento del paquete'
);
-- Creación de la tabla vianda_dieta
CREATE TABLE vianda_dieta (
  vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda que tiene ésta dieta',
  Dieta VARCHAR(100) NOT NULL COMMENT 'Nombre de la dieta, el cual normalmente hace alusión a un conjunto de comidas que tienen una misma cualidad',
  PRIMARY KEY(vianda_ID, Dieta),
  FOREIGN KEY (vianda_ID) REFERENCES vianda(ID)
);
-- Creación de la tabla stock
CREATE TABLE stock (
  menu_ID INT(11) PRIMARY KEY COMMENT 'ID del menu en stock',
  Minimo INT(11) COMMENT 'stock mínimo de cajas',
  Maximo INT(11) COMMENT 'stock máximo de cajas',
  Actual INT(11) COMMENT 'stock actual de cajas',
  FOREIGN KEY (menu_ID) REFERENCES menu(ID)
);
-- Creación de la tabla inicia
CREATE TABLE inicia (
  sesion_token VARCHAR(15) NOT NULL COMMENT 'Token correspondiente a la sesión',
  cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que inició la sesión',
  FOREIGN KEY (sesion_token) REFERENCES sesion(Token),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
-- Creación de la tabla favorito
CREATE TABLE favorito (
  menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente al favorito',
  web_ID INT(11) NOT NULL COMMENT 'ID del cliente que ha marcado como favorito el menú',
  PRIMARY KEY(menu_ID, web_ID),
  FOREIGN KEY (menu_ID) REFERENCES menu(ID),
  FOREIGN KEY (web_ID) REFERENCES web(cliente_ID)
);
-- Creación de la tabla conforma
CREATE TABLE conforma (
  menu_ID INT(11) NOT NULL COMMENT 'ID del menú correspondiente a la caja',
  vianda_ID INT(11) NOT NULL COMMENT 'ID de la vianda correspondiente a la caja',
  PRIMARY KEY(menu_ID, vianda_ID),
  FOREIGN KEY (menu_ID) REFERENCES menu(ID),
  FOREIGN KEY (vianda_ID) REFERENCES vianda(ID)
);
-- Creación de la tabla recibe
CREATE TABLE recibe (
  paquete_ID INT(11) PRIMARY KEY NOT NULL COMMENT 'ID del paquete que recibira el cliente',
  cliente_ID INT(11) NOT NULL COMMENT 'ID del cliente que recibe el paquete',
  FOREIGN KEY (paquete_ID) REFERENCES paquete(ID),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
CREATE TABLE direccion (
  ID INT(11) NOT NULL COMMENT "El ID unico de la direccion correspondiente",
  cliente_ID INT(11) NOT NULL COMMENT "ID unico del cliente",
  direccion VARCHAR(8) NOT NULL COMMENT "direccion de la persona, ya sea el numero de puerta, o el solar",
  Calle VARCHAR(30) NOT NULL COMMENT "Calle correspondiente a la direccion dada",
  Barrio VARCHAR(20) COMMENT "Barrio en donde se puede encontrar la direccion",
  Ciudad VARCHAR(30) NOT NULL COMMENT "Ciudad o Localidad en la que se encuentra la direccion dada",
  Predeterminado BOOLEAN NOT NULL COMMENT "Determina si la vianda correspondiente es la predeterminada",
  PRIMARY KEY(cliente_ID, ID),
  FOREIGN KEY (cliente_ID) REFERENCES cliente(ID)
);
CREATE TABLE compone(
  pedido_ID INT(11) NOT NULL COMMENT 'ID del pedido correspondiente al menú',
  menu_ID INT(11) NOT NULL COMMENT 'ID del menú que está en el pedido',
  Cantidad INT(11) NOT NULL COMMENT 'Cantidad de veces que se compro éste menu en éste pedido',
  PRIMARY KEY(pedido_ID, menu_ID),
  FOREIGN KEY (menu_ID) REFERENCES menu(ID),
  FOREIGN KEY (pedido_ID) REFERENCES pedido(ID)
);
CREATE TABLE estado (
  ID INT(11) PRIMARY KEY AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente a un paquete o pedido',
  estado ENUM(
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
  ) NOT NULL COMMENT "estado en si del paquete o pedido" -- Los estados de paquete son desde En stock hasta Desechado, y desde Confirmado hasta Rechazado es de pedido, se comparte "Solicitado" y "Entregado"
);
CREATE TABLE paquete_esta (
  estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al paquete ',
  paquete_ID INT(11) NOT NULL COMMENT "ID del paquete",
  Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del paquete inicio",
  Final_del_estado DATETIME COMMENT "Fecha en donde el estado del paquete finalizó",
  PRIMARY KEY(estado_ID, paquete_ID),
  FOREIGN KEY (paquete_ID) REFERENCES paquete(ID),
  FOREIGN KEY (estado_ID) REFERENCES estado(ID)
);
CREATE TABLE pedido_esta (
  estado_ID INT(11) AUTO_INCREMENT COMMENT 'ID del estado en específico correspondiente al pedido',
  pedido_ID INT(11) NOT NULL COMMENT "ID del pedido",
  Inicio_del_estado DATETIME NOT NULL COMMENT "Fecha en donde el estado del pedido inicio",
  Final_del_estado DATETIME COMMENT "Fecha en donde el estado del pedido finalizó",
  PRIMARY KEY(estado_ID, pedido_ID),
  FOREIGN KEY (pedido_ID) REFERENCES pedido(ID),
  FOREIGN KEY (estado_ID) REFERENCES estado(ID)
);
CREATE TABLE asigna(
  paquete_ID INT(11) PRIMARY KEY COMMENT "ID correspondiente al paquete",
  pedido_ID INT(11) NOT NULL COMMENT "ID correspondiente al pedido",
  FOREIGN KEY (paquete_ID) REFERENCES paquete(ID),
  FOREIGN KEY (pedido_ID) REFERENCES pedido(ID)
);
CREATE TABLE genera(
  menu_ID INT(11) NOT NULL COMMENT 'menu que representa el paquete',
  paquete_ID INT(11) NOT NULL COMMENT 'paquete que consta del menu',
  Fecha_de_creacion DATE NOT NULL COMMENT 'Fecha de la creacion del paquete en si',
  PRIMARY KEY(menu_ID, paquete_ID),
  FOREIGN KEY (menu_ID) REFERENCES menu(ID),
  FOREIGN KEY (paquete_ID) REFERENCES paquete(ID)
);
CREATE TABLE SISVIANSA_USER(
  ID INT(11) PRIMARY KEY AUTO_INCREMENT COMMENT "ID del usuario del sistema",
  NOMBRE VARCHAR(30) NOT NULL COMMENT 'Nombre del usuario del sistema',
  ROL ENUM('Atencion', 'Jefe_de_cocina', 'Gerente') NOT NULL COMMENT 'Rol del usuario correspondiente'
);
-- Insersiones
INSERT INTO `cliente` (`ID`, `Contrasenia`, `Autorizacion`, `Email`)
VALUES (
    1,
    '926ceed06e0560a1f6db2dcf67b0e12d',
    'No autorizado',
    'cliente1@example.com'
  ),
  (
    2,
    '46e097e550e7629ad3c0e3c2903a4c99',
    'En espera',
    'cliente2@example.com'
  ),
  (
    3,
    'ad92be9be4feec5a988f7d84d38d034f',
    'No autorizado',
    'cliente3@example.com'
  ),
  (
    4,
    '8edcd243db920a7728e81e37376beace',
    'Autorizado',
    'cliente4@example.com'
  ),
  (
    5,
    'fa2954d52b7f0398696da26fa6f9ffd6',
    'En espera',
    'cliente5@example.com'
  ),
  (
    6,
    'c227442d1860c6a51d2985c49e840822',
    'No autorizado',
    'cliente6@example.com'
  ),
  (
    7,
    '51d8d13486345476cd091bae26b85501',
    'Autorizado',
    'cliente7@example.com'
  ),
  (
    8,
    '927b23b1831315039417a514772a22da',
    'En espera',
    'cliente8@example.com'
  ),
  (
    9,
    '262b42c57dc9f63e61ea0a70268139f4',
    'No autorizado',
    'cliente9@example.com'
  ),
  (
    10,
    '2c08cbcf38ae224f49bdd4fff7d7b353',
    'Autorizado',
    'cliente10@example.com'
  ),
  (
    11,
    '8249f1480796ba6d60630834869f45fe',
    'En espera',
    'cliente11@example.com'
  ),
  (
    12,
    'be791ded8a376f8b2d08dcfefd59bcc8',
    'No autorizado',
    'cliente12@example.com'
  ),
  (
    13,
    '608a70fd0983bbefb004004de9586da9',
    'Autorizado',
    'cliente13@example.com'
  ),
  (
    14,
    '8e8c9d17dc70045bab6a97679f3c7082',
    'En espera',
    'cliente14@example.com'
  ),
  (
    15,
    '04e6d94198c21abe4182ca7535ef7ee2',
    'No autorizado',
    'cliente15@example.com'
  ),
  (
    16,
    'a6ea050ef0dace09c1bdc4b2a7ec2896',
    'Autorizado',
    'cliente16@example.com'
  ),
  (
    17,
    'c5bc3ad101bf0535b06e9bafee75e592',
    'En espera',
    'cliente17@example.com'
  ),
  (
    18,
    '80f9549011dc59503d5470c1ab53f94e',
    'No autorizado',
    'cliente18@example.com'
  ),
  (
    19,
    '4d3310ed24366734254aaa79c79d22a0',
    'Autorizado',
    'cliente19@example.com'
  ),
  (
    20,
    'eb6337f2f08af934f29d73757ea3fe80',
    'En espera',
    'cliente20@example.com'
  );
INSERT INTO `empresa` (`cliente_ID`, `RUT`, `Nombre`)
VALUES (2, '98765432109', 'empresa A'),
  (4, '1122334455', 'empresa B'),
  (6, '9988776655', 'empresa C'),
  (8, '6677889900', 'empresa D'),
  (10, '5544332211', 'empresa E'),
  (12, '4455667788', 'empresa F'),
  (14, '2233445566', 'empresa G'),
  (16, '3322114455', 'empresa H'),
  (18, '5566778899', 'empresa I'),
  (20, '5566778899', 'empresa J');
INSERT INTO `estado` (`ID`, `estado`)
VALUES (1, 'Solicitado'),
  (2, 'Entregado'),
  (3, 'En stock'),
  (4, 'En produccion'),
  (5, 'Envasado'),
  (6, 'Devuelto'),
  (7, 'Desechado'),
  (8, 'Confirmado'),
  (9, 'En camino'),
  (10, 'Rechazado');
INSERT INTO `menu` (
    `ID`,
    `Nombre`,
    `Frecuencia`,
    `Descripcion`,
    `Categoria`
  )
VALUES (
    1,
    'menu Clásico',
    30,
    'Selección de platos tradicionales',
    'Estandar'
  ),
  (
    2,
    'menu Fitness',
    15,
    'Platos saludables y bajos en calorías',
    'Personalizado'
  ),
  (
    3,
    'menu Vegano',
    15,
    'Completamente basado en ingredientes veganos',
    'Estandar'
  ),
  (
    4,
    'Menú Asiático Picante',
    7,
    'Sabores picantes de la cocina asiática.',
    'Estandar'
  ),
  (
    5,
    'Menú de la Casa',
    30,
    'Platos caseros tradicionales.',
    'Estandar'
  ),
  (
    6,
    'Menú Ejecutivo',
    1,
    'Platos gourmet para almuerzos ejecutivos.',
    'Estandar'
  ),
  (
    7,
    'Menú Vegetariano Fresco',
    7,
    'Opciones frescas y saludables sin carne.',
    'Estandar'
  ),
  (
    8,
    'Menú Italiano',
    7,
    'Deliciosa selección de platos italianos auténticos.',
    'Estandar'
  );
INSERT INTO `paquete` (`ID`, `Fecha_vencimiento`)
VALUES (1, '2023-11-14'),
  (2, '2023-11-14'),
  (3, '2023-11-14'),
  (4, '2023-11-14'),
  (5, '2023-11-14'),
  (6, '2023-11-14'),
  (7, '2023-11-14'),
  (8, '2023-11-14'),
  (9, '2023-11-14'),
  (10, '2023-11-14'),
  (11, '2023-11-14'),
  (12, '2023-11-14'),
  (13, '2023-11-14'),
  (14, '2023-11-14'),
  (15, '2023-11-14'),
  (16, '2023-11-14'),
  (17, '2023-11-14'),
  (18, '2023-11-14'),
  (19, '2023-11-14');
INSERT INTO `pedido` (
    `ID`,
    `Fecha_del_pedido`,
    `cliente_ID`,
    `direccion`,
    `Calle`,
    `Barrio`,
    `Ciudad`
  )
VALUES (
    32,
    '2023-11-12 01:48:39',
    1,
    '789',
    '18 de Julio',
    'Centro',
    'Montevideo'
  ),
  (
    33,
    '2023-11-12 01:53:42',
    7,
    '321',
    'Maldonado',
    'Palermo',
    'Montevideo'
  ),
  (
    34,
    '2023-11-12 01:53:44',
    10,
    '321',
    'Paraguay',
    'Paso Molino',
    'Montevideo'
  ),
  (
    35,
    '2023-11-12 01:53:46',
    13,
    '321',
    '8 de Octubre',
    'Sayago',
    'Montevideo'
  ),
  (
    36,
    '2023-11-12 01:53:48',
    16,
    '321',
    'Rambla Sur',
    'Buceo',
    'Montevideo'
  ),
  (
    37,
    '2023-11-12 01:53:50',
    19,
    '321',
    'Yaguarón',
    'Jacinto Vera',
    'Montevideo'
  );
INSERT INTO `sesion` (
    `Token`,
    `Inicio_de_sesion`,
    `Ultima_sesion`,
    `Final_de_sesion`,
    `estado`
  )
VALUES (
    '04veYsW0YHB',
    '2023-11-12 01:36:34',
    '2023-11-12 01:51:34',
    '2023-11-12 01:51:34',
    'Finalizada'
  ),
  (
    '0m2Tew3z07z9o',
    '2023-11-12 01:37:45',
    '2023-11-12 01:52:45',
    '2023-11-12 01:52:45',
    'Finalizada'
  ),
  (
    '172MqToWSPUWs',
    '2023-11-12 01:53:41',
    '2023-11-12 02:08:41',
    '2023-11-12 02:08:41',
    'Activa'
  ),
  (
    '1uFZNoXSTRCwH',
    '2023-11-12 01:36:33',
    '2023-11-12 01:51:33',
    '2023-11-12 01:51:33',
    'Finalizada'
  ),
  (
    '1vHkhligERUG',
    '2023-11-12 01:37:32',
    '2023-11-12 01:52:32',
    '2023-11-12 01:52:32',
    'Finalizada'
  ),
  (
    '2iiGE2BE',
    '2023-11-12 01:37:31',
    '2023-11-12 01:52:31',
    '2023-11-12 01:52:31',
    'Finalizada'
  ),
  (
    '2l8qU9ZO',
    '2023-11-12 01:52:24',
    '2023-11-12 02:07:24',
    '2023-11-12 02:07:24',
    'Finalizada'
  ),
  (
    '2xwF6K1P0BRyD',
    '2023-11-12 01:37:04',
    '2023-11-12 01:52:04',
    '2023-11-12 01:52:04',
    'Finalizada'
  ),
  (
    '3isN2RrDCcH1pO',
    '2023-11-12 01:37:32',
    '2023-11-12 01:52:32',
    '2023-11-12 01:52:32',
    'Finalizada'
  ),
  (
    '3WqrVJP8',
    '2023-11-12 01:37:46',
    '2023-11-12 01:52:46',
    '2023-11-12 01:52:46',
    'Finalizada'
  ),
  (
    '50UaQtutvFPQ',
    '2023-11-12 01:37:45',
    '2023-11-12 01:52:45',
    '2023-11-12 01:52:45',
    'Finalizada'
  ),
  (
    '5au8B8XLDh2iX9',
    '2023-11-12 01:37:33',
    '2023-11-12 01:52:33',
    '2023-11-12 01:52:33',
    'Finalizada'
  ),
  (
    '5qbhO5zPloBV',
    '2023-11-12 01:36:35',
    '2023-11-12 01:51:35',
    '2023-11-12 01:51:35',
    'Finalizada'
  ),
  (
    '5Y4eRVbiAaRKlw',
    '2023-11-12 01:53:49',
    '2023-11-12 02:08:49',
    '2023-11-12 02:08:49',
    'Activa'
  ),
  (
    '6c9Fofk3jfk6',
    '2023-11-12 01:53:43',
    '2023-11-12 02:08:43',
    '2023-11-12 02:08:43',
    'Activa'
  ),
  (
    '8JAAEku5gZN',
    '2023-11-12 01:37:01',
    '2023-11-12 01:52:01',
    '2023-11-12 01:52:01',
    'Finalizada'
  ),
  (
    'abc123xyz456789',
    '2023-09-30 10:00:00',
    '2023-09-30 15:30:00',
    '2023-09-30 17:00:00',
    'Finalizada'
  ),
  (
    'bCRw26e70e',
    '2023-11-12 01:37:02',
    '2023-11-12 01:52:02',
    '2023-11-12 01:52:02',
    'Finalizada'
  ),
  (
    'BdtECt16i0LaT',
    '2023-11-12 01:37:31',
    '2023-11-12 01:52:31',
    '2023-11-12 01:52:31',
    'Finalizada'
  ),
  (
    'def456uvw789012',
    '2023-09-30 12:30:00',
    '2023-09-30 16:45:00',
    '2023-09-30 18:30:00',
    'Activa'
  ),
  (
    'dZ2uHEuD',
    '2023-11-12 01:53:45',
    '2023-11-12 02:08:45',
    '2023-11-12 02:08:45',
    'Activa'
  ),
  (
    'Em44gzXPjgTu',
    '2023-11-12 01:36:33',
    '2023-11-12 01:51:33',
    '2023-11-12 01:51:33',
    'Finalizada'
  ),
  (
    'euaWyg2LE',
    '2023-11-12 01:37:47',
    '2023-11-12 01:52:47',
    '2023-11-12 01:52:47',
    'Finalizada'
  ),
  (
    'f4dfLDNoyf',
    '2023-11-12 01:37:46',
    '2023-11-12 01:52:46',
    '2023-11-12 01:52:46',
    'Finalizada'
  ),
  (
    'f7PHVvfZ',
    '2023-11-12 01:37:44',
    '2023-11-12 01:52:44',
    '2023-11-12 01:52:44',
    'Finalizada'
  ),
  (
    'GHg73GkM',
    '2023-11-12 01:37:44',
    '2023-11-12 01:52:44',
    '2023-11-12 01:52:44',
    'Finalizada'
  ),
  (
    'ghi789rst012345',
    '2023-09-30 14:45:00',
    '2023-09-30 18:00:00',
    '2023-09-30 20:30:00',
    'Activa'
  ),
  (
    'H9Dl6Ej0UpZ4fU',
    '2023-11-12 01:37:30',
    '2023-11-12 01:52:30',
    '2023-11-12 01:52:30',
    'Finalizada'
  ),
  (
    'IpkJS97K4IhN',
    '2023-11-10 10:33:51',
    '2023-11-10 10:48:51',
    '2023-11-10 10:48:51',
    'Finalizada'
  ),
  (
    'JVSrs9UCkmrH',
    '2023-11-12 01:52:42',
    '2023-11-12 02:07:42',
    '2023-11-12 02:07:42',
    'Finalizada'
  ),
  (
    'miAQx0oyuD',
    '2023-11-12 01:53:40',
    '2023-11-12 02:08:40',
    '2023-11-12 02:08:40',
    'Activa'
  ),
  (
    'neWWOkGX2v2FuT',
    '2023-11-12 01:36:34',
    '2023-11-12 01:51:34',
    '2023-11-12 01:51:34',
    'Finalizada'
  ),
  (
    'PLd1nXZeZ',
    '2023-11-12 01:48:40',
    '2023-11-12 02:03:41',
    '2023-11-12 02:03:41',
    'Finalizada'
  ),
  (
    'q1dbFnEAbv578',
    '2023-11-12 01:36:32',
    '2023-11-12 01:51:32',
    '2023-11-12 01:51:32',
    'Finalizada'
  ),
  (
    'T4qIXvbnN',
    '2023-11-12 01:36:35',
    '2023-11-12 01:51:35',
    '2023-11-12 01:51:35',
    'Finalizada'
  ),
  (
    'tIN5CoVoalC',
    '2023-11-12 01:48:38',
    '2023-11-12 02:03:38',
    '2023-11-12 02:03:38',
    'Activa'
  ),
  (
    'TXr9IEHltC1',
    '2023-11-12 01:37:29',
    '2023-11-12 01:52:30',
    '2023-11-12 01:52:30',
    'Finalizada'
  ),
  (
    'V2hxqf8SSTmN',
    '2023-11-12 01:37:03',
    '2023-11-12 01:52:04',
    '2023-11-12 01:52:04',
    'Finalizada'
  ),
  (
    'XeDmmybU',
    '2023-11-12 01:37:02',
    '2023-11-12 01:52:02',
    '2023-11-12 01:52:02',
    'Finalizada'
  ),
  (
    'ZEu89rOVR0x6SR',
    '2023-11-12 01:37:01',
    '2023-11-12 01:52:01',
    '2023-11-12 01:52:01',
    'Finalizada'
  ),
  (
    'zIjJLmSW1OU',
    '2023-11-12 01:37:03',
    '2023-11-12 01:52:03',
    '2023-11-12 01:52:03',
    'Finalizada'
  ),
  (
    'Zl58TbiadtovoA',
    '2023-11-12 01:53:47',
    '2023-11-12 02:08:47',
    '2023-11-12 02:08:47',
    'Activa'
  );
INSERT INTO `vianda` (
    `ID`,
    `Nombre`,
    `Tiempo_de_coccion`,
    `Productos`,
    `Calorias`,
    `Precio`
  )
VALUES (
    1,
    'Lomo a la pimienta',
    30,
    'Lomo, Pimienta, Sal',
    450,
    25.50
  ),
  (
    2,
    'Ensalada de quinoa',
    15,
    'Quinoa, Tomate, Pepino',
    200,
    15.80
  ),
  (
    3,
    'Tofu stir-fry',
    20,
    'Tofu, Verduras, Salsa de soja',
    300,
    18.20
  ),
  (
    4,
    'Guiso',
    20,
    'Un guiso de carne estofado',
    550,
    15.00
  ),
  (
    5,
    'Curry de Garbanzos',
    30,
    'Garbanzos, tomate, especias',
    350,
    11.99
  ),
  (
    6,
    'Hamburguesa BBQ',
    25,
    'Carne de res, pan, salsa barbacoa',
    700,
    14.99
  ),
  (
    7,
    'Sushi Variado',
    10,
    'Arroz, pescado variado, alga nori',
    550,
    18.99
  ),
  (
    8,
    'Pollo al Curry',
    35,
    'Pollo, curry, leche de coco',
    480,
    16.99
  ),
  (
    9,
    'Tacos de Camarones',
    20,
    'Camarones, tortillas de maíz, salsa',
    400,
    17.99
  ),
  (
    10,
    'Pasta Primavera',
    25,
    'Pasta, verduras de temporada, aceite de oliva',
    420,
    14.99
  ),
  (
    11,
    'Lasagna Clásica',
    45,
    'Carne, pasta, salsa de tomate, queso',
    600,
    12.99
  ),
  (
    12,
    'Ensalada Mediterránea',
    15,
    'Lechuga, tomate, aceitunas, queso feta',
    300,
    8.99
  ),
  (
    13,
    'Salmón Teriyaki',
    20,
    'Salmón, salsa teriyaki, arroz',
    450,
    15.99
  );
INSERT INTO `vianda_dieta` (`vianda_ID`, `Dieta`)
VALUES (1, 'Vegetariana'),
  (2, 'Vegana'),
  (2, 'Vegetariana'),
  (3, 'Sin gluten'),
  (4, 'Vegetariana'),
  (5, 'Vegana'),
  (6, 'Pescetariana'),
  (7, 'Vegetariana'),
  (8, 'Sin gluten');
INSERT INTO `web` (
    `cliente_ID`,
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
    3,
    'DNI',
    11223344,
    'Carlos',
    NULL,
    'Rodríguez',
    NULL
  ),
  (
    5,
    'DNI',
    87654321,
    'Pablo',
    'Andrés',
    'Fernández',
    'López'
  ),
  (
    7,
    'CI',
    54321678,
    'Valentina',
    NULL,
    'Gutierrez',
    'Mendoza'
  ),
  (
    9,
    'DNI',
    98765432,
    'Laura',
    NULL,
    'Díaz',
    'Rodríguez'
  ),
  (
    11,
    'CI',
    23456789,
    'Joaquín',
    NULL,
    'García',
    'Gómez'
  ),
  (
    13,
    'DNI',
    45678901,
    'Camila',
    NULL,
    'Ramírez',
    'Pérez'
  ),
  (
    15,
    'CI',
    32109876,
    'Diego',
    'Joaquín',
    'Díaz',
    'Rodríguez'
  ),
  (
    17,
    'DNI',
    54321098,
    'Ana',
    'María',
    'Martínez',
    'Suárez'
  ),
  (
    19,
    'CI',
    8765432,
    'María',
    NULL,
    'López',
    'González'
  );
INSERT INTO `cliente_telefono` (`cliente_ID`, `Telefono`)
VALUES (1, '+54123456711'),
  (1, '+54123456789'),
  (2, '+54987654311'),
  (2, '+54987654321'),
  (3, '+55011223311'),
  (3, '+55011223344'),
  (4, '+554433221100'),
  (4, '+554433221111'),
  (5, '+554433221111'),
  (5, '+554433221122'),
  (6, '+554433221111'),
  (6, '+554433221133'),
  (7, '+554433221111'),
  (7, '+554433221144'),
  (8, '+554433221111'),
  (8, '+554433221155'),
  (9, '+554433221111'),
  (9, '+554433221166'),
  (10, '+554433221111'),
  (10, '+554433221177'),
  (11, '+554433221111'),
  (11, '+554433221188'),
  (12, '+554433221111'),
  (12, '+554433221199'),
  (13, '+554433221200'),
  (13, '+554433221211'),
  (14, '+554433221211'),
  (14, '+5544332212111'),
  (15, '+554433221211'),
  (15, '+554433221222'),
  (16, '+554433221211'),
  (16, '+554433221233'),
  (17, '+554433221211'),
  (17, '+554433221244'),
  (18, '+554433221211'),
  (18, '+554433221255'),
  (19, '+554433221211'),
  (19, '+554433221266'),
  (20, '+554433221211'),
  (20, '+554433221277');
INSERT INTO `compone` (`pedido_ID`, `menu_ID`, `Cantidad`)
VALUES (32, 7, 4),
  (33, 5, 2),
  (34, 4, 1),
  (34, 1, 6),
  (34, 5, 4),
  (35, 4, 1),
  (36, 8, 4),
  (37, 6, 3);
INSERT INTO `conforma` (`menu_ID`, `vianda_ID`)
VALUES (1, 1),
  (1, 2),
  (2, 2),
  (2, 3),
  (3, 1),
  (3, 3),
  (4, 11),
  (5, 9),
  (5, 12),
  (6, 8),
  (6, 13),
  (7, 4),
  (7, 6),
  (7, 7),
  (8, 5),
  (8, 10);
INSERT INTO `direccion` (
    `ID`,
    `cliente_ID`,
    `direccion`,
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
    1
  ),
  (
    1,
    2,
    '987',
    'Rambla Sur',
    'Pocitos',
    'Montevideo',
    1
  ),
  (
    2,
    2,
    '654',
    'Ellauri',
    'Carrasco',
    'Montevideo',
    0
  ),
  (
    1,
    3,
    '321',
    'Luis Alberto de Herrera',
    'Parque Rodó',
    'Montevideo',
    1
  ),
  (
    2,
    3,
    '654',
    'Avenida Brasil',
    'Punta Carretas',
    'Montevideo',
    0
  ),
  (
    3,
    3,
    '987',
    'Echevarriarza',
    'Villa Muñoz',
    'Montevideo',
    0
  ),
  (
    1,
    6,
    '654',
    'Soriano',
    'Barrio Sur',
    'Montevideo',
    1
  ),
  (
    2,
    6,
    '987',
    'Reconquista',
    'Ciudadela',
    'Montevideo',
    0
  ),
  (
    1,
    7,
    '321',
    'Maldonado',
    'Palermo',
    'Montevideo',
    1
  ),
  (
    2,
    7,
    '654',
    'Sarmiento',
    'Bella Vista',
    'Montevideo',
    0
  ),
  (
    1,
    8,
    '987',
    'Yaguarón',
    'Jacinto Vera',
    'Montevideo',
    1
  ),
  (
    2,
    8,
    '321',
    'Miguelete',
    'La Teja',
    'Montevideo',
    0
  ),
  (
    1,
    9,
    '654',
    'Luis de la Torre',
    'Atahualpa',
    'Montevideo',
    1
  ),
  (
    2,
    9,
    '987',
    'Tristan Narvaja',
    'La Figurita',
    'Montevideo',
    0
  ),
  (
    1,
    10,
    '321',
    'Paraguay',
    'Paso Molino',
    'Montevideo',
    1
  ),
  (
    2,
    10,
    '654',
    'Bulevar España',
    'Brazo Oriental',
    'Montevideo',
    0
  ),
  (
    1,
    11,
    '987',
    'Colonia',
    'La Paloma',
    'Montevideo',
    1
  ),
  (
    2,
    11,
    '321',
    'Tacuarembó',
    'Tres Cruces',
    'Montevideo',
    0
  ),
  (
    1,
    12,
    '654',
    'Soriano',
    'Aires Puros',
    'Montevideo',
    1
  ),
  (
    2,
    12,
    '987',
    'Echevarriarza',
    'Casavalle',
    'Montevideo',
    0
  ),
  (
    1,
    13,
    '321',
    '8 de Octubre',
    'Sayago',
    'Montevideo',
    1
  ),
  (
    2,
    13,
    '654',
    'Maldonado',
    'Manga',
    'Montevideo',
    0
  ),
  (
    1,
    14,
    '987',
    'Miguelete',
    'Reducto',
    'Montevideo',
    1
  ),
  (
    2,
    14,
    '321',
    'Gral. Flores',
    'Tres Ombúes',
    'Montevideo',
    0
  ),
  (
    1,
    15,
    '654',
    'Ituzaingó',
    'Flor de Maroñas',
    'Montevideo',
    1
  ),
  (
    2,
    15,
    '987',
    'San Martin',
    'Peñarol',
    'Montevideo',
    0
  ),
  (
    1,
    16,
    '321',
    'Rambla Sur',
    'Buceo',
    'Montevideo',
    1
  ),
  (
    2,
    16,
    '654',
    'Espinosa',
    'Paso Molino',
    'Montevideo',
    0
  ),
  (
    1,
    17,
    '987',
    'Bulevar Artigas',
    'Cordón',
    'Montevideo',
    1
  ),
  (
    2,
    17,
    '321',
    '18 de Julio',
    'Centro',
    'Montevideo',
    0
  ),
  (
    1,
    18,
    '654',
    'Luis Alberto de Herrera',
    'Parque Rodó',
    'Montevideo',
    1
  ),
  (
    2,
    18,
    '987',
    'José L. Terra',
    'La Teja',
    'Montevideo',
    0
  ),
  (
    1,
    19,
    '321',
    'Yaguarón',
    'Jacinto Vera',
    'Montevideo',
    1
  ),
  (
    2,
    19,
    '654',
    'Avenida Italia',
    'La Comercial',
    'Montevideo',
    0
  ),
  (
    3,
    19,
    '987',
    'Rambla Sur',
    'Pocitos',
    'Montevideo',
    0
  );
INSERT INTO `favorito` (`menu_ID`, `web_ID`)
VALUES (1, 1),
  (3, 3);
INSERT INTO `asigna` (`paquete_ID`, `pedido_ID`)
VALUES (1, 32),
  (2, 32),
  (3, 32),
  (4, 32),
  (5, 32),
  (6, 33),
  (7, 33),
  (8, 34),
  (9, 34),
  (10, 34),
  (11, 34),
  (12, 35),
  (13, 36),
  (14, 36),
  (15, 36),
  (16, 36),
  (17, 37),
  (18, 37),
  (19, 37);
INSERT INTO `genera` (`menu_ID`, `paquete_ID`, `Fecha_de_creacion`)
VALUES (4, 12, '2023-12-24'),
  (5, 6, '2023-12-24'),
  (5, 7, '2023-12-24'),
  (6, 1, '2023-12-24'),
  (6, 17, '2023-12-24'),
  (6, 18, '2023-12-24'),
  (6, 19, '2023-12-24'),
  (7, 2, '2023-12-24'),
  (7, 3, '2023-12-24'),
  (7, 4, '2023-12-24'),
  (7, 5, '2023-12-24'),
  (8, 8, '2023-12-24'),
  (8, 9, '2023-12-24'),
  (8, 10, '2023-12-24'),
  (8, 11, '2023-12-24'),
  (8, 13, '2023-12-24'),
  (8, 14, '2023-12-24'),
  (8, 15, '2023-12-24'),
  (8, 16, '2023-12-24');
INSERT INTO `inicia` (`sesion_token`, `cliente_ID`)
VALUES ('def456uvw789012', 2),
  ('ghi789rst012345', 3),
  ('tIN5CoVoalC', 1),
  ('miAQx0oyuD', 4),
  ('172MqToWSPUWs', 7),
  ('6c9Fofk3jfk6', 10),
  ('dZ2uHEuD', 13),
  ('Zl58TbiadtovoA', 16),
  ('5Y4eRVbiAaRKlw', 19);
INSERT INTO `paquete_esta` (
    `estado_ID`,
    `paquete_ID`,
    `Inicio_del_estado`,
    `Final_del_estado`
  )
VALUES (1, 1, '2023-11-14 00:00:00', NULL),
  (1, 2, '2023-11-14 00:00:00', NULL),
  (1, 3, '2023-11-14 00:00:00', NULL),
  (1, 4, '2023-11-14 00:00:00', NULL),
  (1, 5, '2023-11-14 00:00:00', NULL),
  (1, 6, '2023-11-14 00:00:00', NULL),
  (1, 7, '2023-11-14 00:00:00', NULL),
  (1, 8, '2023-11-14 00:00:00', NULL),
  (1, 9, '2023-11-14 00:00:00', NULL),
  (1, 10, '2023-11-14 00:00:00', NULL),
  (1, 11, '2023-11-14 00:00:00', NULL),
  (1, 12, '2023-11-14 00:00:00', NULL),
  (1, 13, '2023-11-14 00:00:00', NULL),
  (1, 14, '2023-11-14 00:00:00', NULL),
  (1, 15, '2023-11-14 00:00:00', NULL),
  (1, 16, '2023-11-14 00:00:00', NULL),
  (1, 17, '2023-11-14 00:00:00', NULL),
  (1, 18, '2023-11-14 00:00:00', NULL),
  (1, 19, '2023-11-14 00:00:00', NULL);
INSERT INTO `pedido_esta` (
    `estado_ID`,
    `pedido_ID`,
    `Inicio_del_estado`,
    `Final_del_estado`
  )
VALUES (1, 32, '2023-11-12 01:48:39', NULL),
  (1, 33, '2023-11-12 01:53:42', NULL),
  (1, 34, '2023-11-12 01:53:44', NULL),
  (1, 35, '2023-11-12 01:53:46', NULL),
  (1, 36, '2023-11-12 01:53:48', NULL),
  (1, 37, '2023-11-12 01:53:50', NULL);
INSERT INTO `recibe` (`paquete_ID`, `cliente_ID`)
VALUES (1, 1),
  (2, 1),
  (3, 1),
  (4, 1),
  (5, 1),
  (6, 7),
  (7, 7),
  (8, 10),
  (9, 10),
  (10, 10),
  (11, 10),
  (12, 13),
  (13, 16),
  (14, 16),
  (15, 16),
  (16, 16),
  (17, 19),
  (18, 19),
  (19, 19);
INSERT INTO `stock` (`menu_ID`, `Minimo`, `Maximo`, `Actual`)
VALUES (1, 5, 20, 15),
  (2, 8, 25, 12),
  (3, 10, 30, 18),
  (4, 5, 20, 5),
  (5, 8, 25, 2),
  (6, 10, 30, 8),
  (7, 5, 20, 15),
  (8, 8, 25, 12);
INSERT INTO `tarjeta` (
    `Numero`,
    `Digitos_verificadores`,
    `Fecha_de_vencimiento`,
    `Nombre_de_titular`,
    `cliente_ID`
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
DROP TABLE IF EXISTS `cliente_simplificado`;
CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `cliente_simplificado` AS
SELECT `cliente`.`ID` AS `ID`,
  `cliente`.`Autorizacion` AS `Autorizacion`,
  `cliente`.`Email` AS `Email`
FROM `cliente`;
COMMIT;
-- Permisos de usuarios y roles
-- Elimino las vistas
DROP VIEW IF EXISTS cliente_simplificado;
DROP VIEW IF EXISTS Datos_de_cliente_web;
-- Creación de las vistas
CREATE VIEW cliente_simplificado AS
SELECT ID,
  Autorizacion,
  Email
FROM cliente;
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
CREATE USER 'gerente_1' @'localhost' IDENTIFIED BY '12345';
CREATE USER 'atencion_1' @'localhost' IDENTIFIED BY '12345';
CREATE USER 'admin_1' @'localhost' IDENTIFIED BY '12345';
CREATE USER 'jefe_de_cocina_1' @'localhost' IDENTIFIED BY '12345';
-- asignación de permisos a los roles (grupos)
-- Gerente
GRANT ALL PRIVILEGES ON sisviansa_techin_v1.* TO 'gerente_1' @'localhost';
-- Administración
GRANT ALL PRIVILEGES ON *.* TO 'admin_1' @'localhost';
-- Cocina (Jefe de cocina, ya que es el que 'Orquesta' el mambo)
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.vianda TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.conforma TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.vianda_dieta TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.menu TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.compone TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.pedido TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.stock TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.genera TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.asigna TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.paquete TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.paquete_esta TO 'jefe_de_cocina_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.recibe TO 'jefe_de_cocina_1' @'localhost';
GRANT ALL PRIVILEGES ON sisviansa_techin_v1.SISVIANSA_USER TO 'jefe_de_cocina_1' @'localhost';
-- Atención al publico
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.paquete TO 'atencion_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.pedido TO 'atencion_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.recibe TO 'atencion_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.cliente TO 'atencion_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.empresa TO 'atencion_1' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.web TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.stock TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.menu TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.vianda TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.conforma TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.cliente_simplificado TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.estado TO 'atencion_1' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.SISVIANSA_USER TO 'atencion_1' @'localhost';
-- Página 
GRANT SELECT,
  INSERT,
  UPDATE ON sisviansa_techin_v1.cliente TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON sisviansa_techin_v1.web TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT ON sisviansa_techin_v1.empresa TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON sisviansa_techin_v1.pedido TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE ON sisviansa_techin_v1.pedido_esta TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.cliente_telefono TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.inicia TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.tarjeta TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.pedido_esta TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.favorito TO Atencion;
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.compone TO Atencion;
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.menu TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.conforma TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.genera TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.asigna TO 'pagina' @'localhost';
GRANT SELECT,
  INSERT,
  UPDATE,
  DELETE ON sisviansa_techin_v1.stock TO 'pagina' @'localhost';
GRANT SELECT,
  DELETE ON sisviansa_techin_v1.paquete_esta TO 'pagina' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.vianda TO 'pagina' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.vianda_dieta TO 'pagina' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.estado TO 'pagina' @'localhost';
GRANT SELECT ON sisviansa_techin_v1.paquete TO 'pagina' @'localhost';
FLUSH PRIVILEGES;
-- Ingreso los usuarios a la tabla para hacerles seguimiento
INSERT INTO `SISVIANSA_USER` (`NOMBRE`, `ROL`)
VALUES ('gerente_1', 'Gerente'),
  ('atencion_1', 'Atencion'),
  ('jefe_de_cocina_1', 'Jefe_de_cocina');