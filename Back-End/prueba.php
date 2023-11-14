<?php
include_once "server.php";

//echo $base . "<br>";
//echo $index . "<br>";
//echo $login . "<br>";
//echo $menu . "<br>";
//echo $register . "<br>";
//echo $shop . "<br>";
//echo $database_model . "<br>";
//echo $authorization . "<br>";
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

/*
$pedido = array(
    array(
        "menus" => array(
            3 => array(
                "cantidad" => 12,
                "id" => 3,
                "nombre" => "Menu3",
                "frecuencia" => 15,
                "categoria" => "Estandar",
                "precio" => 80.5,
            ),
        ),
        "pedido_id" => 3,
        "fecha_del_pedido" => "10/11/2023 05:03",
        "direccion" => array(
            20,
            "calle17",
            "barrio17",
            "ciudad17",
        ),
        "estados" => array(
            array(
                "id" => 3,
                "estado" => "En producción",
                "inicio_del_estado" => "2023-11-10 05:03:39",
                "final_del_estado" => "2023-11-11 05:03:39",
            ),
        ),
    ),
);*/


$simple_string = "Welcome to GeeksforGeeks";

// Display the original string
echo "Original String: " . $simple_string . "\n";

// Store cipher method
$ciphering = "BF-CBC";

// Use OpenSSL encryption method
$iv_length = openssl_cipher_iv_length($ciphering);
$options = 0;

// Use random_bytes() function to generate a random initialization vector (iv)
$encryption_iv = random_bytes($iv_length);

// Alternatively, you can use a fixed iv if needed
// $encryption_iv = openssl_random_pseudo_bytes($iv_length);

// Use php_uname() as the encryption key
$encryption_key = openssl_digest(php_uname(), 'MD5', TRUE);

// Encryption process
$encryption = openssl_encrypt(
    $simple_string,
    $ciphering,
    $encryption_key,
    $options,
    $encryption_iv
);

// Display the encrypted string
echo "Encrypted String: " . $encryption . "\n";

// Decryption process
$decryption = openssl_decrypt(
    $encryption,
    $ciphering,
    $encryption_key,
    $options,
    $encryption_iv
);

// Display the decrypted string
echo "Decrypted String: " . $decryption;

echo "<pre/>";
#las peticiones se harán de forma que llegaran a los archivos definidos para cada parte, despues se enviaran a authentication.php para verificar que esten bien formados, de ahi los 
# redireccionará a la data, creando las llamadas o enviará un error si la autenticacion no fue correcta, entonces tendrémos 3 tipos de errores: error de escritura, error de contingencia y error de no encontrado
