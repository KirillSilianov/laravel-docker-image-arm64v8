ARG PHP_VERSION_TAG=8.0.3

FROM arm64v8/php:${PHP_VERSION_TAG}-fpm-buster

ARG XDEBUG_VERSION_TAG=3.0.3

RUN set -eux && \
    apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        git \
        zip \
        libpq-dev \
        libonig-dev \
        libzip-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        unzip && \
    pecl install xdebug-${XDEBUG_VERSION_TAG} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-install \
        mbstring \
        intl \
        pdo \
        pdo_pgsql \
        pgsql \
        zip \
        exif \
        pcntl \
        gd && \
    pecl install -o -f redis && \
        rm -rf /tmp/pear && \
        docker-php-ext-enable redis && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY --chown=www ./entrypoints/entrypoint.sh /etc/etntrypoint.sh
RUN chmod +x /etc/etntrypoint.sh

USER www