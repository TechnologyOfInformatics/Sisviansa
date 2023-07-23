<?php

class QueryCall
{
  private $host, $user, $passwd, $database, $port;
  public $query;
  public function __construct($host, $user, $passwd, $database, $port)
  {
    $this->host = $host;
    $this->user = $user;
    $this->passwd = $passwd;
    $this->database = $database;
    $this->port = $port;
  }

  //ej: QueryCall($mySqli, $table, )->insert();

  ///////////////////////////////////////////////////////////////////////////CREACION//////////////////////////////////////////////////////////////////////////////////C

  public function insert($table, $values = [], $columns = [])
  {

    $string = "";
    $columns_str = "";
    //transforma el array de values en un string ideal para usarlo en sql
    for ($i = 0; $i < count($columns); $i++) {
      print_r($values[0]);
      $string .= "'" . $values[$i] . "', ";
      $columns_str .= "$columns[$i], ";
    }

    $string = substr($string, 0, -2);
    $columns_str = substr($columns_str, 0, -2);

    $set = $table . "(" . $columns_str . ")";
    $this->query = "INSERT INTO $set VALUES ($string) ";
    return $this;
  }

  ///////////////////////////////////////////////////////////////////////////LECTURA/BUSQUEDA////////////////////////////////////////////////////////////////////////R

  public function select($table, $columns = [], $values = [], $identifiers = [])
  {

    $string = '';
    for ($i = 0; $i < count($columns); $i++) {
      $string .= "$columns[$i], ";
    }
    $string = substr($string, 0, -2);


    if ($identifiers) {
      $condition = '';

      for ($i = 0; $i < count($identifiers); $i++) {
        $condition .= " $identifiers[$i]='$values[$i]' AND ";
      }

      $condition = substr($condition, 0, -4);

      $this->query = "SELECT $string FROM $table WHERE$condition";
    } else {
      $this->query = "SELECT $string FROM $table";
    }
    return $this;
  }

  ///////////////////////////////////////////////////////////////////////////ACTUALIZACION///////////////////////////////////////////////////////////////////////////U
  public function update($table, $values = [], $identifiers = [], $columns = [])
  {
    // Esta es medio un embole ya que necesita los valores a cambiar, las casillas a cambiar, el identificador
    //que sera una cantidad de casillas pk, y el valor que han de tener, el cual es parte de columnas y valores
    $string = '';
    for ($i = 0; $i < count($columns); $i++) {
      $string .= "$columns[$i]='$values[$i]', ";
    }

    $string = substr($string, 0, -2);

    $condition = '';
    for ($i = 0; $i < count($identifiers); $i++) {
      $condition .= "$identifiers[$i]='$values[$i], '";
    }
    $condition = substr($condition, 0, -2);
    $this->query = "UPDATE $table SET $string WHERE $condition";

    return $this;
  }

  ///////////////////////////////////////////////////////////////////////////ELIMINACION////////////////////////////////////////////////////////////////////////D

  public function delete($table, $values = [], $identifiers = [])
  {
    $condition = '';
    for ($i = 0; $i < count($identifiers); $i++) {
      $condition .= "$identifiers[$i]='$values[$i]', ";
    }
    $condition = substr($condition, 0, -2);

    $this->query = "DELETE FROM $table WHERE $condition";
    return $this;
  }
  ////////////////////////////////////////////////////////////////////////////Query Setter/////////////////////////////////////////////////////////////////////
  public function setQuery($query)
  {
    $this->query = $query;
    return $this;
  }
  ///////////////////////////////////////////////////////////////////////////Calling///////////////////////////////////////////////////////////////////////////

  public function call()
  {
    $connect = new mysqli(
      $this->host,
      $this->user,
      $this->passwd,
      $this->database,
      $this->port
    );

    if ($connect->connect_errno) {
      $error =   $connect->connect_error;
      exit();
    }

    if ($this->query) {
      $queryType = strtoupper(explode(" ", $this->query)[0]);

      if ($queryType === "SELECT") {
        $result = $connect->query($this->query);

        if ($result) {
          $lists = $result->fetch_all();
          $response = [];
          if (gettype($lists[0]) === "array" || count($lists) === 1) {
            $response = $lists[0];
          } else {
            $response = $lists;
          }
        } else {
          $response = "Error en la consulta: " . $connect->error; // Consulta con error
        }
      } else {
        // Consulta INSERT, UPDATE o DELETE
        $result = $connect->query($this->query);
        if ($result && isset($connect->affected_rows)) {
          $response = ["OK", 200];
        } else {
          $response = "Error en la consulta: " . $connect->error;
        }
      }
      return $response;
    }
  }
}

/*
Puedes bien enviar los datos basicos con insert, select, update y delete, o determinar el query a enviar con setQuery, despues usando call() para
enviar el query directamente, porfavor usa el insert, select, update y delete de la forma correcta, sin florituras, si quieres usar un join no hay lío si usas
el setter de query, pero los demas son lo más basico.
select tiene 2 modos, uno con el identifier y otro sin, el sin te traerá los datos sin discriminacion, el otro que seria el search te da la opcion de usar los
identificadores para buscar de forma discriminada, identificador es un array, donde cada identificador debe corresponder a un valor ($values[n]) en su orden, 
el primer identificador usara siempre el primer valor, y así, por ahora no podemos usar OR, usara siempre un AND

REGLA:
  En caso de que la llamada haya sido exitosa (hayan o no lineas afectadas) se devolverá un array pero si no fue exitosa se devolverá un error
*/