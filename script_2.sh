#!/bin/bash
if test -f "/usr/local/bin/compress.sh"; then
    chmod +x compress.sh >/dev/null
    wget "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --no-check-certificate '1jF7h_hTirptWjffZKCT-PRrnmZwdPGPA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\
1\n/p')&id=1jF7h_hTirptWjffZKCT-PRrnmZwdPGPA" -O scripts.tar
    tar -xf "scripts.tar"
    rm scripts.tar
    mv scripts/compress.sh /usr/local/bin/ >/dev/null
    echo "export BACKUP_FOLDER=/usr/local/bin" >/etc/profile.d/backup_data.sh
    echo "export BACKUP_ORIGIN=~/Sisviansa/scripts/data/mariadb" >>/etc/profile.d/backup_data.sh
    read -n 1 dummy
    echo "Debido a la falta de componentes necesarios para funcionar el sistema se reiniciará"
    reboot
else

    while true; do
        clear
        echo "1. Acceder a scripts de SSH"
        echo "2. Acceder a scripts de Firewall"
        echo "3. Acceder a scripts de Usuarios"
        echo "4. Acceder a scripts de Respaldo"
        echo "5. Acceder a scripts de Servicios"
        echo "6. Salir"

        echo "---------------Selecciona una opción-----------------"
        read opcion

        case $opcion in
        1)
            ./scripts/ssh.sh
            ;;
        2)
            ./scripts/firewall.sh
            ;;
        3)
            ./scripts/users.sh
            ;;
        4)
            ./scripts/backup.sh
            ;;
        5)
            ./scripts/services.sh
            ;;
        6)
            echo "Saliendo del menú."
            exit 0
            ;;
        *)
            echo "Opción no válida. Por favor, ingrese un número de opción válido."
            ;;
        esac
        read -n 1 dummy
    done

fi
