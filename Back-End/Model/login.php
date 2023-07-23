<?php
include "base.php";
include "../Data/database_model.php";
function login_login($mail, $passwd, $token = "")
{
    global $ctl;
    return login($ctl, $mail, $passwd, $token);
}
