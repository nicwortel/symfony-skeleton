FROM php:8.0-apache AS base
RUN apt-get update && apt-get install -y libicu-dev
RUN docker-php-ext-install intl
WORKDIR /var/www/app/

FROM base AS composer-install
RUN apt-get update && apt-get install -y git unzip libzip-dev
RUN docker-php-ext-install zip
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock symfony.lock .env ./
RUN composer install --no-dev --no-scripts
RUN composer dump-env prod

FROM base
RUN pecl install xdebug
RUN mkdir -p var/cache var/log
RUN chown --recursive www-data:www-data var/
VOLUME /var/www/app/var
COPY etc/virtualhost.conf /etc/apache2/sites-enabled/000-default.conf
COPY etc/php.ini $PHP_INI_DIR/conf.d/
COPY --from=composer-install /var/www/app/vendor/ vendor/
COPY --from=composer-install /var/www/app/.env.local.php ./
COPY bin/ bin/
COPY config/ config/
COPY public/ public/
COPY src/ src/
COPY templates/ templates/
