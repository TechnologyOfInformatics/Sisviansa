<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Credentials: true");
require_once(dirname(__FILE__) . '/' .  "../Auth/authorization.php");
$login = __FILE__;

function login_login($mail, $passwd, $token = "")
{
    global $ctl;
    return login($ctl, $mail, $passwd, $token);
}
