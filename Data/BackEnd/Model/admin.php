<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");
$index = __FILE__;

////////////////////////////////////////DEBE SER MODIFICADO PARA CONECTARSE CON LA BASE EN VEZ DE USAR TOKENS

function user_info($token)
{
    global $tORM;
    return user_info($tORM, $token);
}

function admin_get_menus($token)
{

    global $tORM;
    return get_menus($tORM, $token);
}

function admin_get_foods($token)
{

    global $tORM;
    return get_foods($tORM, $token);
}
