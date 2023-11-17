<?php

$servername = "sisviansa_mariadb";
$port = 3306;
$username = "root";
$password = "12345";
$database = "sisviansa_techin_v1";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $database, $port);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

echo "Conexión exitosa!";

// Cerrar la conexión
$conn->close();
