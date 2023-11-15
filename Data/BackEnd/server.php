<?php
header("Access-Control-Allow-Origin: http://localhost:8081");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");
require_once("Model/base.php");
require_once("Model/index.php");
require_once("Model/login.php");
require_once("Model/menu.php");
require_once("Model/register.php");
require_once("Model/shop.php");
require_once("Model/options.php");
require_once("Model/admin.php");


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Verifica si se envió el nombre de la función que deseas llamar desde Vue.js
    if (isset($_POST['functionName'])) {
        // Obtiene el nombre de la función desde la solicitud
        $functionName = $_POST['functionName'];

        // Elimina la clave functionName del array para que quede solo con los parámetros
        unset($_POST['functionName']);

        // Verifica si la función existe
        if (function_exists($functionName)) {
            // Llama a la función con los parámetros recibidos
            $result = call_user_func_array($functionName, array_values($_POST));

            // Devuelve el resultado como respuesta en formato JSON
            echo json_encode($result);
        } else {
            // Si la función no existe, devuelve un error
            echo json_encode(['error' => 'La función no existe']);
        }
    } else {
        // Si no se envió el nombre de la función, devuelve un error
        echo json_encode(['error' => 'Nombre de función no proporcionado']);
    }
}
