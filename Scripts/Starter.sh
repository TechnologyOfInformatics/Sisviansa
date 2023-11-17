#!/bin/bash
cat <<EOF > /etc/apk/repositories
#/media/cdrom/apks
http://alpinelinux.c3sl.ufpr.br/v3.18/main
http://alpinelinux.c3sl.ufpr.br/v3.18/community
EOF

cat <<EOF > /etc/motd
/////////////////////////////////SERVIDOR ADMINISTRADOR//////////////////////////////////////
BIENVENIDO AL SERVIDOR ADMINISTRADOR DE SISVIANSA
ANTE CUALQUIER PROBLEMA POR FAVOR CONTACTE A APOYO TECNICO DE TECHIN

GRACIAS POR USAR NUESTRO SOFTWARE!
EOF

apk add git dos2unix
git clone -b master https://github.com/TechnologyOfInformatics/Sisviansa.git
mv Sisviansa/Main.sh Main.sh >/dev/null
find ./Sisviansa/Scripts -type f -print0 | xargs -0 dos2unix --
dos2unix Main.sh
#find ./Sisviansa/Data -type f -not -path '*/\.*' -exec sed -i 's/sisviansa_mariadb/'"$(ip a show eth0 | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | cut -d ' ' -f 2)"'/g' {} + ;
find ./Sisviansa/Data -type f -not -path '*/\.*' -exec sed -i 's/localhost/'"$(ip a show eth0 | grep -oE 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}' | cut -d ' ' -f 2)"'/g' {} + ;
find ./Sisviansa/Scripts -type f -exec chmod +x {} \;

