#!/bin/bash

# timezone
ln -sf /usr/share/zoneinfo/${TZ:-"Asia/Shanghai"} /etc/localtime
echo ${TZ:-"Asia/Shanghai"} > /etc/timezone

# sshd
if [ -n "${SSH_PASSWORD}" ];then
    mkdir -p /var/run/sshd
    echo root:${SSH_PASSWORD} | chpasswd
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    /usr/sbin/sshd
fi

# crontab
if [ -z $DISABLE_CRON ];then
    REFRESH_TOKEN=${REFRESH_TOKEN:-"0 * * * *"}
    REFRESH_CACHE=${REFRESH_CACHE:-"*/10 * * * *"}
    rm -rf /tmp/cron.`whoami`
    echo "${REFRESH_TOKEN} php /var/www/html/one.php token:refresh" >> /tmp/cron.`whoami`
    echo "${REFRESH_CACHE} php /var/www/html/one.php cache:refresh" >> /tmp/cron.`whoami`
    crontab -u `whoami` /tmp/cron.`whoami`
    crond
fi

sed -i "s|listen 80|listen ${PORT:-80}|" /etc/nginx/conf.d/default.conf
chown -R www-data:www-data /var/www/html/cache
chown -R www-data:www-data /var/www/html/config

echo "<?php return array (
  'site_name' => '2022届教改1班',
  'password' => '$PASS',
  'style' => 'material',
  'onedrive_root' => '/class/',
  'cache_type' => 'filecache',
  'cache_expire_time' => 4000,
  'cache_refresh_time' => 600,
  'root_path' => '?',
  'client_secret' => 'DWs7pBgkE25d_VIUAFeu?A0X-?2QBBwU',
  'client_id' => '9d375a98-3791-46a2-ae28-4a4291fe31e6',
  'redirect_uri' => 'https://www.2022class1.ga/',
  'one_prefix' => 'alphaone-my',
  'refresh_token' => '$TOKEN',
  'app_url' => 'https://alphaone-my.sharepoint.cn/',
  );">/var/www/html/config/base.php
  
php /var/www/html/one.php token:refresh
php /var/www/html/one.php cache:refresh

php-fpm & nginx '-g daemon off;'
