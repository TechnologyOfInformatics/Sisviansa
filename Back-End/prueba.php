<?php
include_once "server.php";

echo $base . "<br>";
echo $index . "<br>";
echo $login . "<br>";
echo $menu . "<br>";
echo $register . "<br>";
echo $shop . "<br>";
echo $database_model . "<br>";
echo $authorization . "<br>";
/*
$ctl->setQuery("DELETE inicia, sesion, web
FROM cliente
LEFT JOIN inicia ON cliente.id = inicia.cliente_id
LEFT JOIN sesion ON inicia.sesion_token = sesion.token
LEFT JOIN web ON cliente.id = web.cliente_id OR inicia.cliente_id = web.cliente_id
WHERE cliente.email = 'amsdassdsasda';")->call();
$ctl->delete("cliente", ["amsdassdsasda"], ["email"])->call();*/

//print_r(register_register_web_first("maxi", "da silva", "CI", "5088325", "amsdassdsasda", "asdasddasdas"));

echo "<pre>";
options_modify_web("X6Q?3ucsNs");
echo "<pre/>";
#las peticiones se harán de forma que llegaran a los archivos definidos para cada parte, despues se enviaran a authentication.php para verificar que esten bien formados, de ahi los 
# redireccionará a la data, creando las llamadas o enviará un error si la autenticacion no fue correcta, entonces tendrémos 3 tipos de errores: error de escritura, error de contingencia y error de no encontrado
