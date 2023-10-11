<?php
include_once "Data/database_model.php";
include_once "Data/ORM-V1.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

$authorization = __FILE__;

function token_generator()
{
    $allowedCharacters = '0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
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
        if (!is_array($response) || count($response) === 0 || is_string($response)) {
            return "404, NOT FOUND: The given TOKEN doesn't exist";
        } else {

            $actualDate = date('Y-m-d H:i:s');

            $dbDate = $response[0];

            if ($actualDate <= $dbDate) {
                $newDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 minutes'));

                $ctl->update("sesion", [$token, $actualDate, $newDate], ["token"], ["token", "ultima_sesion", "final_de_sesion"])->call();
                return [True, $response[2], $response[3]];
            } else if ($actualDate > $dbDate) {
                return session_close($ctl, $token);
            }
        }
    } else {
        return [false];
    }
}


function login(QueryCall $ctl, $mail, $passwd, string $token = "")
{
    $values = func_get_args();

    unset($values[0]);
    unset($values[3]);
    $length_verificator = true;

    foreach ($values as $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= 30) && (strlen(strval($var)) >= 2);
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

            $ctl->insert("sesion", [$new_token, $actual_session, $last_session, $last_session, "Activa"],  ["token", "inicio_de_sesion", "ultima_sesion", "final_de_sesion", "estado"])->call();
            $ctl->insert("inicia", [$new_token, $id],  ["sesion_token", "cliente_id"])->call();
            return [True, $new_token, $response[1], $response[2]];
        } else {
            return "403, FORBIDDEN: You are not allowed to enter the system";
        }
    } else {
        return "404, NOT FOUND: The user wasn't found";
    }
}
function register_web_first(QueryCall $ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password)
{
    $values = func_get_args();

    unset($values[0]);

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
    } elseif (!ctype_digit($values[4])) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $existence_verificator_doc = empty($ctl->select("web", ["cliente_id"], [$doc_type, $doc], ["tipo", "numero"])->call());
    $existence_verificator_mail = empty($ctl->select("cliente", ["email"], [$mail], ["email"])->call());

    if (!$existence_verificator_doc) {
        return "409, CONFLICT: This client already exists";
    } else if (!$existence_verificator_mail) {
        return "409, CONFLICT: This Email is already in use";
    }

    if ($ctl->insert("cliente", [$mail, $password, "En espera"], ["email", "contrasenia", "autorizacion"])->call() === ["OK", 200]) {
        $id = $ctl->select("cliente", ["id"], [$mail], ["email"])->call();
        $ctl->insert("web", [$id[0], $first_name, $first_surname, $doc_type, $doc], ["cliente_id", "primer_nombre", "primer_apellido", "tipo", "numero"])->call();
        login($ctl, $mail, $password, "");
        return ["OK", 200];
    }
}
//
//
function modify_web(TORM $tORM, string $token, $passwd = "", $confirm_passwd = "", $first_name = "", $second_name = "", $first_surname = "", $second_surname = "", $mail = "")
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 30, 30, 20, 25];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if ($passwd && ($passwd == $confirm_passwd)) {
        $passwd = md5($passwd);
    } elseif (!($passwd == "" && ($passwd == $confirm_passwd))) {
        return "ERROR 400, BAD REQUEST";
    }

    $client_id = get_client_id($tORM, $token);

    if ($client_id && $length_verificator) {

        $web_values = $tORM
            ->from("web")
            ->columns("web.primer_nombre", "web.primer_apellido", "web.segundo_nombre", "web.segundo_apellido")
            ->where("web.cliente_id", "eq", $client_id[0]["cliente_id"])
            ->do("select")[0];

        $client_values = $tORM
            ->from("cliente")
            ->columns("cliente.contrasenia",  "cliente.email")
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("select")[0];
        $received_data = array_merge($web_values, $client_values);

        $new_web_data = [
            'web.primer_nombre' => $first_name ? $first_name : $received_data["primer_nombre"],
            'web.segundo_nombre' => $second_name ? $second_name : $received_data["segundo_nombre"],
            'web.primer_apellido' => $first_surname ? $first_surname : $received_data["primer_apellido"],
            'web.segundo_apellido' => $second_surname ? $second_surname : $received_data["segundo_apellido"],
        ];
        $new_client_data = [
            'cliente.contrasenia' => $passwd ? $passwd : $received_data["contrasenia"],
            'cliente.email' => $mail ? $mail : $received_data["email"]
        ];

        $new_client_values = array_merge(["cliente"], array_values($new_client_data));
        $object = $tORM
            ->from("cliente");

        $object =  call_user_func_array(array($object, "columns"), array_keys($new_client_data));
        $object =  call_user_func_array(array($object, "values"), $new_client_values);

        $result_1 = $object
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("update");
        //
        //
        //

        $new_web_values = array_merge(["web"], array_values($new_web_data));
        $object = $tORM
            ->from("web");

        $object =  call_user_func_array(array($object, "columns"), array_keys($new_web_data));
        $object =  call_user_func_array(array($object, "values"), $new_web_values);

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
function get_address(TORM $tORM, string $token)
{


    $length_verificator = (strlen(strval($token)) <= 15);


    $client_id = get_client_id($tORM, $token);

    if ($client_id && $length_verificator) {
        // Debo pedir los datos desde direccion y no desde cliente
        $address_values = $tORM
            ->from("direccion")
            ->columns('direccion.id', 'direccion.direccion', 'direccion.calle', 'direccion.barrio', 'direccion.ciudad', 'direccion.predeterminado')
            ->where("direccion.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->do('select');


        //
        //
        //
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
        ->joined_columns('web.primer_nombre', 'web.primer_apellido', 'web.segundo_nombre', 'web.segundo_apellido', 'web.numero', 'web.tipo')
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
            'documento' => $result['numero'],
            'tipoDocumento' => $result['tipo'],

        ];
        return $formatted_result;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}
function set_address(TORM $tORM, String $token, String $city, String $neighborhood = "", String $street, String $address)
{
    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 30];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }

    $client_id = get_client_id($tORM, $token);
    if ($client_id) {
        $address_id = $tORM
            ->do(query: "SELECT MAX(id) FROM direccion WHERE cliente_id = {$client_id[0]['cliente_id']}")[0];
        $address_id = intval(!empty($address_id[0]) ? $address_id[0] + 1 : 1);

        if ($address_id <= 3) {
            $response = $tORM
                ->from("direccion")
                ->columns("direccion.id", 'direccion.cliente_id', 'direccion.direccion', 'direccion.calle',  'direccion.ciudad')
                ->values('direccion', $address_id, intval($client_id[0]['cliente_id']), $address, $street, $city)
                ->do('insert');

            if ($neighborhood && $response == "OK, 200") {
                $tORM
                    ->from("direccion")
                    ->columns('direccion.barrio')
                    ->values('direccion', $neighborhood)
                    ->where("direccion.id", "eq",  $address_id)
                    ->do('update');
            }
            return $response;
        } else {
            return "ERROR 429, TOO MANY REQUESTS";
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}
function modify_address(TORM $tORM, String $token, Int $address_id,  String $city = "", String $neighborhood = "", String $street = "", String $address = "")
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
                ->values('direccion', ($state[0][0] ? 0 : 1))
                ->where('direccion.id', 'eq', $address_id)
                ->where('direccion.cliente_id', 'eq', $client_id[0]['cliente_id'])
                ->do('update');
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
                    ->columns("direccion.id", 'direccion.cliente_id', 'direccion.direccion', 'direccion.calle',  'direccion.ciudad', 'direccion.predeterminado')
                    ->values('direccion', (intval($key) + 1), intval($address['cliente_id']), $address['direccion'], $address['calle'], $address['ciudad'], intval($address['predeterminado']))
                    ->do('insert');
            }
        } else {
            return "ERROR 404, NOT FOUND";
        }
        return $response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}
