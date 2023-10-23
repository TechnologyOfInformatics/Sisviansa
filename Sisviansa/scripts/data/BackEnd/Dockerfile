FROM php:8.1-fpm-alpine

RUN set -ex \
    && apk --no-cache add mariadb-dev nodejs npm zip unzip php-zip\
    && docker-php-ext-install pdo pdo_mysql mysqli

WORKDIR /var/www/html