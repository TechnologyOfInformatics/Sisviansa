<?php
include_once "Data/database_model.php";
include_once "Data/ORM-V1.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

$authorization = __FILE__;
function datatype($var, $type)
{
    return gettype($var) === $type;
}

function session_close(QueryCall $ctl, $token)
{
    if (!isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!datatype($token, "string")) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (strlen($token) >= 15 || strlen($token) < 8) {
        return "400, BAD REQUEST: Wrong data type";
    }


    $ctl->delete("inicia", ["$token"], ["sesion_token"])->call();
    $ctl->update("sesion", [$token, "Finalizada"], ["token"], ["token", "estado"])->call();
    return [False];
}

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

function session(QueryCall $ctl, $token)
{
    if (!isset($ctl, $token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!is_string($token)) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (strlen($token) >= 15 || strlen($token) < 8) {
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

function register_web_second(QueryCall $ctl, $token, $second_name, $second_surname, $street, $neighborhood, $city)
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

    if (!isset($ctl, $second_name, $second_surname, $street, $neighborhood, $city)) {
        return "400, BAD REQUEST: Missing data";
    } elseif (!$type_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    } elseif (!$length_verificator) {
        return "400, BAD REQUEST: Wrong data type";
    }

    $user = session($ctl, $token);
    $id = $ctl->select("inicia", ["cliente_id"], [$token], ["sesion_token"])->call()[0];
    if ($user[0]) {
        return $ctl->update("web", [$id, $second_name, $second_surname], ["cliente_id"], ["cliente_id", "segundo_nombre", "segundo_apellido"])->call();
    } else {
        return "401, UNAUTHORIZED: The session expired";
    }
}



//
//
//
//
function modify_web(QueryCall $ctl, TORM $tORM, string $token, $passwd = "", $first_name = "", $second_name = "", $first_surname = "", $second_surname = "", $street = "", $neighborhood = "", $city = "", $mail = "")
{

    $values = func_get_args();

    unset($values[0]);
    unset($values[1]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 30, 30, 30, 30, 20, 25];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if ($passwd) {
        $data_array_web["web.contrasenia"] = md5($values[1]);
    }
    unset($values[0]);
    $values = array_values($values);

    $column_array_web = ["web.primer_nombre", "web.segundo_nombre", "web.primer_apellido", "web.segundo_apellido", "web.calle", "web.barrio", "web.ciudad"];
    $column_array_cliente = $mail ? array(["cliente.email"] => $mail) : [];
    $data_array_web = [];
    print($values);
    foreach ($column_array_web  as $index => $column) {
        if ($values[$index]) {
            $data_array_web[$column] = $values[$index];
        }
    }
    $client_id = $tORM
        ->from("inicia")
        ->columns("inicia.cliente_id")
        ->where("inicia.sesion_token", "eq", $token)
        ->do("select");

    if ($client_id) {

        array_unshift($data_array_web, "web");
        print_r($column_array_web);
        print_r(($data_array_web));
        $object = $tORM
            ->from("web");

        $object =  call_user_func_array(array($object, "columns"), $column_array_web);
        $object =  call_user_func_array(array($object, "values"), array_values($data_array_web));
        $result = $object
            ->where("web.cliente_id", "eq", $client_id[0]["cliente_id"])
            ->do("update");

        $result = $tORM
            ->from("cliente_simplificado")
            ->where("cliente_simplificado.id", "eq", $client_id[0]["cliente_id"])
            ->do("select");
        return $result;
    } else {
        return "ERROR 404: NOT FOUND";
    }
}

function user_information(TORM $tORM, $token)
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
        ->join("cliente_simplificado", "cliente_simplificado.id", "cliente.id")
        ->join("web", "web.cliente_id", "cliente_simplificado.id")
        //
        //
        ->do("select");
    if (gettype($result) != "string") {
        $new_result = [
            0 => $result["primer_nombre"],
            1 => $result["primer_apellido"],
            2 => $result["segundo_nombre"],
            3 => $result["segundo_apellido"],
            4 => $result["email"],
            5 => $result["numero"],
            6 => $result["tipo"],
            'direccion' => [
                $result["calle"],
                $result["barrio"],
                $result["ciudad"]
            ]
        ];
        return $new_result;
    } else {
        return $result;
    }
}

function show_shop(TORM $tORM, $token)
{
    if ($token) {
        $is_session = $tORM
            ->from("sesion")
            ->columns("sesion.token")
            ->where("sesion.token", "eq", $token)
            ->do("select");
    } else {
        $is_session = False;
    }
    $favorites = "";
    if (!isset($tORM)) {
        return "400 Bad Request: Missing data";
    } elseif (!empty($token) && $is_session) { //Si el token esta entre los valores 8 y 15, y no está vacío
        if ((strlen($token) < 8 || strlen($token) >= 15)) {
            return "400, BAD REQUEST: Wrong data length";
        } else {
            $favorites = $tORM
                ->from("favorito")
                ->columns("favorito.menu_id")
                ->join("inicia", "inicia.cliente_id", "favorito.web_id")
                ->joined_columns("inicia.cliente_id")
                ->where("inicia.sesion_token", "eq", $token)
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
    return [$menus, (gettype($favorites) == "string" ? $favorites : array_column($favorites, 'menu_id'))];
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

            $client_id = $tORM
                ->from("inicia")
                ->columns("inicia.cliente_id")
                ->where("inicia.sesion_token", "eq", $token)
                ->do("select");

            $favorites = $tORM
                ->from("favorito")
                ->where("favorito.web_id", "eq", $client_id[0]['cliente_id'])
                ->where("favorito.menu_id", "eq", $menu_id)
                ->do("select");
            $toggle_state = False;
            if ((gettype($favorites) == "array")) {

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
            } else {
                return gettype($favorites);
            }

            return [$toggle_state, $menu_id];
        }
    } else {
        return $is_session;
    }
}

function login_bussiness()
{
}
function register_bussiness()
{
}
function modify_bussiness()
{
}
function show_food_list()
{
}
function credit_card_change()
{
}
function address_change()
{
}
