FROM php:fpm-alpine

COPY docker-entrypoint.sh php.ini default.conf cron.sh /
RUN apk add --no-cache \
        git \
        bash \
        nginx \
        tzdata \
        openssl \
        openssh && \
    mkdir -p /run/nginx && \
    mv /default.conf /etc/nginx/conf.d && \
    mv /php.ini /usr/local/etc/php && \
    chmod +x /docker-entrypoint.sh /cron.sh && \
    git clone -b beta https://github.com/1046329594/oneindex3.git /var/www/html && \
    ssh-keygen -A

# Persistent config file and cache
VOLUME [ "/var/www/html/config", "/var/www/html/cache" ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]