function show_shop(TORM $tORM, $token)
{
    //Aqui tome otra "approach" al asunto de las sesiones, donde cree una forma diferente para chequerar que las sesion exista
    if ($token) {
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
    if (!empty($token) && $is_session) { //Si el token esta entre los valores 8 y 15, y no está vacío
        if ((strlen($token) < 8 || strlen($token) >= 15)) {
            return "400, BAD REQUEST: Wrong data length";
        } elseif ($client_id) {
            $favorites =  $tORM
                ->from("favorito")
                ->columns('favorito.menu_id')
                ->where("favorito.web_id", "eq", $client_id[0]["cliente_id"])
                ->join("menu", "menu.id", "favorito.menu_id")
                ->joined_columns("None column")
                ->where("menu.categoria", "eq", "Estandar")
                ->do("select");
        }
    }
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
            unset($foods[$key]['productos']);
            if ($food['id'] == $diet['vianda_id']) {
                $foods[$key]['dietas'][] = $diet['dieta'];
            }
        }
    }
    foreach ($foods as $food) {
        foreach ($menus as &$menu) { // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar

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
function buy_menu(TORM $tORM, String $token, Int $amount, Int $menu_id)
{
    //Esta funcion debe crear una entrada en paquete y recibe, donde se le daran sus datos
    $client_id = get_client_id($tORM, $token);

    $foods = $tORM
        ->from("conforma")
        ->columns("conforma.vianda_id")
        ->where("conforma.menu_id", "eq", intval($menu_id))
        ->do("select");

    $response = [];

    if ($client_id && $foods) {
        $order_id = $tORM
            ->do(query: "SELECT MAX(numero_de_pedido) FROM pide WHERE cliente_id = {$client_id[0]['cliente_id']}")[0];
        $order_id = $tORM
            ->do(query: "SELECT MAX(numero_de_pedido) FROM pide WHERE cliente_id = {$client_id[0]['cliente_id']}")[0];

        for ($i = 0; $i < $amount; $i++) { //Se repetirá por la cantidad de menues que se manden
            $actual_date = date('Y-m-d H:i:s');

            foreach ($foods as $food) {
                $response = $tORM
                    ->from("pide")
                    ->columns("pide.numero_de_pedido", "pide.menu_id", "pide.vianda_id", "pide.cliente_id",   "pide.fecha_pedido")
                    ->values("pide", ($order_id ? intval($order_id) : 1), intval($menu_id), intval($food["vianda_id"]), intval($client_id[0]["cliente_id"]),  strval($actual_date))
                    ->do("insert");
            }
        }



        return $response;
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function buy_multiple_menus(TORM $tORM, String $token, array $amounts, array $menus_ids)
{
    $response = '';
    if ($token && (count($amounts) == count($menus_ids))) {
        for ($i = 0; $i < count($amounts); $i++) {
            $response = buy_menu($tORM, $token, intval($amounts[$i]),  $menus_ids[$i]);
        }
        return $response == "OK, 200" ? $response : "ERROR 500, SERVER ERROR";
    } else {
        return "ERROR 400, WRONG DATA TYPE";
    }
}
function get_orders(TORM $tORM, $token) // Funcion incompleta
{

    $client_id = get_client_id($tORM, $token);
    $menu_id = $tORM
        ->from("pide")
        ->columns("pide.menu_id")
        ->where("pide.cliente_id", "eq", $client_id[0]['cliente_id'])
        ->do("select");
}
function get_fav_and_personal_menus(TORM $tORM, String $token)
{
    //Esta funcion devolvera tanto los menues personalizados como los menues con favoritos, pero no los estandar
    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        //debo pedir los menus con el mismo id que el de favorito y el mismo id que el de pide que sean personalizados
        $menus_array = [];
        $menu_id = $tORM
            ->from("pide")
            ->columns("pide.menu_id")
            ->where("pide.cliente_id", "eq", $client_id[0]['cliente_id'])
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
                    $menu['viandas'][$food['nombre']] = $food;
                }
            }
        }
        return $menus;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}

function get_menus(TORM $tORM)
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
                $menus[$key]['viandas'][$food['nombre']] = $food;
            }
        }
    }


    $filtered_menus = array_values($menus);


    return [$filtered_menus];
}

