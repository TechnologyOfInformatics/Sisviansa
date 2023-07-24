<?php
include_once "Data/database_model.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
function datatype($var, $type)
{
    return gettype($var) === $type;
}

function session_close($ctl, $token)
{
    if (isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!datatype($token, "string")) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (strlen($token) >= 15 || strlen($token) < 8) {
        return "400, BAD REQUEST: Wrong data type";
    }


    $ctl->delete("inicia", "$token", "sesion_token");
    $ctl->update("sesion", [$token, "Finalizada"], ["token"], ["token", "estado"])->call();
    return [False];
}

function token_generator()
{
    $allowedCharacters = '0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
    $textLength = rand(8, 15);
    $randomText = '';

    for ($i = 0; $i < $textLength; $i++) {
        $randomText .= $allowedCharacters[rand(0, strlen($allowedCharacters) - 1)];
    }

    return $randomText;
}

function session($ctl, $token)
{
    if (isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!datatype($token, "string")) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (strlen($token) >= 15 || strlen($token) < 8) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $query = "SELECT sesion.final_de_sesion,
                sesion.estado,
                web.primer_nombre, 
                web.primer_apellido
                FROM inicia
                JOIN sesion ON inicia.sesion_token = sesion.token
                JOIN web ON inicia.cliente_id = web.cliente_id
                WHERE inicia.sesion_token = '$token';
            ";

    $response = $ctl->setQuery($query)->call();

    if (!datatype($response, "array") & count($response) > 0) {

        return "500, INTERNAL SERVER ERROR: $response";
    } else {

        $actualDate = date('Y-m-d H:i:s');

        $dbDate = $response[0];

        if ($actualDate <= $dbDate) {
            $newDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

            $ctl->update("sesion", [$token, $actualDate, $newDate], ["token"], ["token", "ultima_sesion", "final_de_sesion"])->call();
            return [True, $response[2], $response[3]];
        } else {

            return session_close($ctl, $token);
        }
    }
}



