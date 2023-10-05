<?php

//
///
////
///// TECHIN OBJECT-RELATION MODEL, Version 1, Build "Basic"
////
///
//
// tablas[], // ["<tabla>.*"]|columnas[],
// null|joined_tables[],
// null|joined_columns[],
// null|condition[operand_one,condition:"<condicion entendible por sql>",operand_two], table.column
// null|'order':""|"ASC"|"DESC",
// null|'limit':Int
// ],


//Se determina la tabla, las columnas a usarse (o null para recibir todas si se usa select)
//Ademas se le puede dar un orden y un límite para la salida


//host = "nombre_del_servidor",
//user = "nombre_de_usuario",
//passwd = "contraseña",
//database = "nombre_de_la_base_de_datos",
//table = "*"; //Como por defecto será * para poder usarla en join eficazmente


//Estos datos serán los que se usen en la búsqueda real

//table_sets[ tabla[ columna[ 'type':"", 'size':"", 'options':[str] ], ...], ...]
//Sitaxis:




// state será para ver en que estado esta el objeto, donde si esta ready ya se puede usar request(), columns es el único paso que no genera su estado, porque se puede usar sin ser declarado

//El objeto variará mucho dependiendo de si está en modo "normal" o "join", cambiando el where (ya que podrá usar la otra tabla como referencia)

//query de por si se encarga de formar el query string, despues dependiendo de lo que le pediste hace un test, devuelve el query string sin hacer una llamada o hace una llamada normal
//Llamada normal devolverá la respuesta formateada de la bdd, test hará lo mismo pero con un rollback al final, y show mostrará el query

//formato base del objeto
class TORM //Techin Object-Relation Model (Basic)
{
    public String $error = "";
    //
    //
    private $host, $port, $user, $passwd, $database, $current_table, $state;
    private $table_sets = [];
    // table_sets[
    // '<tabla>'=>
    // '<columna>' =>
    // 'type':Str,
    // 'size':Int,
    // ...
    // ],
    // mas columnas...
    // ],
    // mas tablas...
    // ]
    //
    //
    private $data = [
            'table' => '',
            'joined_tables' => array(),
            'values' => array(),
            'conditions' => array()
        ],
        $sentenced_data = [
            'joined_sentence' => '',
            'condition' => '',
            'order' => '',
            'limit' => ''
        ];

    //
    //
    //data[
    // action:"<accion correspondiente>"
    // 'tables':[],
    // 'columns':["<tabla>.*"]|'columns':[],
    // null|joined_tables[],
    // null|joined_columns[],
    // null|condition[[operand_one,condition:"<condicion entendible por sql>",operand_two], ],
    // null|'order':""|"ASC"|"DESC",
    // null|'limit':Int
    // ],
    //
    //
    // Función para verificar si una tabla existe en la base de datos.

    private function is_table(String $table)
    {
        //Funcion encargada de verificar que una tabla dada exista
        //
        //
        $connect = new mysqli($this->host, $this->user, $this->passwd, 'information_schema', $this->port);
        if ($connect->connect_error) {
            die("Connection failed: " . $connect->connect_error);
        }

        $result_table = $connect->query("SELECT * FROM `INNODB_SYS_TABLES` WHERE `NAME` = '{$this->database}/{$table}';"); //////////////////// PUEDE DAR PROBLEMAS EN DOCKER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        $result_view = $connect->query("SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = '{$table}';");

        return (($result_table || $result_view) && ($result_table->num_rows > 0 || $result_view));
    }
    private function table_columns(String $table)
    {
        //Funcion privada para recibir las columnas de una tabla dada con sus tipos y por posibilidades/tamaños
        //
        //
        $column_info = array();
        $result = mysqli_query(new mysqli($this->host, $this->user, $this->passwd, $this->database, $this->port), "DESCRIBE {$table}");
        if ($result) {
            while ($row = mysqli_fetch_assoc($result)) {
                $column_name = $row['Field'];
                $column_type = $row['Type'];

                if (in_array($column_type, ['text', 'boolean'])) { //Tengo que actualizarlo si uso algun dato de otro tipo, creo...
                    $matches = [$column_type, $column_type];
                } else {
                    preg_match('/\((.*?)\)/', $column_type, $matches);
                }

                $datetype = array(
                    "date" => "YYYY-MM-DD",
                    "datetime" => "YYYY-MM-DD HH:MM:SS",
                    "timestamp" => "YYYY-MM-DD HH:MM:SS"
                );
                $default = in_array($column_type, array_keys($datetype)) ? $datetype[$column_type] : (intval($matches[1]) ? intval($matches[1]) : $matches[1]); //Que embole es ésto

                $column_info[strtolower($column_name)] = array(
                    'type' => explode("(", $column_type)[0],
                    'size/default' => $default
                );
            }
        }

        return $column_info;
    }
    //
    //
    public function __construct(String $host, String $user, String $passwd, String $database, Int $port)
    {
        // Etapa 0: Seteo de los datos
        $this->host = $host;
        $this->user = $user;
        $this->passwd = $passwd;
        $this->database = $database;
        $this->port = $port;
    }

