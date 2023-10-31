# Verificar si el usuario es root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como administrador!!!!!!!!!!!!!!!!!!"
    exit 1
fi
# Configuro para aceptar paquetes de la comunidad, actualizo e instalo lo necesario
cat >/etc/apk/repositories <<EOL
#/media/cdrom/apks
http://alpinelinux.c3sl.ufpr.br/v3.18/main
http://alpinelinux.c3sl.ufpr.br/v3.18/community

EOL
apk update
apk upgrade
apk add dhclient nano iptables ip6tables
dhclient -v eth0

read -p "¿Desea reiniciar el sistema ahora? (y/n) " choice
cat >/etc/network/interfaces <<EOL
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

EOL

cat >./config_start.sh <<EOL
#!/bin/bash
setup-xorg-base
apk add xfce4 xfce4-terminal xfce4-screensaver lightdm-gtk-greeter firefox

# Iniciar el servicio dbus (Es para iniciar xfce al arranque)
rc-service dbus start
rc-update add dbus

# lightdm (light display manager, es el encargado de mostrar los graficos en pantalla referentes a xfce)
rc-update add lightdm
rc-service lightdm start

echo "XFCE se ha instalado correctamente"

read -p "Nombre de usuario para crear: " username
read -s -p "Contraseña para el nuevo usuario: " password
echo

# Crear un nuevo usuario no root, para el puesto de trabajo
adduser "$username" -D
echo "$username:$password" | chpasswd
# No voy a mentir, le pedi a chatgpt que me hiciera el crear usuario y no se para que es chpasswd (change password, se usa para alterar la contraseña de los usuarios, o en éste caso darle una)


# Determina las reglas para el firewall, para bloquear el acceso a internet
iptables -A FORWARD -i eth0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j DROP
iptables -A FORWARD -i eth0 -o eth0 -p tcp --dport 22 -j ACCEPT

# Guarda las reglas de iptables
iptables-save > /etc/iptables/rules.v4

# El script se suicida despues de ser utilizado de forma inhumana :'c
rm -f "$0"

reboot

EOL
echo "Una vez se reinicie el sistema debe correr el script config_start.sh"
if [ "$choice" = "y" ]; then
    reboot
else
    echo "Se debera reiniciar mas tarde."
fi
