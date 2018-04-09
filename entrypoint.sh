#!/bin/bash
set -e

cp /var/www/platformmanager/Config/conf.ini.sample /var/www/platformmanager/Config/conf.ini
sed -i 's/MYSQL_URL/${MYSQL_URL}/g' /var/www/platformmanager/Config/conf.ini
sed -i 's/MYSQL_URL/${MYSQL_DBNAME}/g' /var/www/platformmanager/Config/conf.ini
sed -i 's/MYSQL_USER/${MYSQL_USER}/g' /var/www/platformmanager/Config/conf.ini
sed -i 's/MYSQL_PASS/${MYSQL_PASS}/g' /var/www/platformmanager/Config/conf.ini

exec apache2-foreground

curl http://localhost/update

exit 1
