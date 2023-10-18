<?php
include_once "Auth\authorization.php";

header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

$ctl = new QueryCall("localhost", "root", "", "sisviansa_techin_v1", 3306);
$tORM = new TORM("localhost", "root", "", "sisviansa_techin_v1", 3306);
$base = __FILE__;

function fast_verification_doc($doc_type, $doc)
{
    global $ctl;
    return [!empty($ctl->select("web", ["numero"], [$doc_type, $doc], ["documento_tipo", "documento_numero"])->call())];
}

function fast_verification_mail($mail)
{
    global $ctl;
    return [empty($ctl->select("web", ["correo"], [$mail], ["correo"])->call())];
}

function base_session($token)
{
    global $ctl;
    return session($ctl, $token);
}

function base_session_close($token)
{
    global $ctl;
    return session_close($ctl, $token);
}


/*EJEMPLOS:

Usando el formato para select:
    print_r($ctl->insert("tabla", ["algo loqúisimo"], ["algo"])->call());

    print_r($ctl->select("tabla", [2], ["id"], ["id", "algo"])->call());
        Resumen: (α∈D): ∀ δ, n = δ -> ∀ δ[n] ∃ γ[n]

    print_r($ctl->update("tabla", [1, "algo cambiado"], ["id"], ["id", "algo"])->call());

    print_r($ctl->delete("tabla", [2], ["id"])->call());

    print_r($ctl->setQuery("SELECT * FROM tabla WHERE id>2")->call());

*/