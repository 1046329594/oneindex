#!/bin/bash
php /var/www/html/one.php cache:refresh
cd /var/www/html/cache
rm -rf .git
git init
git add .
git commit -m "Update"
git remote add origin git@github.com:1046329594/cache.git
git push -f origin master
