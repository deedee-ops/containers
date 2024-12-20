#!/usr/bin/env sh

/usr/local/sbin/php-fpm &
/usr/sbin/crond
sleep 1

/usr/local/bin/php /app/endpoints/cronjobs/createdatabase.php
/usr/local/bin/php /app/endpoints/db/migrate.php

mkdir -p /data/logos/avatars

/usr/local/bin/php /app/endpoints/cronjobs/updatenextpayment.php
/usr/local/bin/php /app/endpoints/cronjobs/updateexchange.php
/usr/local/bin/php /app/endpoints/cronjobs/checkforupdates.php

exec "$@"
