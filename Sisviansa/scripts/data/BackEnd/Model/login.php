<?php
include_once "Auth\authorization.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
$login = __FILE__;

function login_login($mail, $passwd, string $token = "")
{
    global $ctl;
    return login($ctl, $mail, $passwd, $token);
}
