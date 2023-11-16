#!/bin/bash
cat <<EOF > /etc/apk/repositories
#/media/cdrom/apks
http://alpinelinux.c3sl.ufpr.br/v3.18/main
http://alpinelinux.c3sl.ufpr.br/v3.18/community
EOF
apk add git dos2unix
git clone -b master https://github.com/TechnologyOfInformatics/Sisviansa.git
mv Sisviansa/Main.sh Main.sh
find ./Sisviansa/Scripts -type f -print0 | xargs -0 dos2unix --
dos2unix Main.sh
