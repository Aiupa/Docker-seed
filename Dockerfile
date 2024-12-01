#syntax=docker/dockerfile:1

# BASE

# Use the official PHP image
FROM php:8.3-fpm as php_base

# Set the working directory
WORKDIR /app

# Define volumes (if needed when running via docker-compose)
VOLUME /app/var/

# Update package list and install persistent system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    acl \
    file \
    gettext \
    git \
    make \
    unzip \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install install-php-extensions
RUN wget -qO /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/raw/master/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

# Install additional PHP extensions
RUN set -eux; \
	install-php-extensions \
		@composer \
		apcu \
		intl \
		opcache \
		zip \
	;

# Allow Composer to run as superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# Set custom PHP configuration directory
ENV PHP_INI_SCAN_DIR="$PHP_INI_DIR:/app/conf.d"

COPY --link Docker/conf.d/app.ini $PHP_INI_DIR/app.conf.d/
COPY --link --chmod=755 Docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

HEALTHCHECK --start-period=60s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "php", "run", "--config" ]

# Dev env
FROM php_base as php_dev

ENV APP_ENV=dev XDEBUG_MODE=off

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

COPY --link Docker/conf.d/app.dev.ini $PHP_INI_DIR/app.conf.d/

CMD [ "php", "run", "--config" , "--watch"]

# PROD Env
FROM php_base as php_prod

ENV APP_ENV=prod

COPY --link Docker/conf.d/app.prod.ini $PHP_INI_DIR/app.conf.d/

# prevent the reinstallation of vendors at every changes in the source code
COPY --link composer.* symfony.* ./
RUN set -eux; \
	composer install --no-cache --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress

# copy sources
COPY --link . ./

RUN set -eux; \
	mkdir -p var/cache var/log; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	composer dump-env prod; \
	composer run-script --no-dev post-install-cmd; \
	chmod +x bin/console; sync;