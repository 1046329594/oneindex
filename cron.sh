#!/bin/bash
php /var/www/html/one.php cache:refresh
cd /var/www/html/cache
git add .
git commit -m "Update"
git push -u origin master
