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
//
//
function modify_web(TORM $tORM, string $token, $passwd = "", $first_name = "", $second_name = "", $first_surname = "", $second_surname = "", $address = "",  $street = "", $neighborhood = "", $city = "", $mail = "")
{

    $values = func_get_args();

    unset($values[0]);
    $values = array_values($values);

    $length_verificator = True;

    $maximum = [15, 30, 30, 30, 30, 30, 10, 30, 30, 20, 25];

    foreach ($values as $index => $var) {
        $length_verificator = $length_verificator && (strlen(strval($var)) <= $maximum[$index]);
    }
    if ($passwd) {
        $passwd = md5($passwd);
    }

    $client_id = $tORM
        ->from("inicia")
        ->columns("inicia.cliente_id")
        ->where("inicia.sesion_token", "eq", $token)
        ->do("select");

    if ($client_id && $length_verificator) {

        $web_values = $tORM
            ->from("web")
            ->columns("web.primer_nombre", "web.primer_apellido", "web.segundo_nombre", "web.segundo_apellido")
            ->where("web.cliente_id", "eq", $client_id[0]["cliente_id"])
            ->do("select")[0];

        $client_values = $tORM
            ->from("cliente")
            ->columns("cliente.contrasenia", "cliente.numero", "cliente.calle", "cliente.barrio", "cliente.ciudad", "cliente.email")
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
            'cliente.numero' => $address ? $address : $received_data["numero"],
            'cliente.calle' => $street ? $street : $received_data["calle"],
            'cliente.barrio' => $neighborhood ? $neighborhood : $received_data["barrio"],
            'cliente.ciudad' => $city ? $city : $received_data["ciudad"],
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
            return $result_1;
        }
        return "ERROR 500, SERVER ERROR";
    } else {
        return "ERROR 404: NOT FOUND";
    }
}

function get_address(TORM $tORM, string $token)
{

    $length_verificator = True;

    $length_verificator = $length_verificator && (strlen(strval($token)) <= 15);


    $client_id = $tORM
        ->from("inicia")
        ->columns("inicia.cliente_id")
        ->where("inicia.sesion_token", "eq", $token)
        ->do("select");

    if ($client_id && $length_verificator) {

        $client_values = $tORM
            ->from("cliente")
            ->columns("cliente.contrasenia", "cliente.numero", "cliente.calle", "cliente.barrio", "cliente.ciudad", "cliente.email")
            ->where("cliente.id", "eq", $client_id[0]["cliente_id"])
            ->do("select")[0];
        $address = [
            'numero' => $client_values["numero"],
            'calle' => $client_values["calle"],
            'barrio' => $client_values["barrio"],
            'ciudad' => $client_values["ciudad"]
        ];
        //
        //
        //
        return in_array('', array_values($address)) ? [] : [ $address] ;
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
        ->join("web", "web.cliente_id", "cliente.id")
        ->joined_columns('web.primer_nombre', 'web.primer_apellido', 'web.segundo_nombre', 'web.segundo_apellido', 'web.numero', 'web.tipo')
        ->join("cliente_simplificado", "cliente_simplificado.id", "web.cliente_id")
        ->joined_columns('cliente_simplificado.email', 'cliente_simplificado.calle', 'cliente_simplificado.barrio', 'cliente_simplificado.ciudad')
        //
        //
        ->do("select");
    if ($result) {
        $result = $result[0];
        $because_i_used_numero_twice = $tORM
            ->from('cliente_simplificado')
            ->columns('cliente_simplificado.numero')
            ->join('inicia', 'inicia.cliente_id', 'cliente_simplificado.id')
            ->joined_columns('None column')
            ->where('inicia.sesion_token', 'eq', $token)
            ->do('select');
        $formatted_result = [
            'primerNombre' => $result['primer_nombre'],
            'primerApellido' => $result['primer_apellido'],
            'segundoNombre' => $result['segundo_nombre'],
            'segundoApellido' => $result['segundo_apellido'],
            'correo' => $result['email'],
            'direccion' => [$because_i_used_numero_twice[0]['numero'], $result['calle'], $result['barrio'], $result['ciudad']],
            'documento' => $result['numero'],
            'tipoDocumento' => $result['tipo'],

        ];
        return $formatted_result;
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

function buy_menu()
{
}
function create_menu()
{
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
function address_change(/*token,id_debil, numero, calle, barrio, ciudad*/)
{
}
function change_password()
{
}
function recover_password()
{
}

function proto_session(TORM $tORM)
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
