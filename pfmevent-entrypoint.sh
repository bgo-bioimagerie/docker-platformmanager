#!/bin/bash
set -e

/setup.sh

/wait

cd /var/www/platformmanager
php ./bin/pfm-events.php
