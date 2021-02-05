FROM php:8.0-apache

RUN pecl install xdebug

COPY etc/virtualhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY etc/php.ini $PHP_INI_DIR/conf.d/
