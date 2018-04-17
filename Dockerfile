FROM php:7-apache

MAINTAINER Sylvain Prigent <sylvain.prigent@univ-rennes1.fr>

ENV TINI_VERSION v0.9.0
RUN set -x \
    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" -o /usr/local/bin/tini \
    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" -o /usr/local/bin/tini.asc \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
    && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
    && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
    && chmod +x /usr/local/bin/tini

ENTRYPOINT ["/usr/local/bin/tini", "--"]

WORKDIR /var/www

VOLUME ["/var/www/platformmanager/data"]

# Install packages and PHP-extensions
RUN apt-get -q update && \
    && DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install

# install Platform-Manager sources
RUN wget https://github.com/bgo-bioimagerie/platformmanager/archive/V1.1.tar.gz
  && tar -xzvf V1.1.tar.gz \
  && cp V1.1 /var/www/platformmanager \
  && rm -rf V1.1.tar.gz V1.1

ENV MYSQL_URL="http://mysql:8080/" \
    MYSQL_DBNAME="platformmanager" \
    MYSQL_USER="username" \
    MYSQL_PASS="password" \

ADD entrypoint.sh

CMD ["/entrypoint.sh"]
