FROM php:7.4.11-fpm-buster
LABEL maintainer="Hrishikesh Raverkar <hrishikesh.raverkar@gmail.com>"
RUN apt-get -qq update && apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    software-properties-common \
    autoconf \
    supervisor \
    gcc \
    g++ \
    make \
    cmake \
    curl \
    xvfb \
    wget \
    xorg \
    iputils-ping \
    imagemagick \
    ssh \
    git \
    telnet \
    zip \
    unzip \
    locate \
    net-tools \
    gnupg2 \
    default-mysql-client \
    libzip4 \
    libmcrypt4 \
    libmemcached11 \
    libc-client2007e \
    libpq5 \
    libaspell15 \
    libtidy5deb1 \
    libmemcachedutil2 \
    libjudydebian1 \
    libjudy-dev \
    libxslt1.1 \
    zlibc \
    libcurl4-openssl-dev \
    --no-install-recommends

# Install node latest version, add repo.
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod a+x /usr/local/bin/composer

# Install PHP extensions
RUN buildDeps=" \
    libicu-dev \
    libpq-dev \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libbz2-dev \
    libxslt-dev \
    libmemcached-dev \
    zlib1g-dev \
    libncurses5-dev \
    libc-client-dev \
    libkrb5-dev \
    libpspell-dev \
    libtidy-dev \
    libxml2-dev \
    libzip-dev \
    libssl-dev \
    libldap2-dev \
    libmagickwand-dev \
    libedit-dev \
    libonig-dev \
    " \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq update\
    && apt-get -y install $buildDeps nodejs --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    #### Install phpunit and put binary into $PATH ###
    && curl -sSo phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && chmod 755 phpunit.phar \
    && mv phpunit.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit \
    # Install PHP Code sniffer
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod 755 phpcs.phar \
    && mv phpcs.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcs.phar /usr/local/bin/phpcs \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod 755 phpcbf.phar \
    && mv phpcbf.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcbf.phar /usr/local/bin/phpcbf \
    # Install PHP extensions
    && docker-php-source extract \
    && mv /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 \
    && mv /usr/src/php/ext/libxml/config0.m4 /usr/src/php/ext/libxml/config.m4 \    
    ## Download Extra extensions
    && cd /usr/src/php/ext \
    ## elastic_apm
    && mkdir -p /home/apm-agent \
    && curl -fsSL https://github.com/elastic/apm-agent-php/archive/v0.2.zip -o /home/apm-agent/apm.zip \
    && unzip /home/apm-agent/apm.zip -d /home/apm-agent/ \
    && mv /home/apm-agent/apm-agent-php-0.2 /home/apm-agent/apm \
    && rm -rf /home/apm-agent/apm.zip \
    && cp -r /home/apm-agent/apm/src/ext /usr/src/php/ext/elastic_apm \
    # mcrypt
    && curl -fsSL https://pecl.php.net/get/mcrypt-1.0.3.tgz -o mcrypt.tar.gz \
    && mkdir -p mcrypt \
    && tar -xf mcrypt.tar.gz -C mcrypt --strip-components=1 \
    && rm mcrypt.tar.gz \
    # Memcached
    && curl -fsSL https://pecl.php.net/get/memcached-3.1.5.tgz -o memcached.tar.gz \
    && mkdir -p memcached \
    && tar -xf memcached.tar.gz -C memcached --strip-components=1 \
    && rm memcached.tar.gz \ 
    # Memcache
    && curl -fsSL https://pecl.php.net/get/memcache-4.0.5.2.tgz -o memcache.tar.gz \
    && mkdir -p memcache \
    && tar -xf memcache.tar.gz -C memcache --strip-components=1 \
    && rm memcache.tar.gz \
    # Php-Xdebug
    && curl -fsSL https://pecl.php.net/get/xdebug-2.9.8.tgz -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \ 
    # igbinary
    && curl -fsSL https://pecl.php.net/get/igbinary-3.1.5.tgz -o igbinary.tar.gz \
    && mkdir -p igbinary \
    && tar -xf igbinary.tar.gz -C igbinary --strip-components=1 \
    && rm igbinary.tar.gz \
    # redis
    && curl -fsSL https://pecl.php.net/get/redis-5.2.1.tgz -o redis.tar.gz \
    && mkdir -p redis \
    && tar -xf redis.tar.gz -C redis --strip-components=1 \
    && rm redis.tar.gz \
    # Imagick
    && curl -fsSL https://pecl.php.net/get/imagick-3.4.4.tgz -o imagick.tar.gz \
    && mkdir -p imagick \
    && tar -xf imagick.tar.gz -C imagick --strip-components=1 \
    && rm imagick.tar.gz \ 
    # memprof
    && curl -fsSL https://pecl.php.net/get/memprof-2.0.0.tgz -o memprof.tar.gz \
    && mkdir -p memprof \
    && tar -xf memprof.tar.gz -C memprof --strip-components=1 \
    && rm memprof.tar.gz \
    # msgpack
    && curl -fsSL https://pecl.php.net/get/msgpack-2.1.0.tgz -o msgpack.tar.gz \
    && mkdir -p msgpack \
    && tar -xf msgpack.tar.gz -C msgpack --strip-components=1 \
    && rm msgpack.tar.gz \
    # ds
    && curl -fsSL https://pecl.php.net/get/ds-1.2.9.tgz -o ds.tar.gz \
    && mkdir -p ds \
    && tar -xf ds.tar.gz -C ds --strip-components=1 \
    && rm ds.tar.gz \
    # solr
    && curl -fsSL https://pecl.php.net/get/solr-2.5.0.tgz -o solr.tar.gz \
    && mkdir -p solr \
    && tar -xf solr.tar.gz -C solr --strip-components=1 \
    && rm solr.tar.gz \
    # ast
    && curl -fsSL https://pecl.php.net/get/ast-1.0.6.tgz -o ast.tar.gz \
    && mkdir -p ast \
    && tar -xf ast.tar.gz -C ast --strip-components=1 \
    && rm ast.tar.gz \
    # mailparse
    && curl -fsSL https://pecl.php.net/get/mailparse-3.0.4.tgz -o mailparse.tar.gz \
    && mkdir -p mailparse \
    && tar -xf mailparse.tar.gz -C mailparse --strip-components=1 \
    && rm mailparse.tar.gz \
    # uploadprogress
    && curl -fsSL https://pecl.php.net/get/uploadprogress-1.1.2.tgz -o uploadprogress.tar.gz \
    && mkdir -p uploadprogress \
    && tar -xf uploadprogress.tar.gz -C uploadprogress --strip-components=1 \
    && rm uploadprogress.tar.gz \             
    # Configure extensions
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    && docker-php-ext-configure gettext \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure soap \
    && docker-php-ext-configure zip  --with-zip \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && CFLAGS="-std=gnu99" docker-php-ext-configure elastic_apm --enable-elastic_apm \
    && docker-php-ext-configure xdebug --enable-xdebug \    
    # Install php-apcu
    && pecl install apcu \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \    
    && docker-php-ext-install zlib igbinary \
    && docker-php-ext-configure redis --enable-redis-igbinary \
    && docker-php-ext-install bcmath \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    opcache \
    pcntl \
    soap \
    zip \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    imap \
    iconv \
    gd \
    ftp \
    bcmath \
    calendar \
    bz2 \
    xsl \
    xmlrpc \
    mysqli \
    pspell \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    # Extra extensions
    elastic_apm \
    mcrypt \    
    memcached \
    memcache \    
    xdebug \
    redis \
    imagick \
    memprof \
    msgpack \
    ds \
    solr \
    ast \
    mailparse \
    uploadprogress \
    # Clean system
    && apt-get purge -y $buildDeps \
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-source delete    

