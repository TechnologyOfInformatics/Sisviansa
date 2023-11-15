<?php

require_once("Auth/authorization.php");


$shop = __FILE__;
function shop_show_shop(string $token = "", $order = [])
{
    global $tORM;
    return show_shop($tORM, $token, $order);
}
function shop_favorites_toggle(string $token, int $menu_id)
{
    global $tORM;
    return toggle_favorites($tORM, $token, $menu_id);
}

function shop_buy_menu(String $token, array $amount, array $menu_id)
{

    global $tORM;
    return buy_multiple_menus($tORM, $token, $amount, $menu_id);
}

function shop_get_address($token)
{
    global $tORM;
    return get_address($tORM, $token);
}
