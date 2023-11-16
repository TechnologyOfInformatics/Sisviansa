#!/bin/bash 
if [ test -f "/usr/local/bin/compress.sh" ]; then
 
    while true; do
        clear
        echo "1. Acceder a Scripts de SSH"
        echo "2. Acceder a Scripts de Firewall"
        echo "3. Acceder a Scripts de Usuarios"
        echo "4. Acceder a Scripts de Respaldo"
        echo "5. Acceder a Scripts de Servicios"
        echo "6. Ver logs del servidor DHCP"
        echo "0. Salir"
        echo "Si se quiere determinar un equipo como servidor dhcp debe"
        echo " ejecutar el script dentro de Sisviansa/Scripts llamado dhcp.sh."
        echo "Si se quiere determinar un equipo como cliente dhcp debe ejecutar"
        echo " el script dentro de Sisviansa/Scripts llamado client_setter.sh."

        echo "---------------Selecciona una opcion-----------------"
        read opcion

        case "$opcion" in
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
            grep dhcp /var/log/messages | tail -50
            ;;

        0)
            echo "Saliendo del menu."
            exit 0
            ;;
        *)
            echo "Opcion no valida. Por favor, ingrese un numero de opcion valido."
            ;;
        esac
        read -n 1 dummy
    done

else

   
cat <<EOF > /etc/apk/repositories
    #/media/cdrom/apks
    http://alpinelinux.c3sl.ufpr.br/v3.18/main
    http://alpinelinux.c3sl.ufpr.br/v3.18/community
EOF
    apk add xz iptables ip6tables linux-headers alpine-sdk git 

    chmod +x Sisviansa/Scripts/compress.sh >/dev/null
    mv Sisviansa/Scripts/compress.sh /usr/local/bin/ >/dev/null

    echo "export BACKUP_FOLDER=/usr/local/bin" >/etc/profile.d/backup_data.sh
    echo "export BACKUP_ORIGIN=~/Sisviansa/Scripts/data/mariadb" >>/etc/profile.d/backup_data.sh
    read -n 1 dummy
    echo "Debido a la falta de componentes necesarios para funcionar el sistema se reiniciara"

    # Debido al hecho que este script es del admin y que el admin debe tener el servidor dhcp a mano, debo obligar la instalacion del mismo

    reboot

fi
