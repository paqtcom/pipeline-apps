FROM php:7.1-fpm

MAINTAINER Way2Web <developers@way2web.nl>

RUN DEBIAN_FRONTEND=noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}

# Prepare mysql install
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

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
        ssmtp \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) interbase \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) soap \
    && docker-php-ext-install -j$(nproc) xmlrpc \
    && docker-php-ext-install -j$(nproc) xsl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install zip
    
# Install mysql
RUN apt-get install -y \
    mysql-server \
    mysql-client

# Install usefull tools
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
RUN curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
    curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit  &&\
    curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
    curl -sSL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -o /usr/bin/phpcs && chmod +x /usr/bin/phpcs &&\
    curl -sSL https://phar.phpunit.de/phpcpd.phar -o /usr/bin/phpcpd && chmod +x /usr/bin/phpcpd &&\
    npm install --no-color --production --global gulp-cli webpack mocha grunt

# Clean up APT when done.
RUN apt-get autoclean && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
