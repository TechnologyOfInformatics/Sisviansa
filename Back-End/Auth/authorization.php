<?php

require_once("Data/database_model.php");
require_once("Data/ORM-V1.php");

$authorization = __FILE__;

function order_diets($menus, $target_diet, $order = 'ASC')
{
    //Ordena los menus segun una dieta dada, solo se me ocurrio como hacerla implementandola como una funcion
    usort($menus, function ($a, $b) use ($target_diet, $order) {
        $has_diet_one = in_array($target_diet, $a['dietas']);
        $has_diet_two = in_array($target_diet, $b['dietas']);

        if ($order === 'ASC') {
            if ($has_diet_one && !$has_diet_two) {
                return -1;
            } elseif (!$has_diet_one && $has_diet_two) {
                return 1;
            }
        } else {
            if ($has_diet_one && !$has_diet_two) {
                return 1;
            } elseif (!$has_diet_one && $has_diet_two) {
                return -1;
            }
        }

        return 0; // Mantén el orden actual si ambos menús tienen o no la dieta
    });

    return $menus;
}

function token_generator()
{
    $allowedCharacters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $textLength = rand(8, 14);
    $randomText = '';

    for ($i = 0; $i < $textLength; $i++) {
        $randomText .= $allowedCharacters[rand(0, strlen($allowedCharacters) - 1)];
    }

    return $randomText;
}

function get_client_id(TORM $tORM, String $token)
{

    if ($token) {
        $client = $tORM
            ->from("inicia")
            ->columns("inicia.cliente_id")
            ->where("inicia.sesion_token", "eq", $token)
            ->join("sesion", "sesion.token", "inicia.sesion_token")
            ->joined_columns("None column")
            ->where("sesion.estado", "eq", "Activa")
            ->do("select");

        return $client;
    }
    return [];
}

function session_token(TORM $tORM, String $token)
{

    $actual_date = date('Y-m-d H:i:s');

    $client = $tORM
        ->from("inicia")
        ->columns("inicia.cliente_id")
        ->where("inicia.sesion_token", "eq", $token)
        ->join("sesion", "sesion.token", "inicia.sesion_token")
        ->joined_columns("sesion.final_de_sesion")
        ->where("sesion.estado", "eq", "Activa")
        ->do("select");
    $new_date = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

    if (empty($client)) {
        //Camino de que no se encontro la sesion/cliente
        return $client;
    } elseif ($client[0]["final_de_sesion"] <= $actual_date) {
        //Camino que genera otra sesion cuando la actual esta vencida
        $new_token = token_generator();

        $tORM
            ->from("sesion")
            ->columns("sesion.estado")
            ->values("sesion", "Finalizada")
            ->where("sesion.token", "eq", $token)
            ->do("update");

        $tORM
            ->from("sesion")
            ->columns("sesion.token", "sesion.inicio_de_sesion", "sesion.ultima_sesion", "sesion.final_de_sesion", "sesion.estado")
            ->values("sesion", $new_token, $actual_date, $actual_date, $new_date, "Activa")
            ->do("insert");

        $tORM
            ->from("inicia")
            ->where("inicia.sesion_token", "eq", $token)
            ->do("delete");

        $tORM
            ->from("inicia")
            ->columns("inicia.sesion_token", "inicia.cliente_id")
            ->values("inicia", $new_token, intval($client[0]["cliente_id"]))
            ->do("insert");

        return [["cliente_id" => $client[0]["cliente_id"], "token" => $new_token]];
    } elseif ($client[0]["final_de_sesion"] > $actual_date) {
        //Camino que actualiza la sesion para agregarle 15 minutos
        $tORM
            ->from("sesion")
            ->columns("sesion.final_de_sesion")
            ->values("sesion", $new_date)
            ->where("sesion.token", "eq", $token)
            ->do("update");


        $tORM
            ->from("sesion")
            ->columns("sesion.final_de_sesion", "sesion.ultima_sesion")
            ->values("sesion", $actual_date, $new_date)
            ->where("sesion.token", "eq", $token)
            ->do("update");

        return $client;
    }
}

function session_close(QueryCall $ctl, $token)
{
    if (!isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!(gettype($token) == "string")) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (strlen($token) >= 15 || strlen($token) < 8) {
        return "400, BAD REQUEST: Wrong data type";
    }


    $ctl->delete("inicia", ["$token"], ["sesion_token"])->call();
    $ctl->update("sesion", [$token, "Finalizada"], ["token"], ["token", "estado"])->call();
    return [False];
}

