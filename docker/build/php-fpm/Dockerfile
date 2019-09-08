FROM ubuntu:16.04
RUN set -ex \
    && rm -rf /tmp/repimport \
    && mkdir -m 700 /tmp/repimport \
    && LC_ALL=C.UTF-8 gpg \
        --homedir /tmp/repimport \
        --keyserver keyserver.ubuntu.com \
        --recv-key 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C \
    && LC_ALL=C.UTF-8 gpg \
        --homedir /tmp/repimport \
        -a \
        --export 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C \
        | apt-key add - \
    && rm -rf /tmp/repimport \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" \
        > /etc/apt/sources.list.d/ondrej-ubuntu-php-xenial.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python \
        python-pip \
        python-setuptools \
        supervisor \
        rsyslog \
        ca-certificates \
        file \
        git \
        re2c \
        unzip \
        netcat \
        php7.3-fpm \
        php7.3-common \
        php7.3-cli \
        php7.3-phpdbg \
        php7.3-json \
        php7.3-opcache \
        php7.3-readline \
        php7.3-bcmath \
        php7.3-curl \
        php7.3-gd \
        php7.3-gmp \
        php7.3-imap \
        php7.3-intl \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-pgsql \
        php7.3-soap \
        php7.3-sqlite3 \
        php7.3-xml \
        php7.3-zip \
        php-imagick \
        php-redis \
        php-sodium \
        php-xdebug \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN set -ex \
    && cd /tmp \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && chmod +x /usr/bin/composer \
    && rm -rf /tmp/*

RUN set -ex \
    && mkdir -p /opt/data \
    && chown www-data:www-data /opt/data \
    && mkdir -p /var/www/html \
    && chown www-data:www-data /var/www/html \
    && mkdir -p /run/php \
	&& cd /etc/php/7.3/fpm \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee pool.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = 9000'; \
	} | tee pool.d/zz-docker.conf

COPY docker-php-entrypoint /usr/local/bin/
COPY /supervisor/startup.sh /startup.sh

ENTRYPOINT ["docker-php-entrypoint"]

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm7.3"]
