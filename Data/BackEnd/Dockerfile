FROM php:8.1-apache


RUN mkdir /app

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

RUN docker-php-ext-install mysqli
WORKDIR /app

RUN chown -R www-data:www-data /app && a2enmod rewrite
