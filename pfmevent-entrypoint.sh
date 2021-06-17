#!/bin/bash
set -e

/setup.sh

cd /var/www/platformmanager
php ./bin/pfm-events.php
