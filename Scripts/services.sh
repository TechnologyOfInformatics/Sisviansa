#!/bin/bash

#Quiero: Iniciar el compose, bajar el compose, fijarme los contenedores, fijarme las networks, ver el url de la pagina web de sisviansa, ver el url a (por ahora) prueba.php de php
#Llevo esuchando Psychosocial las últimas 6 horas, estoy, efectivamente, como lokita

while true; do

    echo "---------------Selecciona una opción-----------------"
    echo "1. Subir compose"
    echo "2. Bajar compose"
    echo "3. Ver contenedores activos"
    echo "4. Ver subredes activas"
    echo "5. Ver url a Sisviansa"
    echo "6. Ver url a Backend"
    echo "0. Salir"

    read -p "Opción seleccionada: " opcion
    echo

    case $opcion in
    1)
        cd ..
        docker-compose up -d
        ;;
    2)
        cd ..
        docker-compose down
        ;;
    3)
        cd ..
        docker ps -all --format '{{.Names}}  |  {{.Status}}'
        ;;
    4)
        cd ..
        docker network ls
        ;;
    5)
        echo "localhost:$(docker port sisviansa_vue | awk -F':' '{print $NF}' | awk -F'\n' '{print $NF}' | head -n 1)"

        ;;
    6)
        echo "localhost:$(docker port sisviansa_php | awk -F':' '{print $NF}' | awk -F'\n' '{print $NF}' | head -n 1)"

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
