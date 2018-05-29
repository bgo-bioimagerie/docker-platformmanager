FROM php:5.6-apache

MAINTAINER Sylvain Prigent <sylvain.prigent@univ-rennes1.fr>

# ENV TINI_VERSION v0.9.0
# RUN set -x \
#     && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" -o /usr/local/bin/tini \
#     && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" -o /usr/local/bin/tini.asc \
#     && export GNUPGHOME="$(mktemp -d)" \
#     && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
#     || gpg --keyserver pgp.mit.edu --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
#     && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
#     && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
#     && chmod +x /usr/local/bin/tini

# ENTRYPOINT ["/usr/local/bin/tini", "--"]

WORKDIR /var/www

VOLUME ["/var/www/platformmanager/data"]

# Install packages and PHP-extensions
RUN apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget nano at git \
    libfreetype6 libjpeg62 libpng12-0 libx11-6 libxpm4 zlib1g-dev && \
    BUILD_DEPS="libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libxpm-dev zlib1g-dev" && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install $BUILD_DEPS && \
    docker-php-ext-configure gd \
    --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu \
    --with-xpm-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu && \
    docker-php-ext-install gd pdo pdo_mysql mysqli zip && \
    a2enmod rewrite && \
    rm -rf /var/lib/apt/lists/* && \
    touch /var/log/php_errors.log && \
    chown www-data /var/log/php_errors.log && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $BUILD_DEPS && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

ADD php_logs.ini /usr/local/etc/php/conf.d/php_logs.ini
ADD apache2/platformmanager.conf /etc/apache2/conf-enabled/platformmanager.conf

# install Platform-Manager sources
RUN git clone git@github.com:bgo-bioimagerie/platformmanager.git platformmanager \
  && cd platformmanager \
  && git checkout a1e29979aa4510901a67be527c00845a8b12d2cb \
  && cd .. \
  && mkdir platformmanager/tmp \
  && chown -R www-data: platformmanager \
  && rm -rf html \
  && ln -s platformmanager html \
  && mkdir -p /etc/platformmanager \
  && cp platformmanager/Config/conf.ini.sample /etc/platformmanager/

RUN cd /var/www/platformmanager/externals/html2pdf \
  && composer install \
  && cd /var/www/

ENV MYSQL_HOST="mysql" \
    MYSQL_DBNAME="platformmanager" \
    MYSQL_USER="username" \
    MYSQL_PASS="password"

ADD entrypoint.sh /

RUN chmod a+x /entrypoint.sh

CMD ["/entrypoint.sh"]
