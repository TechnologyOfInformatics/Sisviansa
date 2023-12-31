<?php

require_once("Auth/authorization.php");

$login = __FILE__;

function options_modify_web($token, $first_name = "", $second_name = "", $first_surname = "", $second_surname = "",  $mail = "")
{
    global $tORM;
    return modify_web($tORM, $token, $first_name, $second_name, $first_surname, $second_surname,  $mail);
}

function options_get_address(String $token)
{
    global $tORM;
    return get_address($tORM, $token);
}

function options_set_address($token, String $city, String $neighborhood = "", String $street, String $address)
{
    global $tORM;
    return set_address($tORM, $token, $city, $neighborhood,  $street,  $address);
}

function options_modify_address(String $token, Int $address_id,  String $city = "", String $neighborhood = "", String $street = "", String $address = "")
{
    global $tORM;
    return modify_address($tORM, $token, $address_id,  $city, $neighborhood, $street, $address);
}

function options_delete_address(String $token, Int $address_id)
{
    global $tORM;
    return delete_address($tORM, $token, $address_id);
}

function options_toggle_default(String $token, Int $address_id)
{
    global $tORM;
    return toggle_default($tORM, $token, $address_id);
}

function options_user_info($token)
{
    global $tORM;
    return user_information_web($tORM, $token);
}

function options_get_special_menus($token)
{

    global $tORM;
    return get_personal_menus($tORM, $token);
}

function options_get_personal_menus($token)
{

    global $tORM;
    return get_personal_menus($tORM, $token);
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

function options_change_password(String $token, String $actual_passwd, String $passwd, String $confirm_passwd)
{
    global $tORM;
    global $ctl;
    return change_password($tORM, $ctl, $token, $actual_passwd, $passwd, $confirm_passwd);
}


function options_get_orders(String $token)
{
    global $tORM;
    return get_client_orders($tORM, $token);
}

function options_create_credit_card(String $token, String $card_code, String $expire_date, String $name)
{
    global $tORM;
    return create_credit_card($tORM, $token, $card_code, $expire_date, $name);
}

function options_delete_credit_card(String $token, String $verification_code, String $expire_date, String $name)
{
    global $tORM;
    return delete_credit_card($tORM, $token, $verification_code, $expire_date, $name);
}

function options_get_credit_card(String $token)
{
    global $tORM;
    return get_credit_card($tORM, $token);
}
function  options_get_business($token)
{

    global $tORM;
    return get_business($tORM,  $token);
}

function  options_create_client_phone(String $token, Int $number)
{

    global $tORM;
    return create_client_phone($tORM,  $token, $number);
}
