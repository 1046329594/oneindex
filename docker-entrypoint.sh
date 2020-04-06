#!/bin/bash
ln -sf /usr/share/zoneinfo/${TZ:-"Asia/Shanghai"} /etc/localtime
echo ${TZ:-"Asia/Shanghai"} > /etc/timezone
sed -i "s|listen 80|listen ${PORT:-80}|" /etc/nginx/conf.d/default.conf
chown -R www-data:www-data /var/www/html/cache
chown -R www-data:www-data /var/www/html/config
php /var/www/html/one.php token:refresh
php-fpm & nginx '-g daemon off;'
