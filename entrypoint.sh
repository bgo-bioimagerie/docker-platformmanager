#!/bin/bash
set -e

cp /var/www/platformmanager/Config/conf.ini.sample /var/www/platformmanager/Config/conf.ini
sed -i "s/MYSQL_URL/${MYSQL_HOST}/g" /var/www/platformmanager/Config/conf.ini
sed -i "s/MYSQL_DBNAME/${MYSQL_DBNAME}/g" /var/www/platformmanager/Config/conf.ini
sed -i "s/MYSQL_USER/${MYSQL_USER}/g" /var/www/platformmanager/Config/conf.ini
sed -i "s/MYSQL_PASS/${MYSQL_PASS}/g" /var/www/platformmanager/Config/conf.ini

# make sure this is not accessible from the webapp (no risk of leak)
unset MYSQL_USER
unset MYSQL_PASS

: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if test -f "$APACHE_ENVVARS"; then
    . "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
: "${APACHE_PID_FILE:=${APACHE_RUN_DIR:=/var/run/apache2}/apache2.pid}"
rm -f "$APACHE_PID_FILE"

exec apache2 &

sleep 2

curl http://localhost/update

wait
