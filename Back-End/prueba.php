<?php
include_once "./Data/database_model.php";

#$ctl = new QueryCall("localhost", "root", "", "awarena meinu", 3306);

$rest = substr("abcdefghijk", 0, -4);
echo $rest;
function datatype($variable, $tipo)
{
    if (gettype($variable) === $tipo) {
        echo "Es verdadero que la variable es de tipo $tipo <br>";
    } else {
        echo "No es verdadero que la variable es de tipo $tipo <br>";
    }

    foreach (func_get_args() as $valor) {
        echo "Valor del argumento " . $valor . "<br>";
    }
}

$var1 = 1;
$var2 = "algo";
$var3 = [$var1, $var2];
echo "<br>";
datatype($var1, "string");
echo "<br>";
datatype($var1, "array");
echo "<br>";
datatype($var2, "string");
echo "<br>";
datatype($var3, "array");
echo "<br>";

$mail = "algo22332@mail.com";
$password = "dkapsdjasdjk";
$first_name = "pedro";
$first_surname = "vasquez";
$doc_type = "CI";
$doc = 12331112;


if (True) {
    $id = $ctl->select("cliente", ["id"], [$mail], ["email"])->call();
    print_r($id);
    echo "aca";
    $response = $ctl->insert("web", [$id[0], $first_name, $first_surname, $doc_type, $doc], ["cliente_id", "primer_nombre", "primer_apellido", "tipo", "numero"])->call();
    print_r($response);
}
echo "<br>";
echo date('Y-m-d H:i:s', strtotime(date('Y-m-d H:i:s') . ' +15 day'));




#las peticiones se harán de forma que llegaran a los archivos definidos para cada parte, despues se enviaran a authentication.php para verificar que esten bien formados, de ahi los 
# redireccionará a la data, creando las llamadas o enviará un error si la autenticacion no fue correcta, entonces tendrémos 3 tipos de errores: error de escritura, error de contingencia y error de no encontrado
