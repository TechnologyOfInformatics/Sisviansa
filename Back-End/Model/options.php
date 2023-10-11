<?php
include_once "Auth\authorization.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
$login = __FILE__;

function options_modify_web($token, $passwd = "", $confirm_passwd = "", $first_name = "", $second_name = "", $first_surname = "", $second_surname = "",  $mail = "")
{
    global $tORM;
    return modify_web($tORM, $token, $passwd, $confirm_passwd, $first_name, $second_name, $first_surname, $second_surname,  $mail);
}
function options_get_address($token)
{
    global $tORM;
    return get_address($tORM, $token);
}
function options_user_info($token)
{
    global $tORM;
    return user_information_web($tORM, $token);
}

function options_get_special_menus($token)
{

    global $tORM;
    return get_fav_and_personal_menus($tORM, $token);
}

function options_create_personal_menu(String $token, String $name, Int $frequency, String $description, array $foods)
{
    global $tORM;
    return create_personal_menu($tORM, $token, $name, $frequency, $description, $foods);
}

function options_mod_personal_menu(String $token, Int $menu_id, Int $frequency, String $description, array $foods)
{
    global $tORM;
    return modify_personal_menu($tORM, $token, $menu_id, $frequency, $description, $foods);
}
function options_del_personal_menu(String $token, Int $menu_id)
{
    global $tORM;
    return delete_personal_menu($tORM, $token, $menu_id);
}
