<?php
include "base.php";
include "login.php";
include "../Data/database_model.php";


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
