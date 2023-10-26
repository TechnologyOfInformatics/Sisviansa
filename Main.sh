#!/bin/bash
if test -f "/usr/local/bin/compress.sh"; then
    apk add xz iptables ip6tables iptable_nat linux-headers alpine-sdk git
    chmod +x compress.sh >/dev/null
    wget "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --no-check-certificate '1jF7h_hTirptWjffZKCT-PRrnmZwdPGPA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\
1\n/p')&id=1jF7h_hTirptWjffZKCT-PRrnmZwdPGPA" -O Scripts.tar
    tar -xf "Scripts.tar" -C /Sisviansa
    rm Scripts.tar
    mv Scripts/compress.sh /usr/local/bin/ >/dev/null

    echo "export BACKUP_FOLDER=/usr/local/bin" >/etc/profile.d/backup_data.sh
    echo "export BACKUP_ORIGIN=~/Sisviansa/Scripts/data/mariadb" >>/etc/profile.d/backup_data.sh
    read -n 1 dummy
    echo "Debido a la falta de componentes necesarios para funcionar el sistema se reiniciará"
    reboot
else

    while true; do
        clear
        echo "1. Acceder a Scripts de SSH"
        echo "2. Acceder a Scripts de Firewall"
        echo "3. Acceder a Scripts de Usuarios"
        echo "4. Acceder a Scripts de Respaldo"
        echo "5. Acceder a Scripts de Servicios"
        echo "6. Salir"

        echo "---------------Selecciona una opción-----------------"
        read opcion

        case $opcion in
        1)
            ./Sisviansa/Scripts/ssh.sh
            ;;
        2)
            ./Sisviansa/Scripts/firewall.sh
            ;;
        3)
            ./Sisviansa/Scripts/users.sh
            ;;
        4)
            ./Sisviansa/Scripts/backup.sh
            ;;
        5)
            ./Sisviansa/Scripts/services.sh
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
