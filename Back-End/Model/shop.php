<?php
include "base.php";
include "../Data/database_model.php";

function shop_show_shop($token = "")
{
    global $ctl;
    show_shop($ctl, $token);
}
