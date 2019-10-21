ARG PHP_VERSION="7.3"

FROM php:${PHP_VERSION}-fpm

# Install the PHP extention using "apt"
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    apt-utils \
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
    g++ \
  && apt-get autoremove -y \
  && apt-get clean

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
