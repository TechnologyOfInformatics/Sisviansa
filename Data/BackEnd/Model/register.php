<?php

require_once("Auth/authorization.php");

$register = __FILE__;


function register_register_web_first($first_name, $first_surname, $doc_type, $doc, $mail, $password)
{
    global $ctl;
    return register_web($ctl, $first_name, $first_surname, $doc_type, $doc, $mail, $password);
}