    //
    //
    public function from(String $table)
    {
        // Etapa 1: Verificar la tabla
        // ...
        // Se cambia el state a "started"
        // Se setea table_sets con su primer tabla, usando la llamada antes para ver si existe
        //
        //
        $args = func_get_args();
        echo $this->error;
        if (in_array(null, $args) || in_array('', $args) || empty($table)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif ($this->is_table($table) && (empty($this->error))) {
            $this->data["table"] = $table;
            $this->current_table = $table;
            foreach ($this->table_columns($table) as $index => $column) {
                $this->table_sets[$table][strtolower($table . "." . $index)] = $column;
            }
        } else {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: Table does not exist" . "</br>";
            return $this;
        }

        return $this;
    }
    //
    //
    public function columns(String ...$columns)
    {
        // Etapa 2: Verificar las columnas
        // ...
        // Haré un ciclo for, para crear un array de columnas para poder usar, no sé si debo cambiarlo, el formato será tabla.columna, para evitar problemas con join
        //
        //
        if (in_array(null, $columns) || in_array('', $columns)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (count($columns) != 0 && empty($this->error)) {
            if (!($columns[0] == "None column") && str_contains($columns[0], ".")) {
                $syntax_verificator = True;

                $current_table_columns = $this->table_columns($this->current_table);
                foreach ($columns as $column) {
                    $column_array = explode(".", $column);
                    $syntax_verificator = ($syntax_verificator) && !empty($column_array) && $this->is_table(strtolower($column_array[0])) && in_array(strtolower($column_array[1]), array_keys($current_table_columns));
                }

                if ($syntax_verificator) {
                    foreach ($columns as $index => $column) {
                        $column_array = explode(".", $column);
                        foreach ($this->table_sets[$this->current_table] as $key => $value) {
                            if (!in_array($key, $columns)) {
                                unset($this->table_sets[$this->current_table][$key]);
                            }
                        }
                        $this->table_sets[$this->current_table][strtolower($columns[$index])] = $current_table_columns[strtolower($column_array[1])];
                    }
                } else {
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: There has been a syntax error on the columns" . "</br>";
                    return $this;
                }
            } else {
                $this->table_sets[$this->current_table] = [];
            }
        }

        return $this;
    }
    //Debo determinar el numero de columnas para verificar que el numero de valores dado es correcto, además debo de utilizar algo para buscar los tipos y largos de las columnas, y si son enum se buscarán los valores correctos
    //talvez además deba verificar el formato para los timestamp, date y datetime
    //
    //
    public function values(String $table, ...$values)
    {
        if (in_array(null, $values) || in_array('', $values)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (!isset($this->table_sets[$table])) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: The table is not valid" . "</br>";
            return $this;
        } elseif (count($values) == count($this->table_sets[$table]) && empty($this->error)) {
            $sql_php_types = [
                'varchar' => 'string',
                'int' => 'integer',
                'date' => 'string',
                'time' => 'string',
                'timestamp' => 'string',
                'boolean' => 'boolean',
                'enum' => 'string'
            ];
            $counter = 0;
            foreach ($this->table_sets[$table] as $index => $column) {
                if (isset($values[$counter])) {
                    if ($sql_php_types[$column['type']] == gettype($values[$counter])) {
                        $this->data['values'][$index] = $values[$counter];
                    } else {
                        $this->error .= strtoupper(__FUNCTION__) . " STEP: The values types are incorrect" . "</br>";
                        return $this;
                    }
                } else {
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: The values quantity is incorrect" . "</br>";
                    return $this;
                }
                $counter++;
            }
        } else {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: The values and columns quantity does not match" . "</br>";
            return $this;
        }
        return $this;
    }
    //
    //
    public function joined_columns(String ...$columns)
    {
        $args = func_get_args();
        if (in_array(null, $args) || in_array('', $args) || empty($args)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif ($this->state == "Join") {

            if (!($columns[0] == "None column")) {
                foreach ($columns as $column) {
                    $column_array = explode(".", $column);
                    if (!in_array(strtolower($column_array[1]), array_keys($this->table_columns($column_array[0])))) {
                        $this->error .= strtoupper(__FUNCTION__) . " STEP: The tables or columns given are incorrect" . "</br>";
                        return $this;
                    }
                }
                $this->columns(...$columns); // ... Es una forma de tratar a los arrays, siendo que en una funcion al ponerle ... a los parametros pasados es que comprimirá los parametros pasados en un array, mientras que aquí los descoprime
                foreach ($columns as $column) {
                    $this->data['joined_columns'][] = $column;
                }
            } else {
                $this->columns("None column");
            }
        } elseif (empty($this->error)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: Before joining columns you must join a table" . "</br>";
            return $this;
        }
        return $this;
    }
    //
    //
    public function join($table, $own_column, $joined_column)
    {
        // Etapa 3: Realizar join con otra tabla
        // ...
        // Se cambia el state a "join"
        // String column_string = "{$table}.*";
        // $this->data[joined_tables] = $table;
        // debo hacer un append o algo así, no se, python me tiene como loquita
        // Se crea una tabla nueva en table_sets para esta tabla con todas las columnas de la misma
        //
        //
        $args = func_get_args();
        $own_column_array = explode(".", $own_column);
        $joined_column_array = explode(".", $joined_column);
        if (in_array(null, $args) || in_array('', $args) || empty($args)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (empty($this->error) && $this->is_table($table)) {
            if (in_array(strtolower($own_column_array[1]), array_keys($this->table_columns($own_column_array[0]))) && in_array(strtolower($joined_column_array[1]), array_keys($this->table_columns($joined_column_array[0])))) {
                $temporal_table = $this->data['table'];
                $this->from($table);
                $this->data['table'] = $temporal_table;
                $this->data['joined_tables'][] = $table;
                $this->sentenced_data['joined_sentence'] .= " JOIN {$table} ON {$own_column} = {$joined_column}";
                $this->state = "Join";
            }
        } else {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: Failed to form a join" . "</br>";
            return $this;
        }
        return $this;
    }
    //
    //
    public function where(String $operand_one, String $condition, String $operand_two) //Condition: 'eq'|'neq'|'gt'|'st'|'gte'|'ste'|'like'|'null'|'nnull'
    { // Etapa 4: Establecer condiciones WHERE
        // ...
        // Se cambia el state al correspondiente, sea de : condition set o : condition and limit set
        // if (state == "join") {
        // Where variará si el estado está o no en "joining", si está en join entonces ha de dividir el operand_one y operand_two en 2, divididos por un ., si da 2 resultados entonces se
        // tomará el primero como la tabla y el segundo como la columna, en ambos casos, y se indexará dentro de sus respectivas listas para verificar las existencias
        // } else {
        // Se usará la forma normal
        // }
        //
        //
        $args = func_get_args();
        if (in_array(null, $args) || in_array('', $args) || empty($args)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (empty($this->error)) {


            $sql_condition_array = array(
                'eq' => '=',
                'neq' => '!=',
                'gt' => '>',
                'st' => '<', 'gte' => '>=',
                'ste' => '<=', 'like' => 'LIKE',
                'null' => 'IS NULL',
                'nnull' => 'IS NOT NULL'
            );
            $operand_one_array = explode(".", $operand_one);

            if ((in_array($condition, array_keys($sql_condition_array))) && (count($operand_one_array) > 1) && in_array($operand_one_array[1], array_keys($this->table_columns($this->current_table)))) {
                $operand_two_array = explode(".", $operand_two);
                if (!isset($operand_two_array[1]) && gettype($operand_two) != "integer") {
                    $operand_two = "'{$operand_two}'";
                }
                if (in_array($condition, ['null', 'nnull'])) {
                    $this->data['conditions'][] = [$operand_one, $sql_condition_array[strtolower($condition)], ''];
                } else {
                    $this->data['conditions'][] = [$operand_one, $sql_condition_array[strtolower($condition)], $operand_two];
                }
                foreach ($this->data['conditions'] as $condition) {
                    if ($this->sentenced_data['condition']) {
                        $this->sentenced_data['condition'] .= " AND {$condition[0]} {$condition[1]} {$condition[2]}";
                    } else {
                        $this->sentenced_data['condition'] .= " WHERE {$condition[0]} {$condition[1]} {$condition[2]}";
                    }
                }
            } else {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: There has been a syntax error on the columns" . "</br>";
                return $this;
            }
        }


        return $this;
    }
    //
    //
    public function order(String $column, String $order)
    {
        // Etapa 5: Establecer orden de resultados
        // ...
        // Aquí se tomará el valor de arriba para conseguir la tabla y columna, donde ya se han verificado y se usarán como idea para buscar, se usará la forma larga de tabla.columna y se le agregará ASC|DESC
        //
        //
        $args = func_get_args();
        if (in_array(null, $args) || in_array('', $args) || empty($args)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (!empty($this->sentenced_data['order'])) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: There is a order set already" . "</br>";
            return $this;
        } else {
            $order = strtoupper($order);
            $current_table_columns = $this->table_columns($this->current_table);
            $possible_order = ["ASC", "DESC"];
            $column_array = explode(".", $column);
            if (in_array(strtolower($column_array[1]), array_keys($current_table_columns)) && in_array(strtoupper($order), $possible_order)) {
                $this->sentenced_data['order'] = " ORDER BY {$column} {$order}";
            } else {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: The column or order are not valid" . "</br>";
                return $this;
            }
        }
        return $this;
    }
    //
    //
    public function limit(Int $limit)
    {
        // Etapa 6: Establecer límite de resultados
        // ...
        // Simplemente agregará el límite a data
        //
        //
        $args = func_get_args();
        if (in_array(null, $args) || in_array('', $args) || empty($args)) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
            return $this;
        } elseif (!empty($this->sentenced_data['limit'])) {
            $this->error .= strtoupper(__FUNCTION__) . " STEP: There is a limit set already" . "</br>";
            return $this;
        } else {
            if (gettype($limit) == "integer") {
                $this->sentenced_data['limit'] = " LIMIT {$limit}";
            }
        }
        return $this;
    }
    //
    //
    public function mostrar() //Funcion temporal para ver los datos, borrar al completar!!!
    {
        return get_object_vars($this);
    }
    private function queryFormat(String $method)
    {
        // Etapa 7: Formatear la consulta SQL
        // ...
        // Ademas se debe
        // Se tomarán los datos de data ya semi-formateados y validados, para ser usados en la creación de el query ya final, comprobará la acción para usar unos datos u otros, además verificará si hay algo en joined_tables
        // para hacer el formato de joined o el normal
        // ...
        //
        //

        switch (strtolower($method)) {
            case 'select':
                $imploded_columns = '';
                foreach ($this->table_sets as $table) {
                    if ($table) {
                        if ($imploded_columns) {
                            $arrays = array_keys($table);
                            $imploded_columns .= ', ';
                            $imploded_columns .= implode(', ', $arrays);
                        } else {
                            $arrays = array_keys($table);
                            $imploded_columns .= implode(', ', $arrays);
                        }
                    }
                }
                if (!$imploded_columns) {
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: There is no columns set" . "</br>";
                }
                $sqlQuery = "SELECT {$imploded_columns} FROM {$this->data['table']}{$this->sentenced_data['joined_sentence']} {$this->sentenced_data['condition']}{$this->sentenced_data['order']}{$this->sentenced_data['limit']}";
                break;

            case 'insert':
                $columns = '';
                foreach ($this->table_sets as $table) {
                    if ($columns) {
                        $arrays = array_keys($table);
                        $columns .= ', ';
                        $columns .= implode(', ', $arrays);
                    } else {
                        $arrays = array_keys($table);
                        $columns .= implode(', ', $arrays);
                    }
                }
                $values = '';
                foreach ($this->data['values'] as $value) {
                    if ($values) {
                        $values .= ', ';
                        $values .= "'" . $value . "'";
                    } else {
                        $values .= "'" . $value . "'";
                    }
                }
                if (!$columns) {
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: There is no columns set" . "</br>";
                }
                $sqlQuery = "INSERT INTO `{$this->data['table']}`({$columns}) VALUES ($values) ";

                break;
            case 'delete':
                $sqlQuery = "DELETE FROM {$this->data['table']}{$this->sentenced_data['condition']} ";
                break;
            case 'update':
                $sentenced_set = "";
                foreach ($this->data['values'] as $column => $value) {
                    $sentenced_set .= " {$column} = '{$value}',";
                }
                $sentenced_set = substr($sentenced_set, 0, -1);
                if (!$sentenced_set) {
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: There is not enough data set" . "</br>";
                }
                $sqlQuery = "UPDATE {$this->data['table']} SET{$sentenced_set}";
                break;
            default:
                break;
        }


        return $sqlQuery ?? Null;
    }
    //
    //
    public function do(String $method, String $operation = "")
    {
        if ($this->error) {
            return $this;
        } elseif (empty($operation)) {
            $query = $this->queryFormat($method);



            // Etapa 8: Verificar el método (select, insert, update, delete)
            // ...
            // Se cambia el state al método correspondiente pasado
            // Se setea el esqueleto como select, insert, update o delete, haciendo un string/objeto de ese tipo (será básicamente setear "<$method>" como el método en data
            //
            //
            $args = func_get_args();
            if (in_array(null, $args) || in_array('', $args)) {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
                return $this;
            } elseif (!in_array(strtolower($method), ['select', 'insert', 'update', 'delete'])) {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: Method is wrong" . "</br>";
                return $this;
            }

            // Etapa 9: Realizar la solicitud y obtener resultados
            // ...
            // Se usará queryFormat, y dependiendo de operation se hará una acción u otra
            // Debo usar transaction
            // ...
            //

            $connect = new mysqli(
                $this->host,
                $this->user,
                $this->passwd,
                $this->database,
                $this->port
            );

            if ($connect->connect_errno) {
                $error = $connect->connect_error;
                $this->error .= strtoupper(__FUNCTION__) . " STEP: Connection failed - {$error}" . "</br>";
                return $this;
            }

            if ($query) {

                try {
                    $connect->begin_transaction();

                    $result = $connect->query($query);

                    if (!$result) {
                        $error = $connect->error;
                        $this->error .= strtoupper(__FUNCTION__) . " STEP: Connection failed - {$error}" . "</br>";
                        return $this;
                    }

                    $response = "OK, 200"; // Éxito por defecto

                    if ($method === "select") {
                        $lists = $result->fetch_all();
                        if (empty($lists) || gettype($lists) != "array") {
                            $response = "ERROR 404: NOT FOUND";
                        } else {
                            $response = [];
                            $sub_counter = 0;
                            foreach ($lists as $list) {
                                $counter = 0;
                                foreach ($this->table_sets as $table) {
                                    foreach (array_keys($table) as  $column) {
                                        if (gettype($column) == "string") {
                                            $temporal_var = explode(".", $column);

                                            $response[$sub_counter][$temporal_var[1]] = $list[$counter];
                                            $counter++;
                                        }
                                    }
                                }
                                $sub_counter++;
                            }
                        }
                    }

                    $connect->commit();
                } catch (Exception $e) {
                    $connect->rollback();
                    $error = $e->getMessage();
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: Transaction failed - {$error}" . "</br>";
                    return $this;
                } finally {
                    $connect->close();
                }

                //Elimino los valores de los datos que permanezcan
                $error = "";
                $this->state = '';
                $this->table_sets = [];
                $this->current_table = '';

                $this->data = [
                    'table' => '',
                    'joined_tables' => array(),
                    'values' => array(),
                    'conditions' => array()
                ];
                $this->sentenced_data = [
                    'joined_sentence' => '',
                    'condition' => '',
                    'order' => '',
                    'limit' => ''
                ];

                return $response;
            }
        } elseif (strtolower($operation) == "test") {
            $query = $this->queryFormat($method);



            // Etapa 8: Verificar el método (select, insert, update, delete)
            // ...
            // Se cambia el state al método correspondiente pasado
            // Se setea el esqueleto como select, insert, update o delete, haciendo un string/objeto de ese tipo (será básicamente setear "<$method>" como el método en data
            //
            //
            $args = func_get_args();
            if (in_array(null, $args) || in_array('', $args)) {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: All arguments must not be null or empty" . "</br>";
                return $this;
            } elseif (!in_array(strtolower($method), ['select', 'insert', 'update', 'delete'])) {
                $this->error .= strtoupper(__FUNCTION__) . " STEP: Method is wrong" . "</br>";
                return $this;
            }

            // Etapa 9: Realizar la solicitud y obtener resultados
            // ...
            // Se usará queryFormat, y dependiendo de operation se hará una acción u otra
            // Debo usar transaction
            // ...
            //

            $connect = new mysqli(
                $this->host,
                $this->user,
                $this->passwd,
                $this->database,
                $this->port
            );

            if ($connect->connect_errno) {
                $error = $connect->connect_error;
                $this->error .= strtoupper(__FUNCTION__) . " STEP: Connection failed - {$error}" . "</br>";
                return $this;
            }

            if ($query) {

                try {
                    $connect->begin_transaction();

                    $result = $connect->query($query);

                    if (!$result) {
                        $error = $connect->error;
                        $this->error .= strtoupper(__FUNCTION__) . " STEP: Connection failed - {$error}" . "</br>";
                        return $this;
                    }

                    $response = "OK, 200"; // Éxito por defecto

                    if ($method === "select") {
                        $lists = $result->fetch_all();
                        if (gettype($lists) != "array") {
                            $response = "ERROR 404: NOT FOUND";
                        } else {
                            $response = [];
                            $sub_counter = 0;
                            if ($lists) {
                                foreach ($lists as $list) {
                                    $counter = 0;
                                    foreach ($this->table_sets as $table) {
                                        foreach (array_keys($table) as  $column) {
                                            if (gettype($column) == "string") {
                                                $temporal_var = explode(".", $column);

                                                $response[$sub_counter][$temporal_var[1]] = $list[$counter];
                                                $counter++;
                                            }
                                        }
                                    }
                                    $sub_counter++;
                                }
                            } else {
                                $response = [];
                            }
                        }
                    }

                    //Elimino los valores de los datos que permanezcan
                    $error = "";
                    $this->state = '';
                    $this->table_sets = [];
                    $this->current_table = '';

                    $this->data = [
                        'table' => '',
                        'joined_tables' => array(),
                        'values' => array(),
                        'conditions' => array()
                    ];
                    $this->sentenced_data = [
                        'joined_sentence' => '',
                        'condition' => '',
                        'order' => '',
                        'limit' => ''
                    ];

                    $connect->rollback();
                } catch (Exception $e) {
                    $connect->rollback();
                    $error = $e->getMessage();
                    $this->error .= strtoupper(__FUNCTION__) . " STEP: Transaction failed - {$error}" . "</br>";
                    return $this;
                } finally {
                    $connect->close();
                }

                return $response;
            }
        } else {
            return $this;
        }
    }
}

/*
// Uso de TORM:
$tORM = new TORM("localhost", "root", "", "sisviansa_techin_v1", 3306);


$menus = $tORM
    ->from("menu")
    ->do("select");

$foods = $tORM
    ->from("vianda")
    ->do("select");

$relation = $tORM
    ->from("conforma")
    ->columns("conforma.vianda_id", "conforma.menu_id")
    ->do("select");

$diets = $tORM
    ->from("dieta")
    ->do("select");

foreach ($diets as $diet) {
    foreach ($foods as $key => $food) {
        unset($foods[$key]['tiempo_de_coccion']);
        unset($foods[$key]['productos']);
        if ($food['id'] == $diet['vianda_id']) {
            $foods[$key]['dietas'][] = $diet['dieta'];
        }
    }
}
foreach ($foods as $food) {
    foreach ($menus as &$menu) { // Use & para obtener una referencia al menu, no se que es pero es lo que me recomendaron usar
        unset($menu['estado']);
        unset($menu['calorias']);

        if (in_array(['menu_id' => $menu['id'], 'vianda_id' => $food['id']], $relation)) {
            if (!isset($menu['viandas'])) {
                $menu['viandas'] = [];
            }
            $menu['viandas'][$food['nombre']] = $food;
        }
    }
}

$favorites = $tORM
    ->from("favorito")
    ->columns("favorito.menu_id")
    ->join("inicia", "inicia.cliente_id", "favorito.web_id")
    ->joined_columns("None column")
    ->where("inicia.token", "eq", 'token1')
    ->do("select");
//
//
//->mostrar(); // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;

echo '<pre>';
print_r([$menus, gettype($favorites) == "string" ? $favorites : array_column($favorites, 'menu_id')]);
echo '</pre>';
*/