function session(QueryCall $ctl, $token)
{
    if (!isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!is_string($token) || strlen($token) >= 15 || strlen($token) < 8) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $is_session_active = $ctl->select("sesion", ["estado"], [$token], ["token"])->call();

    if (!is_array($is_session_active) || count($is_session_active) === 0 || is_string($is_session_active)) {
        return "404, NOT FOUND: The given TOKEN doesn't exist";
    } elseif ($is_session_active[0] === "Activa") {

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
        if (is_string($response)) {
            return "404, NOT FOUND: The given TOKEN doesn't exist";
        } else {
            if (!$response) {
                $query = "SELECT sesion.final_de_sesion,
                sesion.estado,
                empresa.nombre
                FROM inicia
                JOIN sesion ON inicia.sesion_token = sesion.token
                JOIN empresa ON inicia.cliente_id = empresa.cliente_id
                WHERE inicia.sesion_token = '$token';
            ";

                $response = $ctl->setQuery($query)->call();

                $actualDate = date('Y-m-d H:i:s');

                $dbDate = $response[0];

                if ($actualDate <= $dbDate) {
                    $newDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

                    $ctl->update("sesion", [$token, $actualDate, $newDate], ["token"], ["token", "ultima_sesion", "final_de_sesion"])->call();

                    return [True, $response[2]];
                } else if ($actualDate > $dbDate) {

                    return session_close($ctl, $token);
                }
            }

            $actualDate = date('Y-m-d H:i:s');

            $dbDate = $response[0];

            if ($actualDate <= $dbDate) {
                $newDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

                $ctl->update("sesion", [$token, $actualDate, $newDate], ["token"], ["token", "ultima_sesion", "final_de_sesion"])->call();
                return [False, $response[2], $response[3]];
            } else if ($actualDate > $dbDate) {

                return session_close($ctl, $token);
            }
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function login(QueryCall $ctl, $mail, $passwd, String $token = "")
{
    $values = func_get_args();

    unset($values[0]);
    unset($values[3]);
    $length_verificator = true;

    foreach ($values as $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= 30) && (strlen(strval($var)) >= 5);
    }

    $type_verificator = true;

    foreach ($values as $var) {
        $type_verificator = $type_verificator && is_string($var);
    }

    if (!isset($ctl, $mail, $passwd)) {
        return "400 Bad Request: Missing data";
    } elseif (!$type_verificator) {
        return "400 Bad Request: Wrong data type";
    } elseif (!$length_verificator) {
        return "400 Bad Request: Wrong data length";
    }

    if (!empty($token)) {
        session_close($ctl, $token);
    }
    $new_token = token_generator();


    $passwd = md5($passwd);

    $query = "SELECT cliente.id, web.primer_nombre, web.primer_apellido, cliente.autorizacion
    FROM cliente 
    JOIN web  ON cliente.id = web.cliente_id
    WHERE cliente.email = '$mail' AND cliente.contrasenia = '$passwd'";

    $response = $ctl->setQuery($query)->call();

    if ($response && count($response) === 4) {
        $id = $response[0];
        $auth = $response[3];

        if ($auth === "Autorizado") {
            $actual_session = date('Y-m-d H:i:s');

            $query = "UPDATE sesion
        JOIN inicia ON sesion.token = inicia.sesion_token
        SET sesion.estado = 'Finalizada'
        WHERE inicia.cliente_id = $response[0];";
            $ctl->setQuery($query)->call();

            $query = "DELETE
        FROM inicia WHERE inicia.cliente_id = $response[0]";
            $ctl->setQuery($query)->call();

            $last_session = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

            $ctl->insert("sesion", [$new_token, $actual_session, $last_session, $last_session, "Activa"], ["token", "inicio_de_sesion", "ultima_sesion", "final_de_sesion", "estado"])->call();
            $ctl->insert("inicia", [$new_token, $id], ["sesion_token", "cliente_id"])->call();
            return [False, $new_token, $response[1], $response[2]];
        } else {
            return "403, FORBIDDEN: You are not allowed to enter the system";
        }
    } else { //Empresa

        $query = "SELECT cliente.id, empresa.nombre, cliente.autorizacion
        FROM cliente 
        JOIN empresa  ON cliente.id = empresa.cliente_id
        WHERE cliente.email = '$mail' AND cliente.contrasenia = '$passwd'";
        $response = $ctl->setQuery($query)->call();
        if ($response && count($response) === 3) {
            $id = $response[0];
            $auth = $response[2];

            if ($auth === "Autorizado") {
                $actual_session = date('Y-m-d H:i:s');

                $query = "UPDATE sesion
            JOIN inicia ON sesion.token = inicia.sesion_token
            SET sesion.estado = 'Finalizada'
            WHERE inicia.cliente_id = $response[0];";
                $ctl->setQuery($query)->call();

                $query = "DELETE
            FROM inicia WHERE inicia.cliente_id = $response[0]";
                $ctl->setQuery($query)->call();

                $last_session = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

                $ctl->insert("sesion", [$new_token, $actual_session, $last_session, $last_session, "Activa"], ["token", "inicio_de_sesion", "ultima_sesion", "final_de_sesion", "estado"])->call();
                $ctl->insert("inicia", [$new_token, $id], ["sesion_token", "cliente_id"])->call();
                return [True, $new_token, $response[1]];
            } else {
                return "403, FORBIDDEN: You are not allowed to enter the system";
            }
        } else {
            return "404, NOT FOUND: The user wasn't found";
        }
    }
}
function register_web(QueryCall $ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password)
{
    $values = func_get_args();

    unset($values[0]);

    $regex = '/\b' . preg_quote(strtolower($first_name), '/') . '\b/';

    $name_match = preg_match($regex, strtolower($password)) || (strtolower(strval($password)) == strtolower(strval($first_name)));

    $passwd_verificator = !preg_match('/^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).+$/', $password); //True si no hay ni caracteres especiales ni letras ni numeros


    if ($name_match || $passwd_verificator) {
        return 'ERROR 400, BAD REQUEST: Password error';
    }

    $length_verificator = True;

    $maximum = [30, 30, 20, 11, 40, 40];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index - 1]);
    }

    $length_verificator = strlen($password) > 6 && strlen($mail) > 6 && $length_verificator;


    $type_verificator = True;

    foreach ($values as $var) {
        $type_verificator = $type_verificator && is_string($var);
    }

    if (!isset($ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password)) {
        return "400, BAD REQUEST: Missing data";
    } elseif (!$type_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!(strpos($mail, "@") && strpos($mail, "."))) {
        return "400, BAD REQUEST: Wrong data structure";
    }

    $existence_verificator_doc = empty($ctl->select("web", ["cliente_id"], [$doc_type, $doc], ["documento_tipo", "documento_numero"])->call());
    $existence_verificator_mail = empty($ctl->select("cliente", ["email"], [$mail], ["email"])->call());

    if (!$existence_verificator_doc) {
        return "409, CONFLICT: This client already exists";
    } else if (!$existence_verificator_mail) {
        return "409, CONFLICT: This Email is already in use";
    }

    if ($ctl->insert("cliente", [$mail, md5($password), "En espera"], ["email", "contrasenia", "autorizacion"])->call() === ["OK", 200]) {
        $id = $ctl->select("cliente", ["id"], [$mail], ["email"])->call();
        $ctl->insert("web", [$id[0], $first_name, $first_surname, $doc_type, $doc], ["cliente_id", "primer_nombre", "primer_apellido", "documento_tipo", "documento_numero"])->call();
        $response = login($ctl, $mail, $password, "");
        return $response;
    }
}
function modify_web(TORM $tORM, String $token, $first_name = "", $second_name = "", $first_surname = "", $second_surname = "", $mail = "")
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 20, 25];


    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (strpos($mail, "@") && strpos($mail, ".")) {
        return "400, BAD REQUEST: Wrong data structure";
    }
    $client_id = get_client_id($tORM, $token);

    if ($client_id && $length_verificator) {

        $web_values = $tORM
            ->from("web")
            ->columns("web.primer_nombre", "web.primer_apellido", "web.segundo_nombre", "web.segundo_apellido")
            ->where("web.cliente_id", "eq", intval($client_id[0]["cliente_id"]))
            ->do("select")[0];

        $client_values = $tORM
            ->from("cliente")
            ->columns("cliente.contrasenia", "cliente.email")
            ->where("cliente.id", "eq", intval($client_id[0]["cliente_id"]))
            ->do("select")[0];
        $received_data = array_merge($web_values, $client_values);

        $new_web_data = [
            'web.primer_nombre' => $first_name ? $first_name : $received_data["primer_nombre"],
            'web.segundo_nombre' => $second_name ? $second_name : $received_data["segundo_nombre"],
            'web.primer_apellido' => $first_surname ? $first_surname : $received_data["primer_apellido"],
            'web.segundo_apellido' => $second_surname ? $second_surname : $received_data["segundo_apellido"],
        ];

        $result_1 = $tORM
            ->from("cliente")
            ->columns('cliente.email')
            ->values('cliente', $mail ? $mail : $received_data["email"])
            ->where("cliente.id", "eq", intval($client_id[0]["cliente_id"]))
            ->do("update");
        //
        //
        //

        $new_web_values = array_merge(["web"], array_values($new_web_data));
        $object = $tORM
            ->from("web");

        $object = call_user_func_array(array($object, "columns"), array_keys($new_web_data));
        $object = call_user_func_array(array($object, "values"), $new_web_values);

        $result_2 = $object
            ->where("web.cliente_id", "eq", $client_id[0]["cliente_id"])
            ->do("update");

        if ($result_1 == $result_2 && $result_1 == "OK, 200") {
            return "OK, 200";
        }
        return "ERROR 500, SERVER ERROR";
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function get_address(TORM $tORM, String $token)
{


    $length_verificator = (strlen(strval($token)) <= 15);


    $client_id = get_client_id($tORM, $token);

    if ($client_id && $length_verificator) {
        $address_values = $tORM
            ->from("direccion")
            ->columns('direccion.id', 'direccion.direccion', 'direccion.calle', 'direccion.barrio', 'direccion.ciudad', 'direccion.predeterminado')
            ->where("direccion.cliente_id", "eq", intval($client_id[0]['cliente_id']))
            ->do('select');
        return $address_values;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function user_information_web(TORM $tORM, $token)
{
    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $result = $tORM
        ->from("cliente")
        ->columns("None column")
        ->join("inicia", "inicia.cliente_id", "cliente.id")
        ->joined_columns("None column")
        ->where("inicia.sesion_token", "eq", $token)
        ->join("web", "web.cliente_id", "cliente.id")
        ->joined_columns('web.primer_nombre', 'web.primer_apellido', 'web.segundo_nombre', 'web.segundo_apellido', 'web.documento_numero', 'web.documento_tipo')
        ->join("cliente_simplificado", "cliente_simplificado.id", "web.cliente_id")
        ->joined_columns('cliente_simplificado.email')
        //
        //
        ->do("select");



    $client_id = get_client_id($tORM, $token);

    if ($result && $client_id) {
        $result = $result[0];
        $because_i_used_numero_twice = $tORM // Debo pedir los datos de direccion de su respectiva tabla
            ->from('direccion')
            ->where('direccion.cliente_id', 'eq', $client_id[0]["cliente_id"])
            ->do('select');
        $formatted_result = [
            'primerNombre' => $result['primer_nombre'],
            'primerApellido' => $result['primer_apellido'],
            'segundoNombre' => $result['segundo_nombre'],
            'segundoApellido' => $result['segundo_apellido'],
            'correo' => $result['email'],
            'direccion' => $because_i_used_numero_twice,
            'documento' => $result['documento_numero'],
            'tipoDocumento' => $result['documento_tipo'],

        ];
        return $formatted_result;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function set_address(TORM $tORM, String $token, String $city, String $neighborhood, String $street, String $address)
{
    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 30];


    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    if (in_array('', array($values))) {
        return 'ERROR 400, BAD REQUEST';
    }

    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $address_id = $tORM
            ->do(query: "SELECT MAX(id) FROM direccion WHERE cliente_id = {$client_id[0]['cliente_id']}")[0];
        $address_id = intval(!empty($address_id[0]) ? $address_id[0] + 1 : 1);

        if ($address_id <= 3) {
            $response = $tORM
                ->from("direccion")
                ->columns("direccion.id", 'direccion.cliente_id', 'direccion.direccion', 'direccion.calle', 'direccion.ciudad')
                ->values('direccion', intval($address_id), intval($client_id[0]['cliente_id']), $address, $street, $city)
                ->do('insert');

            if ($neighborhood && ($response == "OK, 200")) {
                $tORM
                    ->from("direccion")
                    ->columns('direccion.barrio')
                    ->values('direccion', $neighborhood)
                    ->where("direccion.id", "eq", intval($address_id))
                    ->where("direccion.cliente_id", "eq", intval($client_id[0]['cliente_id']))
                    ->do('update');
            }
            toggle_default($tORM, $token, intval($address_id));
            return $response;
        } else {
            return "ERROR 429, TOO MANY REQUESTS";
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function modify_address(TORM $tORM, String $token, Int $address_id, String $city = "", String $neighborhood = "", String $street = "", String $address = "")
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 1, 30, 30, 30, 30];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        if (($address_id <= 3)) {
            $actual_address = $tORM
                ->from("direccion")
                ->where("direccion.id", "eq", $address_id)
                ->where("direccion.cliente_id", "eq", $client_id[0]['cliente_id'])
                ->do("select")[0];
            $response = $tORM
                ->from("direccion")
                ->columns('direccion.direccion', 'direccion.calle', 'direccion.barrio', 'direccion.ciudad')
                ->values('direccion', ($address ? $address : $actual_address['direccion']), ($street ? $street : $actual_address['calle']), ($neighborhood ? $neighborhood : $actual_address['barrio']), ($city ? $city : $actual_address['ciudad']))
                ->where('direccion.id', 'eq', $address_id)
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do('update');
            return $response;
        } else {
            return "ERROR 429, TOO MANY REQUESTS";
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function toggle_default(TORM $tORM, String $token, Int $address_id)
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 1];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $state = $tORM
            ->do(query: "SELECT predeterminado FROM direccion WHERE cliente_id = {$client_id[0]['cliente_id']} AND id = {$address_id}");

        if (($address_id <= 3) && isset($state[0][0])) {
            $response = $tORM
                ->from("direccion")
                ->columns('direccion.predeterminado')
                ->values('direccion', 0)
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do('update');
            $response = $tORM
                ->from("direccion")
                ->columns('direccion.predeterminado')
                ->values('direccion', ($state[0][0] ? 0 : 1))
                ->where('direccion.id', 'eq', $address_id)
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do('update');
            if ($response == "OK, 200") {
                return (get_address($tORM, $token));
            }
            return $response;
        } else {
            return "ERROR 404, NOT FOUND";
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function delete_address(TORM $tORM, String $token, Int $address_id)
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 1];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $client_id = get_client_id($tORM, $token);
    if ($client_id) {

        $actual_addresses = $tORM
            ->from('direccion')
            ->where('direccion.id', "eq", $address_id)
            ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
            ->do("select");

        if ($actual_addresses) {
            $response = $tORM
                ->from("direccion")
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->where('direccion.id', 'eq', $actual_addresses[0]['id'])
                ->do('delete');

            $actual_addresses = $tORM
                ->from('direccion')
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do("select");
            $response = $tORM
                ->from("direccion")
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do('delete');
            foreach ($actual_addresses as $key => $address) {
                $response = $tORM
                    ->from("direccion")
                    ->columns("direccion.id", 'direccion.cliente_id', 'direccion.direccion', 'direccion.calle', 'direccion.ciudad', 'direccion.predeterminado')
                    ->values('direccion', (intval($key) + 1), intval($address['cliente_id']), $address['direccion'], $address['calle'], $address['ciudad'], intval($address['predeterminado']))
                    ->do('insert');
                if ($address['barrio']) {
                    $tORM
                        ->from('direccion')
                        ->columns('direccion.barrio')
                        ->values('direccion', $address['barrio'])
                        ->where('direccion.id', 'eq', (intval($key) + 1))
                        ->where('direccion.cliente_id', 'eq', intval($address['cliente_id']))
                        ->do('update');
                }
            }
        } else {
            return "ERROR 404, NOT FOUND";
        }
        return $response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function show_shop(TORM $tORM, String $token = '', array $order = [])
{
    //Aqui tome otro "approach" al asunto de las sesiones, donde cree una forma diferente para chequerar que las sesion exista
    if ($token && ((strlen($token) < 15) && (strlen($token) >= 8))) {
        $is_session = $tORM
            ->from("sesion")
            ->columns("sesion.token")
            ->where("sesion.token", "eq", $token)
            ->where("sesion.estado", "eq", "Activa")
            ->do("select");
    } else {
        $is_session = False;
    }

    $client_id = get_client_id($tORM, $token);

    $favorites = [];

    if (!empty($token) && $is_session) {
        if ((strlen($token) < 8 || strlen($token) >= 15)) {
            return "400, BAD REQUEST: Wrong data length";
        } elseif ($client_id) {
            $favorites = $tORM
                ->from("favorito")
                ->columns('favorito.menu_id')
                ->where("favorito.web_id", "eq", $client_id[0]["cliente_id"])
                ->join("menu", "menu.id", "favorito.menu_id")
                ->joined_columns("None column")
                ->where("menu.categoria", "eq", "Estandar")
                ->do("select");
        }
    }

    $order_column = '';
    if ($order) {
        $comparition_array = ['order_by_name' => 'nombre', 'order_by_date' => 'id'];
        if (isset($comparition_array[$order[0]])) {
            $order_column = $comparition_array[$order[0]];
        }
    }
    if ($order_column && in_array($order[1], ['ASC', 'DESC'])) {
        $menus = $tORM
            ->from("menu")
            ->order('menu.' . $order_column, $order[1]) //nombre/id, ASC/DESC
            ->do("select");
    } else {
        $menus = $tORM
            ->from("menu")
            ->do("select");
    }

    $foods = $tORM
        ->from("vianda")
        ->do("select");

    $relation = $tORM
        ->from("conforma")
        ->columns("conforma.vianda_id", "conforma.menu_id")
        ->do("select");

    $diets = $tORM
        ->from("vianda_dieta")
        ->do("select");

    foreach ($diets as $diet) {
        foreach ($foods as $key => $food) {
            unset($foods[$key]['productos']);
            if ($food['id'] == $diet['vianda_id']) {
                $foods[$key]['dietas'][] = $diet['dieta'];
            }
        }
    }

    foreach ($foods as $food) {
        foreach ($menus as &$menu) {
            // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar
            if (in_array(['menu_id' => $menu['id'], 'vianda_id' => $food['id']], $relation)) {
                if (!isset($menu['viandas'])) {
                    $menu['viandas'] = [];
                }
                $menu['viandas'][] = $food;
            }
        }
    }

    $filtered_menus = array_filter($menus, function ($menu) {
        return $menu['categoria'] == 'Estandar';
    });

    $filtered_menus = array_values($filtered_menus);


    $diets = [];
    foreach ($filtered_menus as $key => &$menu) {
        $menu['dietas'] = [];
        foreach ($menu['viandas'] as $food) {
            if (isset($food['dietas'])) {
                foreach ($food['dietas'] as $diet) {
                    if (!in_array($diet, $menu['dietas'])) {
                        $menu['dietas'][] = $diet;
                        $diets[] = $diet;
                    }
                }
            }
        }
    }
    $regex_string = $order ? preg_grep('|' . strtolower($order[0]) . '|', array_map('strtolower', $diets)) : '';
    if (!empty($regex_string) && in_array($order[1], ['ASC', 'DESC'])) {
        //Aqui aplique varias cosas nuevas, array map es como lambda de python, recorre un array con una
        //funcion que usar para cada elemento y preg_grep es similar a in_array pero permite regular expressions
        $filtered_menus = order_diets($filtered_menus, ucfirst($regex_string[0]), $order[1]);
    }

    return [$filtered_menus, (((gettype($favorites) != 'array') || empty($client_id)) ? 'ERROR 404, NOT FOUND' : array_column($favorites, 'menu_id'))];
}

function toggle_favorites(TORM $tORM, String $token, Int $menu_id)
{
    // En caso de que no haya un token como el enviado se devolvera un array vacio

    $is_session = $tORM
        ->from("sesion")
        ->columns("sesion.token")
        ->where("sesion.token", "eq", $token)
        ->do("select");

    if (!isset($tORM, $token, $menu_id)) {
        return "400 Bad Request: Missing data";
    } elseif ($is_session) {

        if ((strlen($token) < 8 || strlen($token) >= 15)) {

            return "400, BAD REQUEST: Wrong data length";
        } else {
            $favorites = [];
            $client_id = get_client_id($tORM, $token);
            if ($client_id) {
                $favorites = $tORM
                    ->from("favorito")
                    ->where("favorito.web_id", "eq", $client_id[0]["cliente_id"])
                    ->where("favorito.menu_id", "eq", $menu_id)
                    ->join("menu", "menu.id", "favorito.menu_id")
                    ->joined_columns("None column")
                    ->where("menu.categoria", "eq", "Estandar")
                    ->do("select");
                $toggle_state = False;
            }
            if (!empty($favorites)) {

                $tORM
                    ->from("favorito")
                    ->where("favorito.menu_id", "eq", $menu_id)
                    ->where("favorito.web_id", "eq", $client_id[0]['cliente_id'])
                    ->do("delete");
                $toggle_state = False;
            } else {
                $tORM
                    ->from("favorito")
                    ->values("favorito", intval($menu_id), intval($client_id[0]['cliente_id']))
                    ->do("insert");
                $toggle_state = True;
            }

            return [$toggle_state, $menu_id];
        }
    } else {
        return $is_session;
    }
}
function buy_menu(TORM $tORM, $order_id, String $token, Int $amount, Int $menu_id)
{
    //Esta funcion debe crear una entrada en paquete y recibe, donde se le daran sus datos
    $client_id = get_client_id($tORM, $token);


    // Se ingresa un pedido
    if ($client_id) {

        $addresses = get_address($tORM, $token);
        $actual_date = date('Y-m-d H:i:s');
        $address = [];
        if (!$addresses) {
            die('ERROR 404, NOT FOUND');
        } else {
            for ($i = 0; $i < count($addresses); $i++) {
                if ($addresses[$i]['predeterminado']) {
                    $address = $addresses[$i];
                }
            }
        }

        if (strtolower($order_id) == "start") {
            $tORM
                ->from("pedido")
                ->columns("pedido.fecha_del_pedido", "pedido.cliente_id", "pedido.direccion", "pedido.calle", "pedido.barrio", "pedido.ciudad")
                ->values("pedido", $actual_date, intval($client_id[0]['cliente_id']), $address['direccion'], $address['calle'], $address['barrio'], $address['ciudad'])
                ->do("insert");

            $order_id = $tORM
                ->do(query: "SELECT MAX(id) FROM pedido WHERE Cliente_ID = {$client_id[0]['cliente_id']}")[0][0];
        }
        $is_state = $tORM
            ->from("pedido_esta")
            ->where("pedido_esta.pedido_id", "eq", intval($order_id))
            ->where("pedido_esta.estado_id", "eq", 1) // estado_id = 1 => "Solicitado"
            ->do("select");
        if (empty($is_state) || !($is_state)) {
            $tORM
                ->from("pedido_esta")
                ->columns("pedido_esta.estado_id", "pedido_esta.inicio_del_estado", "pedido_esta.pedido_id")
                ->values("pedido_esta", 1, intval($order_id), $actual_date)
                ->do("insert");
        }

        $tORM
            ->from("compone")
            ->columns("compone.pedido_id", "compone.menu_id", "compone.cantidad")
            ->values("compone", intval($order_id), intval($menu_id), intval($amount))
            ->do("insert");

        return $order_id;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}
function buy_multiple_menus(TORM $tORM, String $token, array $amounts, array $menus_ids)
{
    $response = 0;
    if ($token && (count($amounts) == count($menus_ids))) {
        for ($i = 0; $i < count($amounts); $i++) {
            if ($response) {
                $response = intval(buy_menu($tORM, $response, $token, intval($amounts[$i]), $menus_ids[$i]));
            } else {
                $response = intval(buy_menu($tORM, "Start", $token, intval($amounts[$i]), $menus_ids[$i]));
            }
        }
        return gettype($response) == "integer" ? "OK, 200" : "ERROR 500, SERVER ERROR";
    } else {
        return "ERROR 400, WRONG DATA TYPE";
    }
}

function get_fav_and_personal_menus(TORM $tORM, String $token)
{
    //Esta funcion devolvera tanto los menues personalizados como los menues con favoritos, pero no los estandar
    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        $menus_array = [];
        $menu_id = $tORM
            ->from("pedido")
            ->columns("None column")
            ->where("pedido.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->join("compone", "pedido.id", "compone.pedido_id")
            ->joined_columns("Compone.menu_id")
            ->do("select");


        foreach ($menu_id as $id) {
            $menu = $tORM
                ->from("menu")
                ->where("menu.categoria", "eq", "Personalizado")
                ->where("menu.id", "eq", $id["menu_id"])
                ->do("select");
            if ($menu) {
                $menus_array[] = $menu[0];
            }
        }

        $favorite_menu_id = $tORM
            ->from("favorito")
            ->columns("favorito.menu_id")
            ->where("favorito.web_id", "eq", $client_id[0]['cliente_id'])
            ->do("select");


        foreach ($favorite_menu_id as $id) {
            $menu = $tORM
                ->from("menu")
                ->where("menu.categoria", "eq", "Estandar")
                ->where("menu.id", "eq", $id["menu_id"])
                ->do("select");
            if ($menu) {
                $menus_array[] = $menu[0];
            }
        }

        $unique_menus = array();

        foreach ($menus_array as $menu) {
            $id = $menu['id'];
            if (!isset($unique_menus[$id])) {
                $unique_menus[$id] = $menu;
            }
        }

        $menus = array_values($unique_menus);

        $foods = $tORM
            ->from("vianda")
            ->do("select");

        $relation = $tORM
            ->from("conforma")
            ->columns("conforma.vianda_id", "conforma.menu_id")
            ->do("select");

        $diets = $tORM
            ->from("vianda_dieta")
            ->do("select");

        foreach ($diets as $diet) {
            foreach ($foods as $key => $food) {
                unset($foods[$key]['tiempo_de_coccion']);
                unset($foods[$key]['productos']);
                if ($food['id'] == $diet['vianda_id']) {
                    $foods[$key]['dietas'][] = $diet['dieta'];
                }
            }
        }
        foreach ($foods as $food) {
            foreach ($menus as &$menu) { // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar
                unset($menu['estado']);
                unset($menu['calorias']);

                if (in_array(['menu_id' => $menu['id'], 'vianda_id' => $food['id']], $relation)) {
                    if (!isset($menu['viandas'])) {
                        $menu['viandas'] = [];
                    }
                    $menu['viandas'][] = $food;
                }
            }
        }
        return $menus ? [$menus] : $menus;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}

function get_personal_menus(TORM $tORM, String $token)
{
    //Esta funcion devolvera tanto los menues personalizados como los menues con favoritos, pero no los estandar
    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        $menus_array = [];
        $menu_id = $tORM
            ->from("pedido")
            ->columns("None column")
            ->where("pedido.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->join("compone", "pedido.id", "compone.pedido_id")
            ->joined_columns("Compone.menu_id")
            ->do("select");


        foreach ($menu_id as $id) {
            $menu = $tORM
                ->from("menu")
                ->where("menu.categoria", "eq", "Personalizado")
                ->where("menu.id", "eq", $id["menu_id"])
                ->do("select");
            if ($menu) {
                $menus_array[] = $menu[0];
            }
        }


        $unique_menus = array();

        foreach ($menus_array as $menu) {
            $id = $menu['id'];
            if (!isset($unique_menus[$id])) {
                $unique_menus[$id] = $menu;
            }
        }

        $menus = array_values($unique_menus);

        $foods = $tORM
            ->from("vianda")
            ->do("select");

        $relation = $tORM
            ->from("conforma")
            ->columns("conforma.vianda_id", "conforma.menu_id")
            ->do("select");

        $diets = $tORM
            ->from("vianda_dieta")
            ->do("select");

        foreach ($diets as $diet) {
            foreach ($foods as $key => $food) {
                unset($foods[$key]['tiempo_de_coccion']);
                unset($foods[$key]['productos']);
                if ($food['id'] == $diet['vianda_id']) {
                    $foods[$key]['dietas'][] = $diet['dieta'];
                }
            }
        }
        foreach ($foods as $food) {
            foreach ($menus as &$menu) { // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar
                unset($menu['estado']);
                unset($menu['calorias']);

                if (in_array(['menu_id' => $menu['id'], 'vianda_id' => $food['id']], $relation)) {
                    if (!isset($menu['viandas'])) {
                        $menu['viandas'] = [];
                    }
                    $menu['viandas'][] = $food;
                }
            }
        }
        return $menus;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}

function create_personal_menu(TORM $tORM, String $token, String $name, Int $frequency, String $description, array $foods)
{
    $client_id = get_client_id($tORM, $token);
    $maximum = [15, 30, 11, 120];

    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    unset($values[5]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    //necesito crear el menu en si, y despues agregar su relacion con las viandas dadas en conforma

    if ($client_id) {
        $menu_names = $tORM->do(query: "SELECT nombre FROM menu WHERE categoria != 'Descartado';");

        $result_conformation = "";
        foreach ($menu_names as $data) {
            if ($name === $data[0]) {
                return "ERROR 409, CONFLICT";
            }
        }
        $price = 0.0;
        foreach ($foods as $food) {
            $food_data = $tORM
                ->from("vianda")
                ->columns("vianda.precio")
                ->where("vianda.id", "eq", $food)
                ->do("select");
            if ($food_data) {
                $price += doubleval($food_data[0]["precio"]);
            } else {
                return "ERROR 404, NOT FOUND";
            }
        }

        $result_menu = $tORM
            ->from("menu")
            ->columns("menu.nombre", "menu.frecuencia", "menu.descripcion", "menu.precio", "menu.categoria")
            ->values("menu", $name, $frequency, $description, $price, "Personalizado")
            ->do("insert");
        $menu_id = $tORM->do(query: "SELECT id FROM menu
        ORDER BY id DESC
        LIMIT 1;")[0];

        $tORM
            ->from("stock")
            ->columns("stock.menu_id", "stock.minimo", "stock.maximo", "stock.actual")
            ->values("stock", intval($menu_id[0]), 5, 10, 0)
            ->do("insert");

        /**Es igual a :
         * $menu_id = $tORM
         * ->from("menu")
         * ->columns("menu.id")
         * ->order("menu.id", "DESC")
         * ->limit(1);
         */

        foreach ($foods as $food) {
            $result_conformation = $tORM
                ->from("conforma")
                ->columns("conforma.menu_id", "conforma.vianda_id")
                ->values("conforma", intval($menu_id[0]), intval($food))
                ->do("insert");
            buy_menu($tORM, "Start", $token, 1, $menu_id[0]);
        }
        if ($result_conformation == $result_menu) {
            return "OK, 200";
        } else {
            return "ERROR 500, SERVER ERROR";
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function delete_personal_menu(TORM $tORM, String $token, Int $menu_id) //
{
    $client_id = get_client_id($tORM, $token);
    $maximum = [15, 11];

    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $menu_existence = $tORM
        ->from("menu")
        ->columns("menu.nombre")
        ->where("menu.id", "eq", $menu_id)
        ->where("menu.categoria", "eq", "Personalizado")
        ->join("compone", "compone.menu_id", "menu.id")
        ->joined_columns("None column")
        ->join("pedido", "pedido.id", "compone.pedido_id")
        ->joined_columns("Pedido.id")
        ->where("pedido.cliente_id", "eq", $client_id[0]["cliente_id"])
        ->do("select");

    $response = "OK, 200";
    if ($menu_existence) {
        $deletion_result_one = $tORM
            ->from("conforma")
            ->where("conforma.menu_id", "eq", $menu_id)
            ->do("delete");
        $response = ($response == $deletion_result_one ? $response : "ERROR 500, SERVER ERROR");

        $deletion_result_two = $tORM
            ->from("compone")
            ->where("compone.menu_id", "eq", $menu_id)
            ->do("delete");
        $response = ($response == $deletion_result_two ? $response : "ERROR 500, SERVER ERROR");

        $tORM
            ->from("stock")
            ->where("stock.menu_id", "eq", intval($menu_id))
            ->do("delete");

        $deletion_result_four = $tORM
            ->from("menu")
            ->where("menu.id", "eq", intval($menu_id))
            ->do("delete");
        $response = ($response == $deletion_result_four ? $response : "ERROR 500, SERVER ERROR");


        $tORM
            ->from("asigna")
            ->where("asigna.pedido_id", "eq", $menu_existence[0]['id'])
            ->do("delete");

        $deletion_result_six = $tORM
            ->from("pedido_esta")
            ->where("pedido_esta.pedido_id", "eq", $menu_existence[0]['id'])
            ->do("delete");

        $deletion_result_six = $tORM
            ->from("pedido")
            ->where("pedido.id", "eq", $menu_existence[0]['id'])
            ->do("delete");
        $response = ($response == $deletion_result_six ? get_personal_menus($tORM, $token) : "ERROR 500, SERVER ERROR");

        return $response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function modify_personal_menu(TORM $tORM, String $token, Int $menu_id, Int $frequency, String $description)
{
    $client_id = get_client_id($tORM, $token);
    $maximum = [15, 11, 11, 120];

    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    unset($values[5]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $menu_existence = $tORM
        ->from("menu")
        ->columns("menu.nombre")
        ->where("menu.id", "eq", intval($menu_id))
        ->join("compone", "compone.menu_id", "menu.id")
        ->joined_columns("None column")
        ->join("pedido", "compone.pedido_id", "pedido.id")
        ->joined_columns("None column")
        ->where("pedido.cliente_id", "eq", $client_id[0]["cliente_id"])
        ->do("select");

    if ($menu_existence) {

        $result = $tORM
            ->from("menu")
            ->columns("menu.frecuencia", "menu.descripcion")
            ->values(
                "menu",
                $frequency ? $frequency : $menu_existence[0]['frecuencia'],
                $description ? $description : $menu_existence[0]['descripcion']
            )
            ->where("menu.id", "eq", intval($menu_id))
            ->do("update");
        return $result;
    } else {
        return "ERROR 404, NOT FOUND";
    }
}

function change_password(TORM $tORM, QueryCall $ctl, String $token, String $actual_passwd, String $passwd, String $confirm_passwd)
{

    $length_verificator = (strlen($passwd) < 30) && (strlen($passwd) > 8);

    $client_id = get_client_id($tORM, $token);


    if ($client_id && $length_verificator) {
        //Verificacion de contrasenia
        $client_name = $tORM
            ->from('web')
            ->columns('web.primer_nombre')
            ->where('web.cliente_id', 'eq', $client_id[0]['cliente_id'])
            ->do('select');

        $name_match = True;
        if ($client_name) {
            $regex = '/\b' . preg_quote(strtolower($client_name[0]['primer_nombre']), '/') . '\b/';
            $name_match = preg_match($regex, strtolower($passwd)) || (strtolower(strval($passwd)) == strtolower(strval($client_name[0]['primer_nombre'])));
        }
        $passwd_verificator = !preg_match('/^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).+$/', $passwd); //True si no hay ni caracteres especiales ni letras ni numeros
        $client_actual_email = $tORM
            ->from('cliente')
            ->columns('cliente.email')
            ->where('cliente.id', 'eq', $client_id[0]['cliente_id'])
            ->do('select');

        $login_response = login($ctl, $client_actual_email[0]['email'], $actual_passwd);
        if (gettype($login_response) == 'string') {
            return $login_response;
        }
        if ($name_match || $passwd_verificator) {
            return 'ERROR 400, BAD REQUEST';
        } elseif ($passwd && ($passwd == $confirm_passwd)) {
            $passwd = md5($passwd);
        } elseif (!($passwd == "" && ($passwd == $confirm_passwd))) {
            return "ERROR 400, BAD REQUEST";
        }

        //Cambio de contrasenia
        $tORM
            ->from("cliente")
            ->columns('cliente.contrasenia')
            ->values('cliente', $passwd)
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("update");
        //
        //
        //

        return $login_response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function get_client_orders(TORM $tORM, $token)
{

    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        $orders = $tORM
            ->from("pedido")
            ->columns("pedido.id", "pedido.fecha_del_pedido", "pedido.direccion", "pedido.calle", "pedido.barrio", "pedido.ciudad")
            ->where("pedido.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->do("select");
        $response = [];
        if (empty($orders)) {
            return "ERROR 404, NOT FOUND";
        }
        foreach ($orders as $key => $order) {

            $states = $tORM
                ->from("pedido_esta")
                ->where("pedido_esta.pedido_id", "eq", intval($order['id']))
                ->join("estado", "estado.id", "pedido_esta.estado_id")
                ->joined_columns("estado.estado")
                ->order('pedido_esta.inicio_del_estado', 'DESC')
                ->limit(1)
                ->do("select");
            if (!$states) { //Debido a un error en los inserts algunos pedidos no tienen estado, debo arreglar esto pero ando muy cansado
                continue;
            }

            $requested_menus = $tORM
                ->from("compone")
                ->columns("compone.cantidad")
                ->where("compone.pedido_id", "eq", intval($order['id']))
                ->join("menu", "compone.menu_id", "menu.id")
                ->joined_columns("menu.id", "menu.nombre", "menu.categoria", "menu.frecuencia")
                ->do("select");

            foreach ($requested_menus as $menu) {
                $menu['precio'] = doubleval($tORM->do(query: "SELECT sum(vianda.precio) from vianda JOIN conforma on vianda.id = conforma.vianda_id JOIN menu on menu.id = conforma.menu_id where conforma.menu_id = {$menu['id']}")[0][0]);
                $response[$key]['menus'][$menu['id']] = $menu;
            }
            $response[$key]['pedido_id'] = $order['id'];
            $response[$key]['fecha_del_pedido'] = date_format(date_create($order['fecha_del_pedido']), "d/m/Y H:i");
            $response[$key]['direccion'] = array_values(array_slice($order, 2, 4));
            $response[$key]['estados'] = [$states[0]['estado_id'], $states[0]['estado'], $states[0]['inicio_del_estado'], $states[0]['final_del_estado']]; // SI SE QUIERE CAMBIAR LA CANTIDAD HAY QUE CAMBIAR LIMIT Y ÉSTO
        }
        return $response;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}

function create_credit_card(TORM $tORM, String $token, String $card_code, String $expire_date, String $name)
{

    if (in_array('', func_get_args()) || !in_array(strlen(strval($card_code)), range(5, 30)) || count(explode(" ", $name)) < 2) {
        return "ERROR 400, BAD REQUEST";
    }
    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $passed_date = explode("/", $expire_date); // Mes/Año
        $date = date("y/m/d", mktime(hour: 0, day: 1, month: $passed_date[0], year: $passed_date[1]));
        $response = $tORM
            ->from("tarjeta")
            ->columns("tarjeta.numero", "tarjeta.digitos_verificadores", "tarjeta.fecha_de_vencimiento", "tarjeta.nombre_de_titular", "tarjeta.cliente_id")
            ->values("tarjeta", md5($card_code), substr($card_code, -4, 4), $date, $name, intval($client_id[0]['cliente_id']))
            ->do("insert");

        return ($response == "OK, 200" ? $response : "ERROR 409, CONFLICT");
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function get_credit_card(TORM $tORM, String $token)
{

    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }
    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $response = $tORM
            ->from("tarjeta")
            ->columns("tarjeta.digitos_verificadores", "tarjeta.fecha_de_vencimiento", "tarjeta.nombre_de_titular")
            ->where("tarjeta.cliente_id", "eq", intval($client_id[0]['cliente_id']))
            ->do("select");
        foreach ($response as &$card) {
            $card['fecha_de_vencimiento'] = date('m/y', strtotime($card['fecha_de_vencimiento']));
        }
        return (gettype($response) == "array" ? $response : "ERROR 409, CONFLICT");
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function delete_credit_card(TORM $tORM, String $token, String $verification_code, String $expire_date, String $name)
{

    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }
    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $passed_date = explode("/", $expire_date); // Mes/Año
        $date = date("y/m/d", mktime(hour: 0, day: 1, month: $passed_date[0], year: $passed_date[1]));
        $response = $tORM
            ->from("tarjeta")
            ->where("tarjeta.cliente_id", "eq", intval($client_id[0]['cliente_id']))
            ->where("tarjeta.digitos_verificadores", "eq", $verification_code)
            ->where("tarjeta.fecha_de_vencimiento", "eq", $date)
            ->where("tarjeta.nombre_de_titular", "eq", $name)
            ->do("delete");
        return ($response == get_credit_card($tORM, $token) ? $response : "ERROR 400, BAD REQUEST");
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

//
//
//

function administration_login(String $name, String $passwd) //Funcion admin INCOMPLETA
{
    $tORM = new TORM('sisviansa_mariadb', $name, $passwd, "sisviansa_techin_v1", 3306);
    $result = $tORM->from('SISVIANSA_USER')->columns('SISVIANSA_USER.rol')->where('SISVIANSA_USER.nombre', 'eq', $name)->do('select');
    return (isset($result->error) ? $result->error : $tORM);
}
function get_menus(TORM $tORM) //Funcion admin 1
{
    //Funcion para recibir TODOS los menus, es una funcion para admin

    $menus = $tORM
        ->from("menu")
        ->do("select");

    $foods = $tORM
        ->from("vianda")
        ->do("select");

    $relation = $tORM
        ->from("conforma")
        ->columns("conforma.vianda_id", "conforma.menu_id")
        ->do("select");

    $diets = $tORM
        ->from("vianda_dieta")
        ->do("select");

    foreach ($diets as $diet) {
        foreach ($foods as $key => $food) {
            unset($foods[$key]['tiempo_de_coccion']);
            unset($foods[$key]['productos']);
            if ($food['id'] == $diet['vianda_id']) {
                $foods[$key]['dietas'][] = $diet['dieta'];
            }
        }
    }
    foreach ($foods as $food) {
        foreach ($menus as $key => $menu) { // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar

            if (in_array(['menu_id' => $menus[$key]['id'], 'vianda_id' => $food['id']], $relation)) {
                if (!isset($menus[$key]['viandas'])) {
                    $menus[$key]['viandas'] = [];
                }
                $menus[$key]['viandas'][$food['id']] = $food;
            }
        }
    }


    $filtered_menus = array_values($menus);


    return $filtered_menus;
}

function get_foods(TORM $tORM) //Funcion admin 1
{
    //Funcion para recibir TODOS las viandas, es una funcion para admin

    $foods = $tORM
        ->from("vianda")
        ->do("select");

    $diets = $tORM
        ->from("vianda_dieta")
        ->do("select");

    foreach ($diets as $diet) {
        foreach ($foods as $key => $food) {
            if ($food['id'] == $diet['vianda_id']) {
                $foods[$key]['dietas'][] = $diet['dieta'];
            }
        }
    }


    $filtered_menus = array_values($foods);


    return $filtered_menus;
}

function get_orders(TORM $tORM, QueryCall $ctl, String $mail = "", String $passwd = "") //Funcion admin 1
{

    $session = login($ctl, $mail, $passwd);
    if ((strtolower(gettype($session) == "string") || in_array("", func_get_args()))) {

        $orders = $tORM
            ->from("pedido")
            ->do("select");
    } else {

        $client_id = get_client_id($tORM, $session[1]);

        $orders = $tORM
            ->from("pedido")
            ->where("pedido.cliente_id", "eq", ($client_id[0]['cliente_id']))
            ->columns("pedido.id", "pedido.fecha_del_pedido", "pedido.direccion", "pedido.calle", "pedido.barrio", "pedido.ciudad", "pedido.cliente_id")
            ->do("select");
    }
    $response = [];
    if (empty($orders)) {
        return "ERROR 404, NOT FOUND";
    }

    $counter = 0;
    foreach ($orders as $order) {

        $states = $tORM
            ->do(query: "select pedido_esta.*,
             estado.estado
             from pedido_esta
              join estado on estado.id = pedido_esta.estado_id
               where pedido_esta.pedido_id={$order['id']}
                order by pedido_esta.final_del_estado DESC limit 1")[0];

        $requested_menus = $tORM
            ->do(query: "SELECT 
            compone.cantidad,
             menu.id,
              menu.nombre,
               menu.categoria,
                menu.frecuencia,
                 (SELECT sum(vianda.precio) from vianda
                  JOIN conforma on vianda.id = conforma.vianda_id
                   JOIN menu on menu.id = conforma.menu_id
                    where conforma.menu_id = menu.id)
                 from compone 
                 join menu on menu.id=compone.menu_id
                 where compone.pedido_id={$order['id']}");


        foreach ($requested_menus as &$menu) {
            $response[$counter]['menus'][] = [
                'nombre' => $menu[2],
                'precio' => $menu[5],
                'cantidad' => $menu[0]
            ];
        }
        $response[$counter]['pedido_id'] = $order['id'];
        $response[$counter]['fecha_del_pedido'] = date_format(date_create($order['fecha_del_pedido']), "d/m/Y H:i");
        $response[$counter]['direccion'] = array_values(array_slice($order, 2, 4));
        $response[$counter]['estados'] = [['id' => $order['id'], 0, 'estado' => $states[4], 'inicio_del_estado' => $states[2], 'final_del_estado' => $states[3]]];
        $web = $tORM->from('web')->where('web.cliente_id', 'eq', $order['cliente_id'])->do('select');
        $business = $tORM->from('empresa')->where('empresa.cliente_id', 'eq', $order['cliente_id'])->do('select');
        if ($business) {
            $response[$counter]['nombre'] = $business[0]['nombre'];
            $response[$counter]['documento'] = 'RUT' . ': ' . strval($business[0]['rut']);
        } else {
            $response[$counter]['nombre'] = $web[0]['primer_nombre'] . ' ' . $web[0]['primer_apellido'];
            $response[$counter]['documento'] = strval($web[0]['documento_tipo']) . ': ' . strval($web[0]['documento_numero']);
        }
        $counter += 1;
    }
    return $response;
}

/*
function get_orders_old(TORM $tORM, $token)
{

    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        $orders = $tORM
            ->from("pedido")
            ->columns("pedido.id", "pedido.fecha_del_pedido", "pedido.direccion", "pedido.calle", "pedido.barrio", "pedido.ciudad")
            ->where("pedido.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->do("select");
        $response = [];
        if (empty($orders)) {
            return "ERROR 404, NOT FOUND";
        }
        foreach ($orders as $key => $order) {

            $states = $tORM
                ->from("estado")
                ->columns("estado.id", "estado.estado", "estado.inicio_del_estado", "estado.final_del_estado")
                ->where("estado.pedido_id", "eq", $order['id'])
                ->do("select");

            $requested_menus = $tORM
                ->do(query: "SELECT 
                compone.cantidad,
                 menu.id,
                  menu.nombre,
                   menu.categoria,
                    menu.frecuencia,
                     (SELECT sum(vianda.precio) from vianda
                      JOIN conforma on vianda.id = conforma.vianda_id
                       JOIN menu on menu.id = conforma.menu_id
                        where conforma.menu_id = menu.id)
                     from compone 
                     join menu on menu.id=compone.menu_id
                     where compone.pedido_id=4");

            foreach ($requested_menus as &$menu) {
                $response[$key]['menus'][$menu['id']] = [[
                    'cantidad' => $menu[0],
                    'id' => $menu[1],
                    'nombre' => $menu[2],
                    'frecuencia' => $menu[4],
                    'categoria' => $menu[3],
                    'precio' => $menu[5]
                ]];
            }
            $response[$key]['pedido_id'] = $order['id'];
            $response[$key]['fecha_del_pedido'] = date_format(date_create($order['fecha_del_pedido']), "d/m/Y H:i");
            $response[$key]['direccion'] = array_values(array_slice($order, 2, 4));
            $response[$key]['estados'] = $states;
        }
        return $response;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}
*/
function change_order_state(TORM $tORM, $order_id, $new_state) //Funcion admin
{
    $new_state = strval(ucfirst($new_state));

    if (!in_array($new_state, ['Solicitado', 'Entregado', 'Confirmado', 'Rechazado', 'En camino'])) {
        return "ERROR 400, BAD REQUEST";
    } else {
        $state = $tORM
            ->from("estado")
            ->columns("estado.estado")
            ->join("pedido_esta", "pedido_esta.estado_id", "estado.id")
            ->where("pedido_esta.pedido_id", "eq", intval($order_id))
            ->where("pedido_esta.final_del_estado", "null", "")
            ->do("select");
        $new_state_id = $tORM
            ->from("estado")
            ->columns("estado.id")
            ->where("estado.estado", "eq", $new_state)
            ->do("select")[0];
        if ($state) {
            $progressions = [
                'Solicitado' => ['Confirmado', 'Rechazado'],
                'Confirmado' => ['En camino'],
                'En camino' => ['Entregado', 'Rechazado']
            ];

            if (!in_array($new_state, $progressions[$state[0]['estado']] ?? [], true)) {
                return "ERROR 400, BAD REQUEST";
            }
        } else {
            return "ERROR 404, NOT FOUND";
        }
    }


    $change_prev = $tORM
        ->from("pedido_esta")
        ->columns("pedido_esta.final_del_estado")
        ->values("pedido_esta", date("Y-m-d H:i:s"))
        ->do("update");
    $set_actual = $tORM
        ->from("pedido_esta")
        ->columns("pedido_esta.estado_id", "pedido_esta.pedido_id", "pedido_esta.inicio_del_estado")
        ->values("pedido_esta", intval($new_state_id['id']), intval($order_id), date("Y-m-d H:i:s"))
        ->do("insert");
    return ($change_prev == $set_actual ? "OK, 200" : "ERROR 500, SERVER ERROR");
}

function register_business(QueryCall $ctl, String $rut, String $name, String $mail, String $password) //Funcion admin
{
    $values = func_get_args();

    unset($values[0]);

    $length_verificator = True;

    $maximum = [12, 30, 50, 30];
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $regex = '/\b' . preg_quote(strtolower($name), '/') . '\b/';


    $name_match = preg_match($regex, strtolower($password)) || (strtolower(strval($password)) == strtolower(strval($name)));

    $passwd_verificator = !preg_match('/^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).+$/', $password); //True si no hay ni caracteres especiales ni letras ni numeros


    if ($name_match || $passwd_verificator) {
        return 'ERROR 400, BAD REQUEST: Password error';
    }

    $length_verificator = strlen($password) > 6 && strlen($mail) > 6 && strlen($name) > 6 && $length_verificator;

    $type_verificator = True;

    foreach ($values as $var) {
        $type_verificator = $type_verificator && is_string($var);
    }

    if (!isset($name, $rut, $mail, $password)) {
        return "400, BAD REQUEST: Missing data";
    } elseif (!$type_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data length";
    } elseif (!strpos($mail, "@") || !strpos($mail, ".")) {
        return "400, BAD REQUEST: Wrong data structure";
    }

    $existence_verificator_mail = empty($ctl->select("cliente", ["email"], [$mail], ["email"])->call());

    if (!$existence_verificator_mail) {
        return "409, CONFLICT: This Email is already in use";
    }

    if ($ctl->insert("cliente", [$mail, md5($password), "Autorizado"], ["email", "contrasenia", "autorizacion"])->call() === ["OK", 200]) {
        $id = $ctl->select("cliente", ["id"], [$mail], ["email"])->call();
        $ctl->insert("empresa", [$rut, $name, $id[0]], ["rut", "nombre", "cliente_id"])->call();
        return 'OK, 200';
    } else {
        return '409, CONFLICT';
    }
}

function change_business_mail(TORM $tORM, QueryCall $ctl, String $new_mail, String $mail, String $password) //Funcion admin
{
    $session = login($ctl, $mail, $password);
    if ((gettype($session) == "string")) {
        return "ERROR 404, NOT FOUND";
    }

    $values = func_get_args();

    unset($values[0]);
    unset($values[1]);
    $values = array_values($values);
    $maximum = [50, 50, 30];

    $length_verificator = true;
    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    if (!(strpos($mail, "@") && strpos($mail, ".") && ((strpos($new_mail, "@") && strpos($new_mail, ".")) || empty($new_mail)))) {
        return "ERROR 400, BAD REQUEST";
    } elseif (!$length_verificator) {
        return "ERROR 400, BAD REQUEST";
    }

    $client_id = get_client_id($tORM, $session[1]);
    if ($client_id) {

        $client_values = $tORM
            ->from("cliente")
            ->columns("cliente.email")
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("select")[0];


        $result = $tORM
            ->from("cliente")
            ->columns('cliente.email')
            ->values('cliente', $new_mail ? $new_mail : $client_values["email"])
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("update");
        //
        //

        return $result;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function get_business(TORM $tORM, String $token)
{
    if (!$token) {
        return "ERROR 400, BAD REQUEST";
    }
    $client_id = get_client_id($tORM, $token);
    //Devuelve un array 
    $result = $tORM->from("empresa")->where("empresa.cliente_id", "eq", intval($client_id[0]['cliente_id']))->join('cliente', 'cliente.id', 'empresa.cliente_id')->do('select');
    if ($result) {

        $email = $tORM->from('cliente')->columns('cliente.email')->where('cliente.id', 'eq', intval($client_id[0]['cliente_id']))->do('select');
        $response = [$result[0]['id'], 'Empresa', $result[0]['nombre'], 'RUT', $result[0]['rut'], $email[0]['email']];
        return $response;
    } else {
        return 'ERROR 404, NOT FOUND';
    }
}
function show_user_list(TORM $tORM, String $type = "" /* web/empresa */, String $identificator = "", String $id_type = "") //Funcion admin
{

    switch (strtolower($type)) {
        case "empresa":
            if ($identificator && !$id_type) {
                $result = $tORM
                    ->do(query: "
                    SELECT cliente_ID, 'Empresa' AS Tipo, nombre, 'RUT' as tipo_rut, rut,
                    (SELECT GROUP_CONCAT(cliente_telefono.telefono)
                        FROM cliente_telefono
                        WHERE cliente_telefono.cliente_id = cliente.id),
                    cliente.Email,
                    cliente.Autorizacion
                    FROM empresa JOIN cliente ON cliente.id = empresa.cliente_id WHERE empresa.rut = '$identificator'");
            } else {

                $result = $tORM
                    ->do(query: "
                    SELECT cliente_ID, 'Empresa' AS Tipo, nombre, 'RUT' as tipo_rut, rut,
                    (SELECT GROUP_CONCAT(cliente_telefono.telefono)
                        FROM cliente_telefono
                        WHERE cliente_telefono.cliente_id = cliente.id),
                    cliente.Email,
                    cliente.Autorizacion
                    FROM empresa JOIN cliente ON cliente.id = empresa.cliente_id");
            }
            break;
        case "web":
            if ($id_type && $identificator) {
                $result = $tORM
                    ->do(query: "
                    SELECT 
                    cliente_ID,
                    'Web' AS Tipo,
                     CONCAT(primer_nombre, ' ', primer_apellido),
                     documento_tipo,
                     documento_numero,
                     (SELECT GROUP_CONCAT(cliente_telefono.telefono)
                        FROM cliente_telefono
                        WHERE cliente_telefono.cliente_id = cliente.id),
                     cliente.Email,
                     cliente.Autorizacion
                    FROM web JOIN cliente ON cliente.id = web.cliente_id 
                    WHERE documento_tipo='$id_type' 
                    AND documento_numero=$identificator");
            } else {
                $result = $tORM
                    ->do(query: "SELECT 
                    cliente_ID, 
                    'Web' AS Tipo, 
                    CONCAT(primer_nombre, ' ', primer_apellido), 
                    documento_tipo,  
                    documento_numero,
                    (SELECT GROUP_CONCAT(cliente_telefono.telefono)
                        FROM cliente_telefono
                        WHERE cliente_telefono.cliente_id = cliente.id),
                    cliente.Email,
                    cliente.Autorizacion
                    FROM web JOIN cliente ON cliente.id = web.cliente_id");
            }
            break;
        default:
            if (!($type == "" && $identificator == "")) {
                return "ERROR 400, bad request";
            }
            $result = $tORM
                ->do(query: "
                            SELECT 
                            cliente.id,
                            personas.Tipo,
                            personas.Nombre,
                            personas.Numero_tipo,
                            personas.Numero,
                            (SELECT GROUP_CONCAT(cliente_telefono.telefono)
                                FROM cliente_telefono
                                WHERE cliente_telefono.cliente_id = cliente.id),
                                cliente.Email,
                                cliente.Autorizacion
                            FROM cliente
                            INNER JOIN (
                            SELECT 'Web' AS Tipo, CONCAT(primer_nombre, ' ', primer_apellido) as Nombre, documento_tipo as Numero_tipo,  documento_numero as Numero, cliente_ID
                            FROM web
                            UNION ALL
                            SELECT 'Empresa' AS Tipo, nombre, 'RUT' as Numero_tipo, rut as Numero, cliente_ID
                            FROM empresa
                            ) personas ON personas.cliente_id = cliente.id
                            JOIN cliente_telefono on cliente_telefono.cliente_id = cliente.id
                            GROUP BY cliente.id;
                            ");
            break;
    }



    if ($result) {
        foreach ($result as &$client) {
            if ($client[5]) {

                $client[5] = explode(',', $client[5]);
            } else {
                $client[5] = [];
            }
        }
    }
    return $result;
}


function change_business_password(TORM $tORM, QueryCall $ctl, String $mail, String $actual_passwd, String $passwd, String $confirm_passwd) //Funcion admin
{

    $length_verificator = (strlen($passwd) < 30) && (strlen($passwd) > 8);

    $session = login($ctl, $mail, $actual_passwd);
    if ((gettype($session) == "string")) {
        return "ERROR 404, NOT FOUND";
    }

    $client_id = get_client_id($tORM, $session[1]);


    if ($client_id && $length_verificator) {
        //Verificacion de contrasenia
        $client_name = $tORM
            ->from('empresa')
            ->columns('empresa.nombre')
            ->where('empresa.cliente_id', 'eq', $client_id[0]['cliente_id'])
            ->do('select');

        $name_match = True;
        if ($client_name) {
            $regex = '/\b' . preg_quote(strtolower($client_name[0]['nombre']), '/') . '\b/';
            $name_match = preg_match($regex, strtolower($passwd)) || (strtolower(strval($passwd)) == strtolower(strval($client_name[0]['nombre'])));
        }
        $passwd_verificator = !preg_match('/^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_]).+$/', $passwd); //True si no hay ni caracteres especiales ni letras ni numeros
        $actual_client = $tORM
            ->from('cliente')
            ->where('cliente.id', 'eq', $client_id[0]['cliente_id'])
            ->where('cliente.contrasenia', 'eq', md5($actual_passwd))
            ->do('select');


        if ($name_match || $passwd_verificator) {
            return 'ERROR 400, BAD REQUEST';
        } elseif (($passwd == "") || ($passwd != $confirm_passwd) || ($actual_passwd === $passwd)) {
            return "ERROR 400, BAD REQUEST";
        } elseif (!$actual_client) {
            return "ERROR 404, NOT FOUND";
        } elseif ($passwd && ($passwd == $confirm_passwd)) {
            $passwd = md5($passwd);
        }

        //Cambio de contrasenia
        $result = $tORM
            ->from("cliente")
            ->columns('cliente.contrasenia')
            ->values('cliente', $passwd)
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("update");
        //
        //
        //

        return $result;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function create_food(TORM $tORM, String $name, String $time, String $products, Int $calories, float $price) //Funcion admin
{

    $values = func_get_args();
    unset($values[0]);
    $values = array_values($values);
    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }
    $calories = doubleval($calories);
    $price = doubleval($price);

    $response = $tORM
        ->from("vianda")
        ->columns("vianda.nombre", "vianda.tiempo_de_coccion", "vianda.productos", "vianda.calorias", "vianda.precio")
        ->values("vianda", $name, intval($time), $products, intval($calories), doubleval($price))
        ->do("insert");

    return ($response = "OK, 200" ? $response : "ERROR 409, CONFLICT"); //CAMBIE ACA ÉSTO PARA QUE RESPONSE SEA IGUAL A ESO Y NO UN BOOLEANO, NO SE SI ESTA BIEN
}

function delete_food(TORM $tORM, Int $food_id) //Funcion admin
{
    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }
    if (!($tORM->from("vianda")->where("vianda.id", "eq", $food_id)->do("select"))) {
        return "ERROR 404, NOT FOUND";
    }
    $response = $tORM
        ->from("conforma")
        ->where("conforma.vianda_id", "eq", $food_id)
        ->do("delete");

    $response = $tORM
        ->from("vianda_dieta")
        ->where("vianda_dieta.vianda_id", "eq", $food_id)
        ->do("delete");
    $response = $tORM
        ->from("vianda")
        ->where("vianda.id", "eq", $food_id)
        ->do("delete");

    return ($response = !($tORM->from("vianda")->where("vianda.id", "eq", $food_id)->do("select")) ? $response : "ERROR 500, SERVER ERROR");
}

function modify_food($tORM, Int $food_id, String $name = "", String $time = "", String $products = "", Int $calories = 0, Int $price = 0) //Funcion admin
{
    //Se parte de la suposicion que nada puede tener 0 calrias
    $food_existence = $tORM
        ->from("vianda")
        ->where("vianda.id", "eq", intval($food_id)) //DEBO CAMBIAR SI TENGO QUE CAMBIAR DE ID A OTRA COSA
        ->do("select");

    if ($food_existence) {
        $calories = intval($calories);
        $price = doubleval($price);
        $time = intval($time);
        $result =
            $tORM
            ->from("vianda")
            ->columns(
                "vianda.nombre",
                "vianda.tiempo_de_coccion",
                "vianda.productos",
                "vianda.calorias",
                "vianda.precio",
            )
            ->values(
                "vianda",
                $name ? $name : $food_existence[0]['nombre'],
                $time ? $time : intval($food_existence[0]['tiempo_de_coccion']),
                $products ? $products : $food_existence[0]['productos'],
                $calories ? $calories : intval($food_existence[0]['calorias']),
                $price ? $price : doubleval($food_existence[0]['precio'])
            )
            ->where("vianda.id", "eq", intval($food_id))
            ->do("update");

        return $result;
    } else {
        return "ERROR 404, NOT FOUND";
    }
}

function toggle_food_diet($tORM, bool $state, Int $food_id, String $diet) //Funcion admin
{
    $result = "";
    if (gettype($state) == "boolean") {


        switch ($state) { //true = agregar, false = quitar
            case true:
                if (
                    $tORM
                    ->from("vianda_dieta")
                    ->where("vianda_dieta.dieta", "eq", $diet)
                    ->where("vianda_dieta.vianda_id", "eq", intval($food_id))
                    ->do("select")
                ) {
                    return "ERROR 409, CONFLICT";
                }
                $result = $tORM
                    ->from("vianda_dieta")
                    ->values("vianda_dieta", intval($food_id), $diet)
                    ->do("insert");
                return $result;
            case false:
                if (
                    !($tORM
                        ->from("vianda_dieta")
                        ->where("vianda_dieta.dieta", "eq", $diet)
                        ->where("vianda_dieta.vianda_id", "eq", intval($food_id))
                        ->do("select")
                    )
                ) {
                    return "ERROR 404, NOT FOUND";
                }
                $result = $tORM
                    ->from("vianda_dieta")
                    ->where("vianda_dieta.vianda_id", "eq", intval($food_id))
                    ->where("vianda_dieta.dieta", "eq", $diet)
                    ->do("delete");
                return $result;
        }
    } else {
        return "ERROR 400, BAD REQUEST";
    }
}

function create_menu(TORM $tORM, String $name, Int $frequency, String $description, array $foods) //Funcion admin
{

    $maximum = [30, 11, 120];
    $name = ucfirst($name);
    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    unset($values[4]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    //necesito crear el menu en si, y despues agregar su relacion con las viandas dadas en conforma

    $menu_names = $tORM->do(query: "SELECT nombre FROM menu WHERE categoria != 'Descartado';");

    $result_conformation = "";
    foreach ($menu_names as $data) {
        if ($name === $data[0]) {
            return "ERROR 409, CONFLICT";
        }
    }

    $result_menu = $tORM
        ->from("menu")
        ->columns("menu.nombre", "menu.frecuencia", "menu.descripcion", "menu.categoria")
        ->values("menu", $name, intval($frequency), $description, "Estandar")
        ->do("insert");
    $menu_id = $tORM
        ->from("menu")
        ->columns("menu.id")
        ->order("menu.id", "DESC")
        ->limit(1)
        ->do("select");

    $tORM
        ->from("stock")
        ->columns("stock.menu_id", "stock.minimo", "stock.maximo", "stock.actual")
        ->values("stock", intval($menu_id[0]['id']), 5, 10, 0)
        ->do("insert");

    $menu_id = $tORM->do(query: "SELECT id FROM menu
        ORDER BY id DESC
        LIMIT 1;")[0];

    /**Es igual a :
     * $menu_id = $tORM
     * ->from("menu")
     * ->columns("menu.id")
     * ->order("menu.id", "DESC")
     * ->limit(1);
     */

    foreach ($foods as $food) {
        $result_conformation = $tORM
            ->from("conforma")
            ->columns("conforma.menu_id", "conforma.vianda_id")
            ->values("conforma", intval($menu_id[0]), intval($food))
            ->do("insert");
    }
    if ($result_conformation == $result_menu) {
        return "OK, 200";
    } else {
        return "ERROR 500, SERVER ERROR";
    }
}

function delete_menu(TORM $tORM, Int $menu_id) //Funcion admin
{

    $values = func_get_args();
    unset($values[0]);


    if (!(strlen(strval($menu_id)) <= 11)) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $menu_existence = $tORM
        ->from("menu")
        ->columns("menu.nombre")
        ->where("menu.id", "eq", intval($menu_id))
        ->where("menu.categoria", "neq", "Descartado")
        ->do("select");
    if ($menu_existence) {
        $menu_response = $tORM
            ->from("menu")
            ->columns("menu.categoria")
            ->values("menu", "Descartado")
            ->where("menu.id", "eq", intval($menu_id)) // El menu puede ser descartado ahora
            ->do("update");

        return $menu_response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function modify_menu(TORM $tORM, Int $menu_id, String $name, Int $frequency = 0, String $description = "") //Funcion admin
{
    $maximum = [11, 50, 11, 120];

    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $menu_existence = $tORM
        ->from("menu")
        ->where("menu.id", "eq", intval($menu_id))
        ->where("menu.categoria", "neq", "Descartado")
        ->join("compone", "compone.menu_id", "menu.id")
        ->joined_columns("None column")
        ->join("pedido", "compone.pedido_id", "pedido.id")
        ->joined_columns("None column")
        ->do("select");

    if ($menu_existence) {

        $result = $tORM
            ->from("menu")
            ->columns("menu.nombre", "menu.frecuencia", "menu.descripcion")
            ->values(
                "menu",
                $name ? $name : $menu_existence[0]['nombre'],
                $frequency ? $frequency : $menu_existence[0]['frecuencia'],
                $description ? $description : $menu_existence[0]['descripcion']
            )
            ->where("menu.id", "eq", intval($menu_id))
            ->do("update");
        return $result;
    } else {
        return "ERROR 404, NOT FOUND";
    }
}

function change_menu_stock(TORM $tORM, Int $menu_id, Int $change) //Funcion admin
{
    $maximum = [11, 11];

    $values = func_get_args();
    $length_verificator = True;
    unset($values[0]);
    $values = array_values($values);

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if (!$length_verificator) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $stock = $tORM->from("stock")
        ->columns("stock.actual", "stock.maximo")
        ->where("stock.menu_id", "eq", intval($menu_id))
        ->do("select");
    $actual_stock = intval($stock[0]["actual"]) + $change;

    if (($actual_stock < 0) || ($actual_stock > intval($stock[0]["maximo"]))) {
        return "ERROR 400, BAD REQUEST";
    }

    $result = $tORM->from("stock")
        ->columns("stock.actual")
        ->values("stock", $actual_stock)
        ->where("stock.menu_id", "eq", intval($menu_id))
        ->do("update");
    return $result;
}

function get_client_phone(TORM $tORM, String $type = "" /* web/empresa */, String $identificator = "", String $id_type = "") // Funcion admin
{
    //Funcion para recibir TODOS los telefonos, es una funcion para admin


    switch (strtolower($type)) {
        case "empresa":
            if ($identificator && !$id_type) {
                $result = $tORM
                    ->do(query: "
                    SELECT cliente_telefono.telefono
                    FROM empresa JOIN cliente_telefono ON cliente_telefono.cliente_id = empresa.cliente_id WHERE empresa.rut = '$identificator'");
                $result = $result ? $result[0] : [];
            } else {

                $result = $tORM
                    ->do(query: "
                    SELECT cliente_ID, 'Empresa' AS Tipo, nombre, CONCAT('RUT: ',rut), cliente.email
                    FROM empresa JOIN cliente ON cliente.id = empresa.cliente_id");
                $result = $result ? $result[0] : [];
            }
            break;
        case "web":
            if ($id_type && $identificator) {
                $result = $tORM
                    ->do(query: "
                    SELECT 'Web' AS Tipo,cliente_ID, primer_nombre, CONCAT(documento_tipo,': ',  documento_numero), cliente.email
                    FROM web JOIN cliente ON cliente.id = web.cliente_id WHERE documento_tipo='$id_type' AND documento_numero=$identificator");

                $result = $result ? $result[0] : [];
            } else {
                $result = $tORM
                    ->do(query: "SELECT 'Web' AS Tipo,cliente_ID, primer_nombre, CONCAT(documento_tipo,': ',  documento_numero), cliente.email
                    FROM web JOIN cliente ON cliente.id = web.cliente_id");
                $result = $result ? $result[0] : [];
            }
            break;
        default:
            return "ERROR 400, bad request";
    }




    return [$result];
}
function create_phone(TORM $tORM, Int $client_id, String $phone_number) // Funcion admin
{
    $values = func_get_args();
    unset($values[0]);
    $values = array_values($values);
    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }

    $phone_counter = $tORM
        ->do(query: "select count(telefono) from cliente_telefono where cliente_id = {$client_id}");

    if (($phone_counter[0][0]) >= 3) {
        return "422, UNPROCESSABLE ENTITY";
    }

    $response = $tORM
        ->from("cliente_telefono")
        ->values("cliente_telefono", intval($client_id), $phone_number)
        ->do("insert");

    return ($response == "OK, 200" ? $response : "ERROR 409, CONFLICT");
}

function create_client_phone(TORM $tORM, Int $token, String $phone_number) // Funcion admin
{
    $client_id = get_client_id($tORM, $token);
    $values = func_get_args();
    unset($values[0]);
    $values = array_values($values);
    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }

    $phone_counter = $tORM
        ->do(query: "select count(telefono) from cliente_telefono where cliente_id = {$client_id}");

    if (($phone_counter[0][0]) >= 3) {
        return "422, UNPROCESSABLE ENTITY";
    }

    $response = $tORM
        ->from("cliente_telefono")
        ->values("cliente_telefono", intval($client_id[0]['cliente_id']), $phone_number)
        ->do("insert");

    return ($response == "OK, 200" ? $response : "ERROR 409, CONFLICT");
}
function delete_phone(TORM $tORM, Int $client_id, String $phone_number) // Funcion admin
{
    if (in_array('', func_get_args())) {
        return "ERROR 400, BAD REQUEST";
    }
    $business_p_existence = $tORM
        ->from("cliente_telefono")
        ->where("cliente_telefono.cliente_id", "eq", $client_id)
        ->where("cliente_telefono.telefono", "eq", $phone_number)
        ->do("select");
    $web_p_existence = $tORM
        ->from("cliente_telefono")
        ->where("cliente_telefono.cliente_id", "eq", $client_id)
        ->where("cliente_telefono.telefono", "eq", $phone_number)
        ->do("select");

    if (!($web_p_existence && $business_p_existence)) {
        return "ERROR 404, NOT FOUND";
    }
    $response = $tORM
        ->from("cliente_telefono")
        ->where("cliente_telefono.cliente_id", "eq", $client_id)
        ->where("cliente_telefono.telefono", "eq", $phone_number)
        ->do("delete");
    $business_p_existence = $tORM
        ->from("cliente_telefono")
        ->where("cliente_telefono.cliente_id", "eq", $client_id)
        ->where("cliente_telefono.telefono", "eq", $phone_number)
        ->do("select");
    $web_p_existence = $tORM
        ->from("cliente_telefono")
        ->where("cliente_telefono.cliente_id", "eq", $client_id)
        ->where("cliente_telefono.telefono", "eq", $phone_number)
        ->do("select");

    return ($response = !($web_p_existence && $business_p_existence) ? $response : "ERROR 500, SERVER ERROR");
}
function toggle_client_state(TORM $tORM, Int $client_id, String $state) // Funcion admin
{

    $values = func_get_args();
    unset($values[0]);
    $state = ucfirst($state);
    if (!in_array($state, ['En espera', 'Autorizado', 'No autorizado'])) {
        return 'ERROR 422, UNPROCESSABLE ENTITY';
    }


    if (!(strlen(strval($client_id)) <= 11)) {
        return "ERROR 413, REQUEST ENTITY TOO LARGE";
    }
    $client_existence = $tORM
        ->from("cliente")
        ->columns("cliente.autorizacion")
        ->where("cliente.id", "eq", intval($client_id))
        ->where("cliente.autorizacion", "neq", $state)
        ->do("select");
    if ($client_existence) {
        if ($client_existence[0]['autorizacion'] == $state) {
            return 'OK, 200';
        }
        $client_response = $tORM
            ->from("cliente")
            ->columns("cliente.autorizacion")
            ->values("cliente", $state)
            ->where("cliente.id", "eq", intval($client_id))
            ->do("update");

        return $client_response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function proto_set_package($tORM) // El seeder que uso para generar entradas para paquetes, podria modificarlo para hacerlo del sistema, no se
{

    $pedidos = $tORM->from('pedido')->do('select');
    $correspondencias = $tORM->from('compone')->do('select');
    $ids = 1;
    foreach ($correspondencias as $correspondencia) {
        // Genero entradas en paquete, genera y asigna
        for ($i = 1; $i <= intval($correspondencia['cantidad']); $i++, $ids++) {
            $result = $tORM->from('paquete')
                ->values('paquete', $ids, date('Y-m-d'))
                ->do('insert');


            $result = $tORM->from('genera')
                ->values('genera', intval($correspondencia['menu_id']), $ids, Date('y:m:d', strtotime('+40 days')))
                ->do('insert');


            $result = $tORM->from('asigna')
                ->values('asigna', $ids, intval($correspondencia['pedido_id']))
                ->do('insert');


            $result = $tORM->from('paquete_esta')
                ->columns('paquete_esta.estado_id', 'paquete_esta.paquete_id', 'paquete_esta.inicio_del_estado')
                ->values('paquete_esta', 1, $ids, date('Y-m-d'))
                ->do('insert');

            foreach ($pedidos as $pedido) {
                if ($correspondencia['pedido_id'] == $pedido['id'])
                    $result = $tORM->from('recibe')
                        ->values('recibe', $ids, intval($pedido['cliente_id']))
                        ->do('insert');
            }
        }
    }
}

function proto_session(TORM $tORM) //Funcion descartada, pero la dejo por ahora por si me es útil
{
    $token = '12312334f234';
    $is_session_active = $tORM
        ->from('sesion')
        ->columns('sesion.estado', 'sesion.ultima_sesion')
        ->join('inicia', 'inicia.sesion_token', 'sesion.token')
        ->joined_columns('cliente_id')
        ->where('sesion.token', 'eq', $token)
        ->do('select');

    if ($is_session_active && (gettype($is_session_active) == 'array')) {
        if ($is_session_active[0]['estado'] == 'Activa') {
            //Necesito modificar la sesion existente a Finalizada si esta ya en su limite de tiempo, 
            //sino se reinicia el tiempo
            $actual_date = date('Y-m-d H:i:s');
            $newDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));
            if ($is_session_active[0]['ultima_sesion'] <= $actual_date) {
                //update a la sesion actual (pasar de activa a finalizada) y crear una nueva con su respectivo token
                //Ademas he de modificar inicia para agregar la nueva sesion ahi
                return $is_session_active;
            }
        }
        //Necesito generar una nueva entrada de sesion

    } else {
        return $is_session_active;
    }
    return False;
}

/*
Metodo que forme para encontrar entre 2 valores de forma facil:
function len($variable, $minimum, $maximum){
    $minimum = intval($minimum);
    $maximum = intval($maximum);
    if(!empty($minimum)!empty($maximum)){
        switch (gettype($variable)) {
            case "array":
                return in_array(count($variable), range($minimum, $maximum));
                break;
            default:
                return in_array(strlen(strval($variable)), range($minimum, $maximum));
                break;
    }
    }else{
    return [$variable, $minimum, $maximum];
    }
}
 */