function register_web_first($ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password)
{
    $values = func_get_args();

    unset($values[0]);

    $length_verificator = True;

    $maximum = [30, 30, 20, 11, 40, 40];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $length_verificator = $length_verificator && (strlen(strval($password)) >= 6) && (strlen(strval($mail) >= 6));

    unset($values[4]);

   $type_verificator = True;
foreach ($values as $var) {
    $type_verificator = $type_verificator && is_string($var);
}
$type_verificator = $type_verificator && is_int($doc);

    if (isset($ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif ($type_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $existence_verificator_doc = empty($ctl->select("web", ["cliente_id"], [$doc_type, $doc], ["tipo", "numero"])->call());
    $existence_verificator_mail = empty($ctl->select("cliente", ["email"], [$mail], ["email"])->call());

    if ($existence_verificator_doc) {
        return "409, CONFLICT: This client already exists";
    } else if ($existence_verificator_mail) {
        return "409, CONFLICT: This Email is already in use";
    }

    if ($ctl->insert("cliente", [$mail, $password], ["email", "contrasenia"])->call() === ["OK", 200]) {
        $id = $ctl->select("cliente", ["id"], [$mail], ["email"])->call();
        return $ctl->insert("web", [$id[0], $first_name, $first_surname, $doc_type, $doc, "En espera"], ["cliente_id", "primer_nombre", "primer_apellido", "tipo", "numero", "autorizacion"])->call();
    }
}

function register_web_second($ctl, $token, $second_name, $second_surname, $street, $neighborhood, $city)
{
    $values = func_get_args();

    unset($values[0]);

    $length_verificator = True;

    foreach ($values as $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= 30) && (strlen(strval($var)) >= 2);
    }

    $type_verificator = True;

    foreach ($values as $var) {
        $type_verificator = $type_verificator && datatype($var, "string");
    }

    if (isset($ctl, $second_name, $second_surname, $street, $neighborhood, $city)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif ($type_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $user = session($ctl, $token);
    $id = $ctl->select("inicia", ["cliente_id"], [$token], ["sesion_token"])[0];
    if ($user[0]) {
        return $ctl->update("web", [$id, $second_name, $second_surname], ["cliente_id"], ["cliente_id", "segundo_nombre", "segundo_apellido"])->call();
    } else {
        return "401, UNAUTHORIZED: The session expired";
    }
}


function login($ctl, $mail, $passwd, $token = "")
{
    $values = func_get_args();

    unset($values[0]);
    unset($values[3]);
    $length_verificator = true;

    foreach ($values as $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= 30) && (strlen(strval($var)) >= 2);
    }


    $type_verificator = is_string($mail) && is_string($passwd);


if (!isset($ctl, $mail, $passwd)) {
    return "400 Bad Request: Wrong data type";
} elseif (!$type_verificator) {
    return "400 Bad Request: Wrong data wtype";
} elseif (!$length_verificator) {
    return "400 Bad Request: Wrong data length";
} elseif (!isset($token) || strlen($token) < 8 || strlen($token) >= 15) {
    return "400, BAD REQUEST: Wrong data type";
}

    if ($token) {
        session_close($ctl, $token);
    }
    $new_token = token_generator();

    $query = "SELECT cliente.id, web.primer_nombre, web.primer_apellido
    FROM cliente 
    JOIN web  ON cliente.id = web.cliente_id
    WHERE cliente.email = '$mail' AND cliente.contrasenia = '$passwd'";

    $response = $ctl->setQuery($query)->call();
    if ($response && count($response) === 3) {
        $id = $response[0];
        $actual_session = date('Y-m-d H:i:s');


        $last_session = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

        $ctl->insert("sesion", [$new_token, $actual_session, $last_session, $last_session, "En espera"],  ["token", "inicio_de_sesion", "ultima_sesion", "final_de_sesion", "estado"])->call();
        $ctl->insert("inicia", [$new_token, $id],  ["token", "cliente_id"])->call();
        return [True, $response[1], $response[2]];
    } else {
        return "404, NOT FOUND: The user wasn't found";
    }
}

function show_shop($ctl, $token = "")
{
    if (isset($ctl,  $token)) {
        return "400 Bad Request: Wrong data type";
    } elseif (strlen($token) < 8 || strlen($token) >= 15) {
        return "400, BAD REQUEST: Wrong data type";
    }
    $favorites = [];
    if ($token) {
        $is_session = session($ctl, $token);
        if (datatype($is_session, "array") && $is_session[0]) {
            $id = $ctl->select("inicia", ["id"], [$token], ["sesion_token"])->call();
            $favorites = $ctl->select("favorito", ["menu_id"], [$id], ["web_id"]);
        }
        $menus = $ctl->setQuery("SELECT * FROM menu")->call();
        $foods = [];

        foreach ($menus as $menu) {
            $id = $ctl->select("conforma", ["vianda_id"], [$menu[0]], ["menu_id"])->call();
            array_push($menu, $ctl->setQuery("SELECT vianda.nombre, vianda_dieta.dieta
            FROM vianda
            JOIN vianda_dieta ON vianda.id = vianda_dieta.vianda_id
            WHERE vianda.id = '$id'")->call());
        }
        foreach ($menus as $menu) {
            if (!is_array($menu) || count($menu) !== 7) {
                return "400 Bad Request: El formato del menú no es válido.";
            }

            if (!is_int($menu[0]) || !is_string($menu[1]) || !is_int($menu[2]) || !is_string($menu[3]) || !is_string($menu[4]) || !is_float($menu[5]) || !is_array($menu[6]) || count($menu[6]) !== 2 || !is_string($menu[6][0]) || !is_string($menu[6][1])) {
                return "400 Bad Request: El formato del menú no es válido.";
            }
        }
        return [$menus, $favorites];
        ## menues = [[menu=>id, nombre, calorias, frecuencia,descripcion, precio, [nombre_vianda, dieta_vianda]], [[]]]
    }
}
