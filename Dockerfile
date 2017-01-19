FROM php:7.1-fpm

MAINTAINER Way2Web <developers@way2web.nl>

RUN DEBIAN_FRONTEND=noninteractive

ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}

# Prepare mysql install
RUN echo "mysql-community-server mysql-community-server/root-pass password root" | debconf-set-selections &&\
echo "mysql-community-server mysql-community-server/re-root-pass password root" | debconf-set-selections

# Install mysql 5.6
RUN echo "mysql-apt-config mysql-apt-config/enable-repo select mysql-5.6" | debconf-set-selections
RUN curl -sSL http://repo.mysql.com/mysql-apt-config_0.2.1-1debian7_all.deb -o ./mysql-apt-config_0.2.1-1debian7_all.deb
RUN dpkg -i mysql-apt-config_0.2.1-1debian7_all.deb
RUN apt-get update && apt-get -y install mysql-server-5.6

# Install dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libcurl4-nss-dev \
        libc-client-dev \
        libkrb5-dev \
        firebird2.5-dev \
        libicu-dev \
        libxml2-dev \
        libxslt1-dev \
        libbz2-dev \
        ssmtp

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) bz2
RUN docker-php-ext-install -j$(nproc) mcrypt
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install -j$(nproc) interbase
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) xmlrpc
RUN docker-php-ext-install -j$(nproc) xsl
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install zip

# Install useful tools
RUN apt-get install -y \
    git \
    mercurial \
    zip \
    vim

# Install nodejs
RUN curl -sSL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get -y --no-install-recommends install nodejs

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Composer for Laravel/Codeigniter and other dependencies
RUN curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin
RUN curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit
RUN curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept
RUN curl -sSL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -o /usr/bin/phpcs && chmod +x /usr/bin/phpcs
RUN curl -sSL http://static.phpmd.org/php/latest/phpmd.phar -o /usr/bin/phpmd && chmod +x /usr/bin/phpmd
RUN curl -sSL https://phar.phpunit.de/phpcpd.phar -o /usr/bin/phpcpd && chmod +x /usr/bin/phpcpd
RUN npm install --no-color --production --global gulp-cli webpack mocha grunt

# Clean up APT when done.
RUN apt-get autoclean && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
