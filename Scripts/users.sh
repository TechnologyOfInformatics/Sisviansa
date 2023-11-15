#!/bin/bash
#Seccion de funciones:
crear_usuario() {

    local nombre_de_usuario="$1"
    local contrasenia="$2"

    useradd -m -p $contrasenia $nombre_de_usuario

}

ver_grupos_usuario() {
    local nombre_de_usuario=$1
    echo “Lista de grupos:”
    groups $nombre_de_usuario | tr ' ' '\n'
}

modificar_grupo_usuario() {
    local nombre_de_usuario=$1
    local nombre_de_grupo=$2
    echo “Se agregara el usuario $nombre_de_usuario al grupo $nombre_de_grupo”
    #rarisimo suena escrito así, sera que es porque ando dormido
    addgroup $nombre_de_usuario $nombre_de_grupo
}

eliminar_usuario() {
    local nombre_de_usuario=$1
    deluser -r $nombre_de_usuario
}

crear_grupo() {
    local nombre_de_grupo=$1
    addgroup $nombre_de_grupo
}

ver_grupos() {
    cut -d: -f1 /etc/group
}

dar_permiso_de_grupo_a_carpeta() {
    BASE_FOLDER="../var/www/localhost/htdocs/"
    local nombre_de_grupo=$1
    local carpeta=$BASE_FOLDER$2
    local permisos=$3

    chown :$nombre_de_grupo $carpeta

    chmod g+rwx $carpeta

    chmod o-rwx $carpeta

}

quitar_permiso_de_grupo_a_carpeta() {
    #Re largo el nombre jajaja
    BASE_FOLDER="../var/www/localhost/htdocs/"
    local carpeta=$BASE_FOLDER$2
    local permisos=$3

    chown :root $carpeta

    chmod g+rwx $carpeta

    chmod o-rwx $carpeta

}

eliminar_grupo() {
    local nombre_de_grupo=$1
    delgroup $nombre_de_grupo
    echo "Grupo $nombre_de_grupo eliminado correctamente."
}

#Seccion de menu
while true; do
    clear
    echo "---------------Selecciona una opcion-----------------"
    echo "1. Crear usuario"
    echo "2. Ver grupos de un usuario"
    echo "3. Modificar grupo de un usuario"
    echo "4. Eliminar usuario"
    echo "5. Crear grupo"
    echo "6. Ver lista de grupos"
    echo "7. Dar permisos de grupo a una carpeta"
    echo "8. Quitar permisos de grupo a una carpeta"
    echo "9. Eliminar grupo"
    echo "0. Salir"

    read -p "Opcion seleccionada: " opcion
    echo

    case $opcion in
    1)
        read -p "Ingresa el nombre del usuario: " nombre_de_usuario
        read -sp "Ingresa la contrasenia: " contrasenia
        #use la s para que no mostrara la contrasenia, creía que era la h de hidden y no se porque :/
        echo
        crear_usuario "$nombre_de_usuario" "$contrasenia"
        ;;
    2)
        read -p "Ingresa el nombre del usuario: " nombre_de_usuario
        ver_grupos_usuario "$nombre_de_usuario"
        ;;
    3)
        read -p "Ingresa el nombre del usuario:" nombre_de_usuario
        read -p "Ingresa el nombre del grupo:" nombre_de_grupo
        modificar_grupo_usuario "$nombre_de_usuario" "$nombre_de_grupo"
        ;;
    4)
        read -p "Ingresa el nombre del usuario:" nombre_de_usuario
        eliminar_usuario "$nombre_de_usuario"
        ;;
    5)
        read -p "Ingresa el nombre del grupo: " nombre_de_grupo
        crear_grupo "$nombre_de_grupo"
        ;;
    6)
        ver_grupos
        ;;
    7)
        read -p "Ingresa el nombre del grupo:" nombre_de_grupo
        read -p "Ingresa el nombre de la carpeta:" carpeta
        dar_permiso_de_grupo_a_carpeta "$nombre_de_grupo" "$carpeta"
        ;;
    8)
        read -p "Ingresa el nombre del grupo:" nombre_de_grupo
        read -p "Ingresa el nombre de la carpeta:" carpeta
        quitar_permiso_de_grupo_a_carpeta "$nombre_de_grupo" "$carpeta"
        ;;
    9)
        read -p "Ingresa el nombre del grupo:" nombre_de_grupo
        eliminar_grupo "$nombre_de_grupo"
        ;;
    0)
        echo "Saliendo del menu"
        exit 0
        ;;
    *)
        echo "Opcion invalida"
        ;;
    esac

    echo
    read -n 1 dummy
done
