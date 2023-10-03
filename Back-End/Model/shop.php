<?php
include_once "Auth\authorization.php";
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

$shop = __FILE__;
function shop_show_shop(string $token = "")
{
    global $tORM;
    return show_shop($tORM, $token);
}
