<?php
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");
$index = __FILE__;

////////////////////////////////////////DEBE SER MODIFICADO PARA CONECTARSE CON LA BASE EN VEZ DE USAR TOKENS
//
//
// FALTA IMPLEMENTAR INICIO DE SESION DE USUARIOS DEL SISTEMA
//
//
function admin_get_menus()
{

    global $tORM;
    return get_menus($tORM);
}

function admin_get_foods()
{

    global $tORM;
    return get_foods($tORM);
}


function admin_get_orders($mail, $passwd)
{

    global $tORM;
    global $ctl;
    return get_orders($tORM, $ctl, $mail, $passwd);
}

function admin_change_order_state($order_id, $new_state)
{

    global $tORM;
    return change_order_state($tORM, $order_id, $new_state);
}

function admin_register_bussiness($rut, $name, $mail, $password)
{

    global $ctl;
    return register_bussiness($ctl, $rut, $name, $mail, $password);
}

function admin_change_bussiness_mail($rut, $name, $new_mail, $mail, $password)
{

    global $tORM;
    global $ctl;
    return change_bussiness_mail($tORM, $ctl, $rut, $name, $new_mail, $mail, $password);
}

function admin_show_user_list($type, $id, $id_type)
{

    global $tORM;
    return show_user_list($tORM, $type, $id, $id_type);
}

function admin_change_buss_passwd($mail, $actual_passwd, $passwd, $confirm_passwd)
{

    global $tORM;
    global $ctl;
    return change_bussiness_password($tORM, $ctl, $mail, $actual_passwd, $passwd, $confirm_passwd);
}

function admin_create_food($name, $time, $products, $calories, $price)
{

    global $tORM;
    return create_food($tORM, $name, $time, $products, $calories, $price);
}

function admin_delete_food($food_id)
{

    global $tORM;
    return delete_food($tORM, $food_id);
}

function admin_modify_food($food_id, $name, $time, $products, $calories, $price)
{

    global $tORM;
    return modify_food($tORM, $food_id, $name, $time, $products, $calories, $price);
}

function admin_toggle_food_diet($state, $food_id, $diet)
{

    global $tORM;
    return toggle_food_diet($tORM, $state, $food_id, $diet); //State es para determinar si se quiere agregar (true) o quitar (false)
}

function admin_create_menu($name,  $frequency,  $description,  $foods)
{

    global $tORM;
    create_menu($tORM,  $name,  $frequency,  $description,  $foods);
}
function  admin_delete_menu($menu_id)
{

    global $tORM;
    delete_menu($tORM,  $menu_id);
}
function  admin_modify_menu($menu_id,  $name,  $frequency,  $description)
{

    global $tORM;
    modify_menu($tORM,  $menu_id,  $name,  $frequency,  $description);
}
function  admin_change_menu_stock($menu_id,  $change)
{

    global $tORM;
    change_menu_stock($tORM,  $menu_id,  $change);
}
