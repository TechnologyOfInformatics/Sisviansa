#Permito el routing
echo "net.ipv4.ip_forward=1" | tee -a
/etc/sysctl.conf
sh /etc/sysctl.conf
sysctl -p
#Actualizo y descargo los archivos necesarios para iniciar el nat+dhcp server
apk update
apk upgrade
apk add iptables ip6tables
#Establezco la NAT
## "lo" es LOOPBACK el cual es una forma de decirle al localhost, la red interna, en este caso se le dice que haga forward a los paquetes
iptables -A FORWARD -i lo -j ACCEPT
## eth0 es la red local externa, ahora mismo le pido que enmascare los paquetes para el forwarding
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
## Guardo las modificaciones
sh /etc/init.d/iptables save

# Instalo dhcp
apk add dhcp

## Creo la modificacion para que los clientes tengan ips falsas
## NOTA: Si se quiere cambiar el rango se debe alterar range
cat >/etc/dhcp/dhcpd.conf <<EOL
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.150;
  option domain-name-servers 9.9.9.9;
  option routers 192.168.1.1;
}
EOL
echo "Las redes disponibles seran desde 192.168.1.100 hasta 192.168.1.150"
## Aplico cambios
rc-update add dhcp
rc-update add dhcpd
rc-service dhcpd start
