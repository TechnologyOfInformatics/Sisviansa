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
/*
echo "<br/>Sin valores:<br/>";
print_r(options_get_address("X6Q?3ucsNs"));
echo "<br/>Con valores:<br/>";
print_r(options_get_address("12312334f234"));
echo "<br/>Con token invalido:<br/>";
print_r(options_get_address("12312334f34"));
*/
// Función de comparación personalizada


echo "<pre>";
//print_r(delete_address($tORM, 'x2312x23d2d2', 2));
//print_r(set_address($tORM, 'x2312x23d2d2', 'Chicago', '', 'Bella visasdasdasdta', '12345'));
//print_r(modify_address($tORM, 'x2312x23d2d2', 2, 'asd', 'algass', '', ''));

print_r(delete_phone($tORM, 1, '0910509731'));
echo "<pre/>";
#las peticiones se harán de forma que llegaran a los archivos definidos para cada parte, despues se enviaran a authentication.php para verificar que esten bien formados, de ahi los 
# redireccionará a la data, creando las llamadas o enviará un error si la autenticacion no fue correcta, entonces tendrémos 3 tipos de errores: error de escritura, error de contingencia y error de no encontrado
