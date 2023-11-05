<?php
#include_once "php:9000/Auth\authorization.php";

header("Access-Control-Allow-Origin: http://localhost:9000");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Origin, Authorization, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Credentials: true");


$host = "laravue_mariadb"; // Nombre del contenedor de MariaDB
$port = 3306; // Puerto de MySQL
$username = "root"; // Nombre de usuario de MySQL
$password = "12345"; // Contraseña de MySQL
$database = "sys"; // Nombre de la base de datos que deseas utilizar

// Intenta conectar a la base de datos
$mysqli = new mysqli($host, $username, $password, $database, $port);

// Verifica la conexión
if ($mysqli->connect_error) {
    die("Error de conexión: " . $mysqli->connect_error);
}
// Consulta para obtener la lista de tablas
$query = "SHOW TABLES";

// Ejecuta la consulta
$result = $mysqli->query($query);

// Verifica si la consulta se ejecutó correctamente
if ($result) {
    echo "Lista de tablas en la base de datos '$database':<br>";

    // Recorre el resultado y muestra el nombre de cada tabla
    while ($row = $result->fetch_row()) {
        echo $row[0] . "<br>";
    }

    // Libera el resultado
    $result->free_result();
} else {
    echo "Error en la consulta: " . $mysqli->error;
}
echo "Conexión exitosa a la base de datos MariaDB desde el contenedor de PHP.";

// Cierra la conexión
$mysqli->close();















#WORK IN PROGRESS
/*
$ctl = new QueryCall("laravue_mariadb", "root", "12345", "prueba", 3306);
$base = __FILE__;

function fast_verification_doc($doc_type, $doc)
{
    global $ctl;
    return [empty($ctl->select("web", ["numero"], [$doc_type, $doc], ["tipo", "numero"])->call())];
}

function fast_verification_mail($mail)
{
    global $ctl;
    return [empty($ctl->select("web", ["correo"], [$mail], ["correo"])->call())];
}

function base_session($token)
{
    global $ctl;
    return session($ctl, $token);
}

function base_session_close($token)
{
    global $ctl;
    return session_close($ctl, $token);
}
*/


/*EJEMPLOS:

Usando el formato para select:
    print_r($ctl->insert("tabla", ["algo loqúisimo"], ["algo"])->call());

    print_r($ctl->select("tabla", [2], ["id"], ["id", "algo"])->call());
        Resumen: (α∈D): ∀ δ, n = δ -> ∀ δ[n] ∃ γ[n]

    print_r($ctl->update("tabla", [1, "algo cambiado"], ["id"], ["id", "algo"])->call());

    print_r($ctl->delete("tabla", [2], ["id"])->call());

    print_r($ctl->setQuery("SELECT * FROM tabla WHERE id>2")->call());

*/