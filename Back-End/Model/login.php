<?php

require_once("Auth/authorization.php");

$login = __FILE__;

function login_login($mail, $passwd, $token = "")
{
    global $ctl;
    return login($ctl, $mail, $passwd, $token);
}