function get_foods(TORM $tORM) //
{
    //Funcion para recibir TODOS los menus, es una funcion para admin

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


    return [$filtered_menus];
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
        $menu_names = $tORM->do(query: "SELECT nombre FROM menu;");

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

        foreach ($foods as $food) {
            $result_conformation = $tORM
                ->from("conforma")
                ->columns("conforma.menu_id", "conforma.vianda_id")
                ->values("conforma", intval($menu_id[0]), intval($food))
                ->do("insert");
            buy_menu($tORM, 1, $token, $menu_id[0]);
        }
        if ($result_conformation ==  $result_menu) {
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
        ->join("pide", "pide.menu_id", "menu.id")
        ->joined_columns("None column")
        ->where("pide.cliente_id", "eq", $client_id[0]["cliente_id"])
        ->do("select");

    if ($menu_existence) {
        $deletion_result_one = $tORM
            ->from("conforma")
            ->where("conforma.menu_id", "eq", $menu_id)
            ->do("delete");
        $deletion_result_two = $tORM
            ->from("pide")
            ->where("pide.menu_id", "eq", $menu_id)
            ->do("delete");
        $deletion_result_three = $tORM
            ->from("menu")
            ->where("menu.id", "eq", $menu_id)
            ->do("delete");
        if ($deletion_result_one == $deletion_result_two && $deletion_result_two == $deletion_result_three) {
            return "OK, 200";
        } else {
            return [$deletion_result_one, $deletion_result_two, $deletion_result_three];
        }
    } else {
        return "ERROR 403, FORBIDDEN";
    }
}

function modify_personal_menu(TORM $tORM, String $token, Int $menu_id, Int $frequency, String $description, array $foods) //
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
        ->where("menu.id", "eq", $menu_id)
        ->join("pide", "pide.menu_id", "menu.id")
        ->joined_columns("None column")
        ->where("pide.cliente_id", "eq", $client_id[0]["cliente_id"])
        ->do("select");

    if ($menu_existence) {

        $result_one = delete_personal_menu($tORM, $token, $menu_id);
        $result_two = create_personal_menu($tORM, $token, $menu_existence[0]["nombre"], $frequency, $description, $foods);
        if ($result_one == $result_two) {
            return "OK, 200";
        } else {
            return "ERROR 500, SERVER ERROR";
        }
    } else {
        return "ERROR 404, NOT FOUND";
    }
}

