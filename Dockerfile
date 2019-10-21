ARG PHP_VERSION="7.3"

FROM php:${PHP_VERSION}-fpm

# Install the PHP extention using "apt"
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libzip-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    mcrypt \
    zlib1g-dev \
    libicu-dev \
    libpq-dev \
    libssl-dev \
    gettext \
    g++

# Install the PHP extention using "docker-php-ext"
RUN docker-php-ext-install gettext \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  && docker-php-ext-install zip \
  && docker-php-ext-install pdo_mysql \
  && docker-php-ext-install exif \
  && docker-php-ext-enable exif \
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
  && docker-php-ext-install gd \
  && rm -rf /var/lib/apt/lists/*

# Install mcrypt in PHP > 7.1 (deprecated)
RUN apt-get -y install libmcrypt-dev && \
  pecl install mcrypt-1.0.2 && \
  docker-php-ext-enable mcrypt

# Install 'xdebug-2.5.5' for PHP 7
RUN pecl install xdebug && docker-php-ext-enable xdebug \
  && echo 'zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)' >> /usr/local/etc/php/php.ini \
  && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/php.ini \
  && echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini \
  && echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/php.ini

# Sync extension files in php container
RUN echo extension=gettext.so > /usr/local/etc/php/conf.d/gettext.ini
RUN echo extension=mcrypt.so > /usr/local/etc/php/php.ini
