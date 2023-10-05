<?php
include_once "Auth\authorization.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
$login = __FILE__;

function options_modify_web($token, $passwd = "", $first_name = "", $second_name = "", $first_surname = "", $second_surname = "", $address_number = "", $street = "", $neighborhood = "", $city = "", $mail = "")
{
    global $tORM;
    return modify_web($tORM, $token, $passwd, $first_name, $second_name, $first_surname, $second_surname, $address_number, $street, $neighborhood, $city, $mail);
}
function options_get_address($token)
{
    global $tORM;
    return get_address($tORM, $token);
}
