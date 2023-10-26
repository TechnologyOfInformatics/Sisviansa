<?php
include_once "Model/base.php";
include_once "Model/index.php";
include_once "Model/login.php";
include_once "Model/menu.php";
include_once "Model/register.php";
include_once "Model/shop.php";
include_once "Model/options.php";
include_once "Model/admin.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

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
