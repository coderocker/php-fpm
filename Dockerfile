FROM php:7.4.11-fpm-buster
LABEL maintainer="Hrishikesh Raverkar <hrishikesh.raverkar@gmail.com>"
RUN apt-get -qq update && apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    software-properties-common \
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
    libxslt1.1 \
    --no-install-recommends
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
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
    libcurl4-openssl-dev \
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
    libjudydebian1 \
    libjudy-dev \
    libldap2-dev \
    libmagickwand-dev \
    libedit-dev \
    libonig-dev \
    " \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install $buildDeps nodejs --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-source extract && \
    mv /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 && \
    mv /usr/src/php/ext/libxml/config0.m4 /usr/src/php/ext/libxml/config.m4 \
    && docker-php-ext-configure bcmath --enable-bcmath && \
    docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ && \
    docker-php-ext-configure gettext && \
    docker-php-ext-configure intl --enable-intl && \
    docker-php-ext-configure mbstring --enable-mbstring && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure zip  --with-zip &&\
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl &&\
    docker-php-ext-install zlib \
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
    # Install php-apcu
    && pecl install apcu \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \
    # Install php-mcrypt
    && cd /usr/src/php/ext \
    && curl -fsSL https://pecl.php.net/get/mcrypt-1.0.3.tgz -o mcrypt.tar.gz \
    && mkdir -p mcrypt \
    && tar -xf mcrypt.tar.gz -C mcrypt --strip-components=1 \
    && rm mcrypt.tar.gz \
    && docker-php-ext-install mcrypt \    
    # Install php-memcached
    && curl -fsSL https://pecl.php.net/get/memcached-3.1.5.tgz -o memcached.tar.gz \
    && mkdir -p memcached \
    && tar -xf memcached.tar.gz -C memcached --strip-components=1 \
    && rm memcached.tar.gz \
    && docker-php-ext-install memcached \
    # Install php-memcache
    && curl -fsSL https://pecl.php.net/get/memcache-4.0.5.2.tgz -o memcache.tar.gz \
    && mkdir -p memcache \
    && tar -xf memcache.tar.gz -C memcache --strip-components=1 \
    && rm memcache.tar.gz \
    && docker-php-ext-install memcache \    
    # Install php-xdebug
    && curl -fsSL https://pecl.php.net/get/xdebug-2.9.8.tgz -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && docker-php-ext-configure xdebug --enable-xdebug \
    && docker-php-ext-install xdebug \
    # Install php-igbinary
    && curl -fsSL https://pecl.php.net/get/igbinary-3.1.5.tgz -o igbinary.tar.gz \
    && mkdir -p igbinary \
    && tar -xf igbinary.tar.gz -C igbinary --strip-components=1 \
    && rm igbinary.tar.gz \
    && docker-php-ext-install igbinary \
    # Install php-redis
    && curl -fsSL https://pecl.php.net/get/redis-5.2.1.tgz -o redis.tar.gz \
    && mkdir -p redis \
    && tar -xf redis.tar.gz -C redis --strip-components=1 \
    && rm redis.tar.gz \
    && docker-php-ext-configure redis --enable-redis-igbinary \
    && docker-php-ext-install redis \
    # Install php-imagick
    && curl -fsSL https://pecl.php.net/get/imagick-3.4.4.tgz -o imagick.tar.gz \
    && mkdir -p imagick \
    && tar -xf imagick.tar.gz -C imagick --strip-components=1 \
    && rm imagick.tar.gz \
    && docker-php-ext-install imagick \
    # Install php-memprof (memory profiler)
    && curl -fsSL https://pecl.php.net/get/memprof-2.0.0.tgz -o memprof.tar.gz \
    && mkdir -p memprof \
    && tar -xf memprof.tar.gz -C memprof --strip-components=1 \
    && rm memprof.tar.gz \
    && docker-php-ext-install memprof \
    # Install php-msgpack 
    && curl -fsSL https://pecl.php.net/get/msgpack-2.1.0.tgz -o msgpack.tar.gz \
    && mkdir -p msgpack \
    && tar -xf msgpack.tar.gz -C msgpack --strip-components=1 \
    && rm msgpack.tar.gz \
    && docker-php-ext-install msgpack \   
    # Install php-ds 
    && curl -fsSL https://pecl.php.net/get/ds-1.2.9.tgz -o ds.tar.gz \
    && mkdir -p ds \
    && tar -xf ds.tar.gz -C ds --strip-components=1 \
    && rm ds.tar.gz \
    && docker-php-ext-install ds \
    # Install php-opencensus 
    && curl -fsSL https://pecl.php.net/get/opencensus-0.2.2.tgz -o opencensus.tar.gz \
    && mkdir -p opencensus \
    && tar -xf opencensus.tar.gz -C opencensus --strip-components=1 \
    && rm opencensus.tar.gz \
    && docker-php-ext-install opencensus \
    # Install php-solr 
    && curl -fsSL https://pecl.php.net/get/solr-2.5.0.tgz -o solr.tar.gz \
    && mkdir -p solr \
    && tar -xf solr.tar.gz -C solr --strip-components=1 \
    && rm solr.tar.gz \
    && docker-php-ext-install solr \
    # Install php-ast 
    && curl -fsSL https://pecl.php.net/get/ast-1.0.6.tgz -o ast.tar.gz \
    && mkdir -p ast \
    && tar -xf ast.tar.gz -C ast --strip-components=1 \
    && rm ast.tar.gz \
    && docker-php-ext-install ast \    
    # Install php-mailparse 
    && curl -fsSL https://pecl.php.net/get/mailparse-3.0.4.tgz -o mailparse.tar.gz \
    && mkdir -p mailparse \
    && tar -xf mailparse.tar.gz -C mailparse --strip-components=1 \
    && rm mailparse.tar.gz \
    && docker-php-ext-install mailparse \    
    # Install php-uploadprogress
    && curl -fsSL https://pecl.php.net/get/uploadprogress-1.1.2.tgz -o uploadprogress.tar.gz \
    && mkdir -p uploadprogress \
    && tar -xf uploadprogress.tar.gz -C uploadprogress --strip-components=1 \
    && rm uploadprogress.tar.gz \
    && docker-php-ext-install uploadprogress \
    # Install composer and put binary into $PATH
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --filename=composer --install-dir=/usr/local/bin/ \
    # Install phpunit and put binary into $PATH
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
    # Clean system
    && apt-get purge -y $buildDeps \
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-source delete
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
    && apt-get -y install libjudydebian1 \
    && apt-get autoremove -y \
    && apt-get clean
RUN echo "date.timezone = 'UTC'" > /usr/local/etc/php/conf.d/defaults.ini
# Install Node.js/bower/gulp/grunt
RUN npm install bower gulp grunt-cli -g \
    # Disable xdebug for composer
    && alias composer="php -d xdebug.profiler_enable=0 -d memory_limit=-1 /usr/local/bin/composer"

COPY wkhtmltopdf /usr/bin/wkhtmltopdf
COPY xvfb-run /usr/bin/xvfb-run

RUN chmod a+x /usr/bin/wkhtmltopdf \
    && chmod 755 /usr/bin/xvfb-run \
    && echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh \
    && chmod a+rx /usr/bin/wkhtmltopdf.sh

EXPOSE 9000
