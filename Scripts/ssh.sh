#!/bin/bash
#Seccion de funciones
ese_ese_hache_pa_los_pibes() {
    local ip_cliente=$1
    local alias_ssh=$2
    local usuario_ssh=$3
    echo "\n"

    config_file="$HOME/.ssh/config"

    if [ $(grep -E -q "(^|\s)Host\s$alias_ssh" $config_file) ]; then
        echo "el alias que intentas crear ya existe"
        exit 1
    else
        if [ ! -f ~/.ssh/id_rsa ]; then
            ssh-keygen -t rsa -b 2048
            echo "clave? ssh creada para mi mismo" #Porque una clave no se usa nunca, no entiendo
        fi

        ssh-copy-id -i ~/.ssh/id_rsa.pub "$usuario_ssh@$ip_cliente" >/dev/null 2>&1 #Según gpt el redireccionamiento del final lo manda al vacio, no me acordaba de eso jaja

    fi

    if [ $? -eq 0 ]; then #No llegue a entender que es $? la verda
        echo "Clave ssh agregada al cliente"
    else
        echo "error al agregar clave ssh al cliente."
        exit 1
    fi

    echo -e "Host $alias_ssh\n\tHostName $ip_cliente\n\tUser $usuario_ssh" >>~/.ssh/config #Agrego el alias a los hosts para despues conectarme con solo hacer ssh <Alias>
    echo "alias creado para $ip_cliente"
}

ese_ese_hache_pero_no() {
    if [ -z "$1" ]; then
        echo "Se necesita un alias para eliminarlo"
        exit 1
    fi

    alias_ssh="$1"
    config_file="$HOME/.ssh/config"

    if grep -E -q "(^|\s)Host\s$alias_ssh" "$config_file"; then #Pero porque funciona??????????

        sed -i "/Host $alias_ssh/,/^\s*$/d" ~/.ssh/config #Una forma cómoda (no el mueble) de eliminar los datos sobre el alias

        rm -f ~/.ssh/id_rsa_${alias_ssh}*
        rm -f ~/.ssh/id_rsa_${alias_ssh}*.pub
    else
        echo "'$alias_ssh' no existe"
        exit 1
    fi
    echo "Se eliminó a '$alias_ssh'"
}
#ese_ese_hache_pero_no "maxi"
#ese_ese_hache_pa_los_pibes "192.168.1.48" "maxi" "root"

#Seccion de eleccion
while true; do

    echo "---------------Selecciona una opción-----------------"
    echo "1. Crear SSH y alias"
    echo "2. Eliminar SSH a alias"
    echo "0. Salir"

    read -p "Opción seleccionada: " opcion
    echo

    case $opcion in
    1)
        read -p "Ingresa el nombre del usuario: " nombre_de_usuario
        read -p "Ingresa el Alias del usuario (lo que usaras para conectarte con ssh): " alias_usuario
        read -sp "Ingresa la IP del usuario: " ip_usuario
        echo
        #ese_ese_hache_pa_los_pibes $ip_usuario $alias_usuario $nombre_de_usuario
        ;;
    2)
        read -p "Ingresa el alias del usuario: " alias_usuario
        ese_ese_hache_pero_no $alias_usuario
        ;;
    0)
        echo "Saliendo del menu"
        exit 0
        ;;
    *)
        echo "Opcion inválida"
        ;;
    esac

    echo
    read -n 1 dummy
done
