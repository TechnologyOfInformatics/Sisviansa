#!/bin/bash

while true; do
clear
    echo "---------------Selecciona una opcion-----------------"
    echo "1. Mostrar registros de eventos"
    echo "2. Mostrar conexiones de usuarios"
    echo "4. Mostrar fallidas conexiones de usuarios"
    echo "0. Salir"

    read -p "Opcion seleccionada: " opcion

    case "$opcion" in
        1)
            echo "Registros de eventos: "
            last -n 5
            ;;
        2)
            echo "Conexiones de usuarios: "
            who -a
            ;;
        3)
            echo "Conexiones fallidas de usuarios: "
            lastb
            ;;
        3)
            echo "Cantidad de usuarios conectados: "
            who -q
            ;;
    0)
        echo "Saliendo del menu"
        exit 0
        ;;
    *)
        echo "Opcion invalida"
        ;;
    esac
done
