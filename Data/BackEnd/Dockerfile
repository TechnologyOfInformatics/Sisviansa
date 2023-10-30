FROM php:8.1-apache

RUN mkdir /app

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

RUN docker-php-ext-install mysqli
WORKDIR /app

RUN chown -R www-data:www-data /app && a2enmod rewrite

#Se debe cambiar a "var/www/html"
# FROM php:7.1.23-apache
# WORKDIR /
# RUN echo "ServerName localhost:80" >> /etc/apache2/apache2.conf
# RUN docker-php-ext-install pdo_mysql
# CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]