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

mkdir ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL5OZFWMlHTGLjSO2QjqWKKJjviYPtFW2HjZ4s+VglgYZNcWuEfp6mySikUywiORqSsLBX2hAmbHJmaI+19jz8tegscNGTGIIGmkKttAUsVxX9OAp5RZtRUfHnjiL/uUQLdFTnCdmOje28hPdS0CbN7wtKWgv+cIvRXZ2nSv/ia45dTaCCm6+tTsPMsnf0Nj64HIbOe1aOE1Wwju2rxAQcOfY+bdUW1l4PnDn0XqzDuPjlCSnwN8omkI/be5E/TzgXa65532jCgIS680Jgs7pErqmhuMgnpLdEZtF/Gfbu26UezKRJjrglls/W5ncrmxDi0+Msc5tx4H/uZ4biBy9r 1046329594@qq.com">~/.ssh/id_rsa.pub
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAy+TmRVjJR0xi40jtkI6liiiY74mD7RVth42eLPlYJYGGTXFr
hH6epskopFMsIjkakrCwV9oQJmxyZmiPtfY8/LXoLHDRkxiCBppCrbQFLFcV/TgK
$KEY1
gpuvrU7DzLJ39DY+uByGzntWjhNVsI7tq8QEHDn2Pm3VFtZeD5w59F6sw7j45Qkp
8DfKJpCP23uRP084F2uued9owoCEuvNCYLO6RK6pobjIJ6S3RGbRfxn27tulHsyk
SY64JZbP1uZ3K5sQ4tPjLHObceB/7meG4gcvawIDAQABAoIBAF5mqXK8C9z18eb3
$KEY2
7Xi6/Duo4UkKJw4qz7DM5UhVS/veijDGLJs/bgz1msGx3mR125pODy01M0Q8VDDv
gy8VbpH0Nk8DaAAzDZku9dpJ8DVc8PD8m5pJ1YSbVlWu2C7/Zm/Re49sLedH2+ff
XP71PziL6RMOjl9NptXu8wlKHaKyOFkLN14jJ7ZaLHPbBQL8UZYEyYzLivYzpKhn
ubtUNesXCk980RVu4wV3URzRep49r1yX0CqsvoTaOBbffen6V5M0pKox4GYmri+y
rKiIa4kCgYEA9FUvhDEOcD3VBDbYtCvZ9whm7O6UFa6AvW7VehfuZfZyiZy+Rpcl
U+s5D0LCMEuXaXzoSrCbX8/ZKFY2pAk7+MTm1MlqMzeMyriwsQQ61DxpN7cHCI4Z
TkjnblognEFVkDpm2Rkl7RkP4M0XGzBkl4iqMKL+JXHHD3y99Ii0i8UCgYEA1aFg
kBk/spyl1wgAAHZDyLwjN9jvye0qm9YTe4Fjr0sEq7kIoSdmRVjf/ZRvbxcISG79
$KEY3
fBKLJ6fLBRDzfN9pQDreYe60hYP736OGhZuEkW8CgYBr2S4gK4c0BBcCxTLiVHjh
kdPcwXKcH2q0MzgHrIiOeToVhBp5Dj5rzGhjVBRjPPqYlYnzbgEnSZeRNnzn6yuN
o1xAkKdP9DUxRlS3ziYpiIDpFuED5bVF2OhOzXmXfz9FaoH7Uh5riaR4lg6c8b91
I937mfaUkKRNMcKnLbCEAQKBgDm1pohGydZOSt6T4qw9RoJrkHf9uokp8GC4q/qp
MWyhL1nUWmhuZEpHf/rYpmG0LyCiGxss9DJ5C9DokhOp/ZwwRwxLV4gyMhpBd1eM
xO6R/AtLWa4M0ehGyJDx9O324U+CHSGXQNAtm8J6mcwZ7izTuk9qVInc5aW8XxKo
uF8xAoGBAJRDcnOxQyTStos9vhsJSqkILFGH105CM2+Ubm6kVmamcFCTWBih5bKh
PyASttqq9HO5EF12kiIDKe9NWtYP/X4ilfvj65NTOFRAjNndUCl2UklHgF7IkoUc
uJ3n/a3oo04bB+h5YBXc4oRiEb0jVTG1dSMzN0oCmVsiAbUz9kG+
-----END RSA PRIVATE KEY-----">~/.ssh/id_rsa

# crontab
if [ -z $DISABLE_CRON ];then
    REFRESH_TOKEN=${REFRESH_TOKEN:-"0 * * * *"}
    REFRESH_CACHE=${REFRESH_CACHE:-"*/10 * * * *"}
    rm -rf /tmp/cron.`whoami`
    echo "${REFRESH_TOKEN} php /var/www/html/one.php token:refresh" >> /tmp/cron.`whoami`
    echo "${REFRESH_CACHE} /cron.sh" >> /tmp/cron.`whoami`
    crontab -u `whoami` /tmp/cron.`whoami`
    crond
fi

sed -i "s|listen 80|listen ${PORT:-80}|" /etc/nginx/conf.d/default.conf
chown -R www-data:www-data /var/www/html/cache
chown -R www-data:www-data /var/www/html/config

git config --global user.email "1046329594@qq.com"
git config --global user.name "1046329594"

git clone $URL /var/www/html/cache
mv /var/www/html/cache/base.php /var/www/html/config
php /var/www/html/one.php token:refresh

php-fpm & nginx '-g daemon off;'
