<?php
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
$index = __FILE__;

function user_info($token)
{
    global $tORM;
    return user_info($tORM, $token);
}

function admin_get_menus($token)
{

    global $tORM;
    return get_fav_and_personal_menus($tORM, $token);
}