function login_bussiness() //
{
}

function register_bussiness() //
{
}

function modify_bussiness() //
{
}

function show_food_list() //
{
}

function credit_card_change() //
{
}

function address_create(/*token, numero, calle, barrio, ciudad*/) //
{
}

function address_change(/*token, numero, calle, barrio, ciudad*/) //
{
}

function change_password() //
{
}

function recover_password() //a travez de correo electronico se enviara un codigo que debe usar en vez de contrasenia
{
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
function get_client_menus(TORM $tORM, String $token) //Funcion incompleta!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
{
    //Esta funcion devolvera tanto los menues personalizados como los menues con favoritos, es especial para admins, para ver TODOS los menues
    $client_id = get_client_id($tORM, $token);

    if ($client_id) {
        //debo pedir los menus con el mismo id que el de favorito y el mismo id que el de pide que sean personalizados
        $menus_array = [];
        $menu_id = $tORM
            ->from("pide")
            ->columns("pide.menu_id")
            ->where("pide.cliente_id", "eq", $client_id[0]['cliente_id'])
            ->do("select");

        foreach ($menu_id as $id) {
            $menu = $tORM
                ->from("menu")
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

        $unique_menus = array_values($unique_menus);
        return $unique_menus;
    } else {

        return "ERROR 403, FORBIDDEN";
    }
}
*/