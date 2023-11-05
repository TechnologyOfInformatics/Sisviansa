<?php
include_once "Auth\authorization.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Origin, Authorization, X-Requested-With, Content-Type, Accept");
header("Access-Control-Allow-Credentials: true");
$register = __FILE__;


function register_register_web_first($first_name, $first_surname, $doc_type, $doc, $mail, $password)
{
    global $ctl;
    return register_web_first($ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password);
}

function register_register_web_second($token, $second_name, $second_surname, $street, $neighborhood, $city)
{
    global $ctl;
    return register_web_second($ctl, $token,  $second_name, $second_surname, $street, $neighborhood, $city);
}

function register_register_bussiness_first()
{
}

function register_register_bussiness_second()
{
}
