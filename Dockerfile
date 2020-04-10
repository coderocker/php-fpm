FROM php:7.0.33-fpm-stretch
LABEL maintainer="Hrishikesh Raverkar <hrishikesh.raverkar@gmail.com>"
ENV XDEBUG_VERSION 2_4_0RC4
RUN apt-get -qq update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential \
    software-properties-common \
    checkinstall \
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
    mysql-client \
    locate \
    net-tools \
    --no-install-recommends
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
# RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# RUN apt-get -qq update
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
    " \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install $buildDeps nodejs --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-source extract && \
    mv /usr/src/php/ext/zlib/config0.m4 /usr/src/php/ext/zlib/config.m4 && \
    mv /usr/src/php/ext/libxml/config0.m4 /usr/src/php/ext/libxml/config.m4 \
    && docker-php-ext-configure bcmath --enable-bcmath && \
    docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ && \
    docker-php-ext-configure gettext && \
    docker-php-ext-configure intl --enable-intl && \
    docker-php-ext-configure mbstring --enable-mbstring && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure zip --enable-zip --with-libzip &&\
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
    mcrypt \
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
    # Install php-memcached
    && cd /usr/src/php/ext \
    && curl -fsSL https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz -o memcached.tar.gz \
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
    && curl -fsSL https://github.com/xdebug/xdebug/archive/XDEBUG_$XDEBUG_VERSION.tar.gz -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && docker-php-ext-configure xdebug --enable-xdebug \
    && docker-php-ext-install xdebug \
    # Install php-igbinary
    && curl -fsSL https://github.com/igbinary/igbinary7/archive/master.tar.gz -o igbinary.tar.gz \
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
    && curl -fsSL https://github.com/Jan-E/uploadprogress/archive/master.zip -o uploadprogress.zip \
    # && mkdir -p uploadprogress \
    && unzip uploadprogress.zip \
    && rm uploadprogress.zip \
    && mv uploadprogress-master uploadprogress \
    && docker-php-ext-install uploadprogress \    
    # Install php-wddx
    && docker-php-ext-configure wddx --enable-libxml \
    && docker-php-ext-install wddx \
    # Install composer and put binary into $PATH
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
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

# Install Node.js/bower/gulp/grunt
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
# RUN apt-get install -y nodejs
RUN npm install bower gulp grunt-cli -g \
    # Disable xdebug for composer
    && sed -i "s/zend_extension=/#zend_extension=/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # Load xdebug Zend extension with php command
    && alias php="php -dzend_extension=xdebug.so" \
    # PHPUnit needs xdebug for coverage. In this case, just make an alias with php command prefix.
    && alias phpunit="php $(which phpunit)"

COPY wkhtmltopdf /usr/bin/wkhtmltopdf
COPY xvfb-run /usr/bin/xvfb-run

RUN chmod a+x /usr/bin/wkhtmltopdf \
    && chmod 755 /usr/bin/xvfb-run \
    && echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh \
    && chmod a+rx /usr/bin/wkhtmltopdf.sh

EXPOSE 9000
