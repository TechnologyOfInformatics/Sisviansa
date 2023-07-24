sed -i -r '/community/s/^#//g' /etc/apk/repositories;
apk update;
apk upgrade;
apk add lighttpd;

mkdir -p /var/www/localhost/htdocs/stats /var/log/lighttpd /var/lib/lighttpd;
sed -i -r 's#\#.*server.port.*=.*#server.port          = 80#g' /etc/lighttpd/lighttpd.conf;
sed -i -r 's#\#.*server.event-handler = "linux-sysepoll".*#server.event-handler = "linux-sysepoll"#g' /etc/lighttpd/lighttpd.conf;
chown -R lighttpd:lighttpd /var/www/localhost/;
chown -R lighttpd:lighttpd /var/lib/lighttpd;
chown -R lighttpd:lighttpd /var/log/lighttpd;
rc-update add lighttpd default;
rc-service lighttpd restart;

sed -i -r 's#\#.*mod_status.*,.*#    "mod_status",#g' /etc/lighttpd/lighttpd.conf;
sed -i -r 's#.*status.status-url.*=.*#status.status-url  = "/stats/server-status"#g' /etc/lighttpd/lighttpd.conf;
sed -i -r 's#.*status.config-url.*=.*#status.config-url  = "/stats/server-config"#g' /etc/lighttpd/lighttpd.conf;
rc-service lighttpd restart;

apk add php php-bcmath php-bz2 php-ctype php-curl php-dom php-exif php81-fpm php-gd php-gettext php-iconv php-json php-mbstring php-opcache php-openssl php-phar php-posix php-pspell php-session php-simplexml php-sockets php-sysvmsg php-sysvsem php-sysvshm php-xml php-xmlreader php-xmlwriter php-zip php-sqlite3 php-pgsql php-mysqli php-mysqlnd php-pdo php-tokenizer;
sed -i -r 's|.*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=1|g' /etc/php*/php.ini;
sed -i -r 's#.*safe_mode =.*#safe_mode = Off#g' /etc/php*/php.ini;
sed -i -r 's#.*expose_php =.*#expose_php = Off#g' /etc/php*/php.ini;
sed -i -r 's#memory_limit =.*#memory_limit = 536M#g' /etc/php*/php.ini;
sed -i -r 's#upload_max_filesize =.*#upload_max_filesize = 128M#g' /etc/php*/php.ini;
sed -i -r 's#post_max_size =.*#post_max_size = 256M#g' /etc/php*/php.ini;
sed -i -r 's#^file_uploads =.*#file_uploads = On#g' /etc/php*/php.ini;
sed -i -r 's#^max_file_uploads =.*#max_file_uploads = 12#g' /etc/php*/php.ini;
sed -i -r 's#^allow_url_fopen = .*#allow_url_fopen = On#g' /etc/php*/php.ini;
sed -i -r 's#^.default_charset =.*#default_charset = "UTF-8"#g' /etc/php*/php.ini;
sed -i -r 's#^.max_execution_time =.*#max_execution_time = 150#g' /etc/php*/php.ini;
sed -i -r 's#^max_input_time =.*#max_input_time = 90#g' /etc/php*/php.ini;

mkdir -p /var/run/php-fpm81/;

chown lighttpd:root /var/run/php-fpm81;

sed -i -r 's|^.*listen =.*|listen = /run/php-fpm81/php81-fpm.sock|g' /etc/php*/php-fpm.d/www.conf;

sed -i -r 's|^pid =.*|pid = /run/php-fpm81/php81-fpm.pid|g' /etc/php*/php-fpm.conf;

sed -i -r 's|^.*listen.mode =.*|listen.mode = 0640|g' /etc/php*/php-fpm.d/www.conf;

rc-update add php-fpm81 default;

service php-fpm81 restart;


mkdir -p /var/www/localhost/cgi-bin;

sed -i -r 's#\#.*mod_alias.*,.*#    "mod_alias",#g' /etc/lighttpd/lighttpd.conf;

sed -i -r 's#.*include "mod_cgi.conf".*#   include "mod_cgi.conf"#g' /etc/lighttpd/lighttpd.conf;

sed -i -r 's#.*include "mod_fastcgi.conf".*#\#   include "mod_fastcgi.conf"#g' /etc/lighttpd/lighttpd.conf;

sed -i -r 's#.*include "mod_fastcgi_fpm.conf".*#   include "mod_fastcgi_fpm.conf"#g' /etc/lighttpd/lighttpd.conf;

sed -e '/index-file.names/ s/^#*/#/' -i /etc/lighttpd/lighttpd.conf;

cat > /etc/lighttpd/mod_fastcgi_fpm.conf << EOF
server.modules += ( "mod_fastcgi" )
index-file.names += ( "index.php" )
fastcgi.server = (
    ".php" => (
      "localhost" => (
        "socket"                => "/var/run/php-fpm81/php81-fpm.sock",
        "broken-scriptfilename" => "enable"
      ))
)
EOF

sed -i -r 's|^.*listen =.*|listen = /var/run/php-fpm81/php81-fpm.sock|g' /etc/php*/php-fpm.d/www.conf;

sed -i -r 's|^.*listen.owner = .*|listen.owner = lighttpd|g' /etc/php*/php-fpm.d/www.conf;

sed -i -r 's|^.*listen.group = .*|listen.group = lighttpd|g' /etc/php*/php-fpm.d/www.conf;

sed -i -r 's|^.*listen.mode = .*|listen.mode = 0660|g' /etc/php*/php-fpm.d/www.conf;

rc-service php-fpm81 restart;

rc-service lighttpd restart;


apk add --update docker openrc;
service docker start;

while ! docker info > /dev/null 2>&1; do
  sleep 1
done;

docker run -d --name mariadb-container -e MYSQL_ROOT_PASSWORD=<Contraseña> -e MYSQL_DATABASE=bdd -e MYSQL_USER=<Nombre> -e MYSQL_PASSWORD=<Contraseña> -p 3306:3306 mariadb:latest;
sleep 20;
docker start mariadb-container;
docker exec -it mariadb-container apt-get update;
docker exec -it mariadb-container apt-get install -y mariadb-client;

echo "<?php
\$servername = '<IP de la maquina>'; 
\$username = '<Nombre>';
\$password = '<Contraseña>';
\$database = 'bdd';

// Crear conexión
\$conn = new mysqli(\$servername, \$username, \$password, \$database);

// Verificar la conexión
if (\$conn->connect_error) {
    die(\"Conexión fallida: \" . \$conn->connect_error);
}

echo \"Conexión exitosa a la base de datos\";
?>" > /var/www/localhost/htdocs/index.php
