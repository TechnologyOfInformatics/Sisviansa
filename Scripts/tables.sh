#!/bin/bash

#Quiero: Poder agregar o quitar un IP de la tabla de iptables, hacer lo mismo para servicios conocidos como ping y asi, no se
#Seccion de funciones
ipe_teibols() {
    local tabla="$1"
    local cadena="$2"
    local ip="$3"
    local regla="$4"

    iptables -t "$tabla" -I "$cadena" -s "$ip" -j "$regla"
    echo "Regla de IP agregada con exito"
}

no_ipe_teibols() {
    local cadena="$1"
    local id="$2"

    iptables -D "$cadena" "$id"
    echo "Regla eliminada con exito"
}

reglas_de_servicio_iptbls() {
    local tabla="$1"
    local cadena="$2"
    local servicio="$3"
    local regla="$4"

    iptables -t "$tabla" -I "$cadena" --protocol "$servicio" -j "$regla"
}

flush_a_las_teibols() {
    local tabla="$1"
    iptables -t "$tabla" -F
}

restaurar_ipe_teibols() {
    local archivo="$1"

    if [ -e "$archivo" ]; then
        iptables-restore <"$archivo"
        echo "Reglas iptables restauradas el archivo"
    else
        echo "El archivo $archivo no existe"
    fi
}

#seccion de opciones
while true; do
    clear
    echo "---------------Selecciona una opcion-----------------"
    echo "1. Agregar una regla"
    echo "2. Eliminar una regla"
    echo "3. Crear regla de servicio"
    echo "4. Eliminar todas las reglas de una cadena"
    echo "5. Restaurar reglas desde un archivo"
    echo "6. Guardar tablas"
    echo "7. Ver"
    echo "0. Salir"
    read opcion

    case $opcion in
    1)
        read -p "Tabla: " tabla
        read -p "Cadena: " cadena
        read -p "Direccion IP: " ip
        read -p "Regla: " regla
        ipe_teibols "$tabla" "$cadena" "$ip" "$regla"
        ;;

    2)
        read -p "Cadena: " cadena
        read -p "ID (para mas referencia usar 'ver'): " id
        no_ipe_teibols "$cadena" "$id"
        ;;

    3)
        read -p "Tabla: " tabla
        read -p "Cadena: " cadena
        read -p "Servicio: " servicio
        read -p "Regla: " regla
        reglas_de_servicio_iptbls "$tabla" "$cadena" "$servicio" "$regla"
        ;;

    4)
        read -p "Tabla: " tabla
        flush_a_las_teibols "$tabla"
        ;;

    5)
        read -p "Archivo (El archivo debe estar en este mismo directorio): " archivo
        restaurar_ipe_teibols "$archivo"
        ;;

    6)
        iptables-save >"/etc/sysconfig/iptables"
        echo "Tablas guardadas"
        ;;

    7)
        iptables -L --line-numbers
        ;;

    0)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opcion no valida."
        ;;
    esac

echo "Presione cualquier tecla para continuar"
    read -n 1 dummy
done