COPY wkhtmltopdf /usr/bin/wkhtmltopdf
COPY xvfb-run /usr/bin/xvfb-run
RUN chmod a+x /usr/bin/wkhtmltopdf \
    && chmod 755 /usr/bin/xvfb-run \
    && echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh \
    && chmod a+rx /usr/bin/wkhtmltopdf.sh

# Install Node.js/bower/gulp/grunt
RUN npm install bower gulp grunt-cli -g \
    # Disable xdebug for composer
    && alias composer="php -d xdebug.profiler_enable=0 -d memory_limit=-1 /usr/local/bin/composer"

RUN echo "date.timezone = 'UTC'" > /usr/local/etc/php/conf.d/defaults.ini \
    # Configer APM Defaults in ini
    && echo 'elastic_apm.bootstrap_php_part_file=/home/apm-agent/apm/src/bootstrap_php_part.php' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo 'elastic_apm.enabled=true' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; elastic_apm.log_level=DEBUG' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; Available Log levels' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; OFF | CRITICAL | ERROR | WARNING | NOTICE | INFO | DEBUG | TRACE' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; elastic_apm.server_url="http://docker.apm.server.localhost:8200"' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; elastic_apm.secret_token=' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; elastic_apm.service_name="PHP APM Test Service"' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini \
    && echo '; service_version= ${git rev-parse HEAD}' \
    >> /usr/local/etc/php/conf.d/docker-php-ext-elastic_apm.ini

EXPOSE 9000
