#!/bin/bash

#    ● tar -cf archivo.tar menu.sh abm.sh
#Empaqueta dentro del archivo.tar los archivos menu.sh y abm.sh
#    ● tar -tvf archivo.tar
#Lista todos los archivos que estan dentro de archivo.tar
#    ● tar -xf archivo.tar
#Extrae los archivos desde archivo.tar

# Puedo alterar etc/profile para crear mis variables globales propias

#1 creo/seteo la variable global "BACKUP_ORIGIN" con el valor ingresado (checkeo si existe?)
#2 Lo mismo que arriba pero "BACKUP_FOLDER" con el valor ingresado, aunque prefiriría que fuera usr/local/bin, meh
#3 Corro el script compress.sh dentro de usr/local/bin
#4 Uso tar -tvf en el archivo para listar su contenido
#5 Simplemente abro el crontab (tambien anacron?)
#6 niania
#7 lo pense y creo que los pasos seran: traigo el .tar, borro la carpeta, extraigo el .tar y lo borro
#Nota: Sería lindo tener algo que diga hace cuanto fue el ultimo respaldo, hmmmm

determinar_carpeta_origen() {
    local carpeta="$1"
    echo "export BACKUP_FOLDER=$BACKUP_FOLDER" >/etc/profile.d/backup_data.sh
    echo "export BACKUP_ORIGIN=$1" >>/etc/profile.d/backup_data.sh
    echo "Se ha modificado el origen"
    echo "Se reiniciara el sistema para aplicar los cambios"
    reboot
}

determinar_carpeta_objetivo() {
    local carpeta="$1"
    echo "export BACKUP_ORIGIN=$BACKUP_ORIGIN" >/etc/profile.d/backup_data.sh
    echo "export BACKUP_FOLDER=$1" >>/etc/profile.d/backup_data.sh
    echo "Se ha modificado el destino"
    echo "Se reiniciara el sistema para aplicar los cambios"
    reboot

}

recuperar() {
    mv "${BACKUP_FOLDER}/mariadb_backup.tar" '${BACKUP_ORIGIN}/..'
    rm -r "${BACKUP_FOLDER}"
    tar -xf "${BACKUP_FOLDER}/mariadb_backup.tar"
    rm "${BACKUP_FOLDER}/mariadb_backup.tar"

}

while true; do
    clear
    echo "CARPETA ORIGEN ACTUAL:$BACKUP_ORIGIN"
    echo "CARPETA DESTINO ACTUAL:$BACKUP_FOLDER"
    echo
    echo "---------------Selecciona una opcion-----------------"
    echo "1. Determinar carpeta de origen"
    echo "2. Determinar carpeta objetivo"
    echo "3. Forzar respaldo"
    echo "4. Ver respaldo"
    echo "5. Abrir crontab"
    echo "6. Determinar frecuencia de respaldo"
    echo "7. Recuperar"
    echo "0. Salir"
    read -p "Seleccione una opcion: " opcion

    case $opcion in
    1)
        read -p "¿Que carpeta quiere usar como el origen (ej: /c/a/r/p/e/t/a)?" carpeta
        determinar_carpeta_origen "$carpeta"
        ;;
    2)
        read -p "¿En que carpeta quiere usar como destino (ej: /c/a/r/p/e/t/a)?" carpeta
        determinar_carpeta_objetivo "$carpeta"
        ;;
    3)
        sh ./usr/local/bin/compress.sh
        ;;
    4)
        tar -tvf "${BACKUP_FOLDER}/mariadb_backup.tar"
        ;;
    5)
        crontab -e
        ;;
    6)
        echo "¿Con que frecuencia quiere que se respalden sus datos?" #No pude instalar Anacron, vere algun sustituto

        echo "---------------Selecciona una opcion-----------------"
        echo "1. Anualmente"
        echo "2. Mensualmente"
        echo "3. Cada semana"
        echo "4. Diariamente"
        echo "5. Cada hora"

        read eleccion
        sed -i '/compress.sh/d' /var/spool/cron/crontabs/root

        case $eleccion in
        1)
            echo "@yearly /usr/local/bin/compress.sh" >/var/spool/cron/crontabs/root
            ;;
        2)
            echo "@monthly /usr/local/bin/compress.sh" >/var/spool/cron/crontabs/root
            ;;
        3)
            echo "@weekly /usr/local/bin/compress.sh" >/var/spool/cron/crontabs/root
            ;;
        4)
            echo "@daily /usr/local/bin/compress.sh" >/var/spool/cron/crontabs/root
            ;;
        5)
            echo "@hourly /usr/local/bin/compress.sh" >/var/spool/cron/crontabs/root
            ;;
        *)
            echo "Valor invalido"
            ;;
        esac
        ;;
    7)
        recuperar
        ;;
    0)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "Opcion no valida."
        ;;
    esac

    read -n 1 dummy
done
