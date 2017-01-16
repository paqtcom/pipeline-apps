FROM phusion/baseimage:latest

MAINTAINER Way2Web <developers@way2web.nl>

CMD ["/sbin/my_init"]

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}

# Add the "PHP 7" ppa
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

# Prepare mysql install
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update && \
    apt-get -y --no-install-recommends install locales apt-utils &&\
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
    locale-gen en_US.UTF-8 &&\
    /usr/sbin/update-locale LANG=en_US.UTF-8

# Install "PHP Extentions", "libraries", "Software's"
RUN apt-get install -y \
    php7.0-cli \
    php7.0-common \
    php7.0-curl \
    php7.0-json \
    php7.0-xml \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-pgsql \
    php7.0-soap \
    php7.0-sqlite \
    php7.0-sqlite3 \
    php7.0-zip \
    php7.0-memcached \
    php7.0-gd \
    pkg-config \
    php-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libssl-dev \
    libxml2-dev \
    xz-utils \
    libsqlite3-dev \
    sqlite3 \
    git \
    curl \
    vim \
    nano \
    postgresql-client \
    mysql-server \
    mysql-client \
&& apt-get clean

# Install nodejs    
RUN curl -sSL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get -y --no-install-recommends install nodejs &&\
    apt-get autoclean && apt-get clean && apt-get autoremove

# Install usefull tools
RUN apt-get update && apt-get install -y \
        git \
        mercurial \
        zip \
        vim

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Composer for Laravel/Codeigniter and other dependencies
RUN curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
    curl -sSL https://phar.phpunit.de/phpunit.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit  &&\
    curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
    npm install --no-color --production --global gulp-cli webpack mocha grunt

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*